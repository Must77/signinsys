<template>
  <div class="app-container">
    <!-- 顶部切换 -->
    <el-radio-group v-model="activeTab" @change="getList" size="small" style="margin-bottom:10px">
      <el-radio-button label="pending">我的待签到</el-radio-button>
      <el-radio-button label="all">我的所有签到</el-radio-button>
    </el-radio-group>

    <!-- 查询条件（仅我的所有签到显示） -->
    <el-form v-show="activeTab === 'all'" :model="queryParams" ref="queryForm" :inline="true" label-width="100px">
      <el-form-item label="活动名称" prop="title">
        <el-input v-model="queryParams.title" placeholder="请输入" clearable size="small"
          @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="活动状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择" clearable size="small">
          <el-option label="未开始" value="0" />
          <el-option label="进行中" value="1" />
          <el-option label="已结束" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item label="我的签到状态">
        <el-select v-model="queryParams.signStatus" placeholder="请选择" clearable size="small">
          <el-option label="未签到" value="0" />
          <el-option label="已签到" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 数据表格 -->
    <el-table v-loading="loading" :data="signinList" border>
      <el-table-column label="记录ID" prop="recordId" width="80" />
      <el-table-column label="活动名称" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="课程名称" prop="courseName" width="100" />
      <el-table-column label="班级名称" prop="deptName" width="100" />
      <el-table-column label="开始时间" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.startTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="结束时间" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.endTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="活动状态" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === '0'">未开始</el-tag>
          <el-tag type="success" v-else-if="scope.row.status === '1'">进行中</el-tag>
          <el-tag type="danger" v-else>已结束</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="我的签到" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.mySigninStatus === '1'" type="success">已签到</el-tag>
          <el-tag v-else-if="scope.row.status !== '1'" type="info">不可签</el-tag>
          <el-tag v-else type="warning">未签到</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="120" align="center">
        <template slot-scope="scope">
          <el-button size="mini" type="primary" @click="handleSignin(scope.row)" v-hasPermi="['system:signin:do']"
            :disabled="scope.row.status !== '1' || scope.row.mySigninStatus === '1'">
            签到
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页（仅全部活动） -->
    <pagination v-show="activeTab === 'all' && total > 0" :total="total" :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize" @pagination="getList" />
  </div>
</template>

<script>
import { listSigninRecord, doSignin, listMyPendingSignin } from '@/api/system/userSignin'

export default {
  name: 'MySignin',
  data() {
    return {
      activeTab: 'pending', // 默认待签到
      loading: true,
      signinList: [],
      total: 0,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        title: undefined,
        status: undefined,
        signStatus: undefined
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      const done = (rows, total) => {
        this.signinList = rows
        this.total = total
        this.loading = false
      }
      if (this.activeTab === 'pending') {
        listMyPendingSignin().then(res => {
            console.log('myPending row:', res.rows?.[0])   // ← 加这里

          const rows = (res.rows || []).map(r => ({
            ...r,
            mySigninStatus: '0', // 接口只返未签到
            status: '1'          // 接口只返进行中
          }))
          done(rows, rows.length)
        }).catch(() => done([], 0))
      } else {
        listSigninRecord(this.queryParams).then(res => {
            console.log('list row:', res.rows?.[0])

          const rows = (res.rows || []).map(r => ({
            ...r,
            mySigninStatus: r.signStatus === '1' ? '1' : '0'
          }))
          done(rows, res.total || 0)
        }).catch(() => done([], 0))
      }
    },

    // getList() {
    //   this.loading = true
    //   console.log('请求参数：', this.queryParams)   // 看过滤条件
    //   myLeave(this.queryParams).then(res => {
    //     console.log('列表返回：', res)              // 看整体
    //     console.log('data：', res.data)            // 看数组
    //     this.leaveList = res.data || []            // ← 用 data
    //     this.total = res.total || 0
    //     this.loading = false
    //   }).catch(() => { this.loading = false })
    // },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },
    handleSignin(row) {
      this.$confirm('确认签到？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() =>
        doSignin(row.recordId).then(() => {
          this.$message.success('签到成功')
          this.getList() // 刷新当前Tab
        })
      )
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
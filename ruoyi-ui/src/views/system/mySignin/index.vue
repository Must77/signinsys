<template>
  <div class="app-container">
    <el-tabs v-model="activeTab" @tab-click="handleTabClick">
      <!-- 我的待签到 -->
      <el-tab-pane label="我的待签到" name="pending">
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
          <el-table-column label="我的签到" width="100">
            <template slot-scope="scope">
              <el-tag type="warning">未签到</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="primary" @click="handleSignin(scope.row)" v-hasPermi="['system:signinRecord:doSignin']"
                :disabled="getActivityStatus(scope.row.startTime, scope.row.endTime) !== '进行中'">
                签到
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum"
          :limit.sync="queryParams.pageSize" @pagination="getList" />
      </el-tab-pane>
      
      <!-- 我的所有签到活动 -->
      <el-tab-pane label="我的所有签到活动" name="all">
        <!-- 查询条件 -->
        <el-form :model="queryParams" ref="queryForm" :inline="true" label-width="100px">
          <el-form-item label="活动名称" prop="title">
            <el-input v-model="queryParams.title" placeholder="请输入活动名称" clearable size="small"
              @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="活动状态" prop="status">
            <el-select v-model="queryParams.status" placeholder="请选择活动状态" clearable size="small">
              <el-option label="未开始" value="0" />
              <el-option label="进行中" value="1" />
              <el-option label="已结束" value="2" />
            </el-select>
          </el-form-item>
          <el-form-item label="我的签到状态">
            <el-select v-model="queryParams.signStatus" placeholder="请选择签到状态" clearable size="small">
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
              <el-button size="mini" type="primary" @click="handleSignin(scope.row)"
                :disabled="scope.row.status !== '1' || scope.row.mySigninStatus === '1'">
                签到
              </el-button>
            </template>
          </el-table-column>
        </el-table>

        <!-- 分页 -->
        <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum"
          :limit.sync="queryParams.pageSize" @pagination="getList" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import { listMyPendingSignin, listSigninRecord, doSignin } from '@/api/system/userSignin'

export default {
  name: 'MySignin',
  data() {
    return {
      activeTab: 'pending', // 默认激活的标签页
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
    // 获取活动状态
    getActivityStatus(startTime, endTime) {
      const now = new Date()
      const start = new Date(startTime)
      const end = new Date(endTime)
      
      if (now < start) {
        return '未开始'
      } else if (now > end) {
        return '已结束'
      } else {
        return '进行中'
      }
    },
    
    // 标签页切换
    handleTabClick(tab) {
      this.queryParams.pageNum = 1
      this.getList()
    },
    
    // 获取列表数据
    getList() {
      this.loading = true
      
      if (this.activeTab === 'pending') {
        // 我的待签到
        const params = {
          pageNum: this.queryParams.pageNum,
          pageSize: this.queryParams.pageSize
        }
        listMyPendingSignin(params).then(res => {
          if (res.rows && Array.isArray(res.rows)) {
            // TableDataInfo格式
            this.signinList = res.rows || []
            this.total = res.total || this.signinList.length
          } else if (res.data && Array.isArray(res.data)) {
            // AjaxResult格式，数据在data中
            this.signinList = res.data || []
            this.total = this.signinList.length
          } else {
            // 其他格式
            this.signinList = []
            this.total = 0
          }
          this.loading = false
        }).catch(() => {
          this.signinList = []
          this.total = 0
          this.loading = false
        })
      } else {
        // 我的所有签到活动
        // 处理签到状态筛选参数
        const params = { ...this.queryParams }
        if (params.signStatus !== undefined && params.signStatus !== '') {
          // 将前端的signStatus映射为后端的status参数
          params.status = params.signStatus
          delete params.signStatus
        }
        
        listSigninRecord(params).then(res => {
          // 修复数据格式问题，兼容TableDataInfo和AjaxResult格式
          let rows = [];
          let total = 0;
          
          if (res.rows && Array.isArray(res.rows)) {
            // TableDataInfo格式
            rows = res.rows || [];
            total = res.total || rows.length;
          } else if (Array.isArray(res.data)) {
            // AjaxResult格式，数据在data中
            rows = res.data || [];
            total = rows.length;
          } else if (res.data && res.data.rows && Array.isArray(res.data.rows)) {
            // data中包含rows的嵌套格式
            rows = res.data.rows || [];
            total = res.data.total || rows.length;
          }
          
          rows = rows.map(r => ({
            ...r,
            mySigninStatus: r.status === '1' ? '1' : '0'
          }))
          this.signinList = rows
          this.total = total
          this.loading = false
        }).catch(() => {
          this.signinList = []
          this.total = 0
          this.loading = false
        })
      }
    },

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
          this.getList()
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
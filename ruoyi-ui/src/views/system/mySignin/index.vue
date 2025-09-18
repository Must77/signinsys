<template>
  <div class="app-container">
    <!-- 查询条件 -->
    <el-form :model="queryParams" ref="queryForm" :inline="true" label-width="100px">
      <el-form-item label="签到活动名称" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="请输入签到活动名称"
          clearable
          size="small"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="签到状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择签到状态" clearable size="small">
          <el-option label="未开始" value="0"></el-option>
          <el-option label="进行中" value="1"></el-option>
          <el-option label="已结束" value="2"></el-option>
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
      <el-table-column label="签到活动名称" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="课程ID" prop="courseId" width="100" />
      <el-table-column label="部门ID" prop="deptId" width="100" />
      <el-table-column label="开始时间" prop="startTime" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.startTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="结束时间" prop="endTime" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.endTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="签到状态" width="120">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === '0'">未开始</el-tag>
          <el-tag type="success" v-else-if="scope.row.status === '1'">进行中</el-tag>
          <el-tag type="danger" v-else-if="scope.row.status === '2'">已结束</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="我的签到状态" width="120">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === '1' && scope.row.mySigninStatus === '1'" type="success">已签到</el-tag>
          <el-tag v-else-if="scope.row.status !== '1'" type="info">不可签到</el-tag>
          <el-tag v-else type="warning">未签到</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" align="center">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleSignin(scope.row)"
            v-hasPermi="['system:signin:do']"
            :disabled="scope.row.status !== '1' || scope.row.mySigninStatus === '1'"
          >签到</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script>
import { listSigninRecord, doSignin } from '@/api/system/userSignin'

export default {
  name: 'MySignin',
  data() {
    return {
      loading: true,
      signinList: [],
      total: 0,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        title: undefined,
        status: undefined
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** 查询签到记录列表 */
    getList() {
      this.loading = true
      listSigninRecord(this.queryParams).then(response => {
        if (response.code === 200) {
          // 处理返回的数据，添加我的签到状态字段
          const records = response.rows || []
          records.forEach(record => {
            // 根据status字段设置我的签到状态
            // status为1表示已签到，0表示未签到
            record.mySigninStatus = record.status === '1' ? '1' : '0'
          })
          
          this.signinList = records
          this.total = response.total || 0
        }
        this.loading = false
      }).catch(() => {
        this.loading = false
      })
    },

    /** 搜索查询 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },

    /** 重置查询条件 */
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },

    /** 签到 */
    handleSignin(row) {
      this.$confirm('确认要签到吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 调用签到接口
        doSignin(row.recordId).then(response => {
          if (response.code === 200) {
            this.$message.success('签到成功')
            // 更新当前行的签到状态
            row.mySigninStatus = '1'
            row.status = '1'
          } else {
            this.$message.error(response.msg || '签到失败')
          }
        }).catch(() => {
          this.$message.error('签到失败')
        })
      }).catch(() => {
        this.$message.info('已取消签到')
      })
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
<template>
  <div class="app-container">
    <el-form :inline="true" size="small" v-show="showSearch" :model="queryParams">
      <el-form-item label="状态">
        <el-select v-model="queryParams.status" placeholder="全部" clearable>
          <el-option label="待审核" value="0"/>
          <el-option label="已通过" value="1"/>
          <el-option label="已拒绝" value="2"/>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-form>

    <el-table v-loading="loading" :data="list">
      <el-table-column label="申请ID" prop="applyId" width="90"/>
      <el-table-column label="申请人" prop="userName"/>
      <el-table-column label="部门" prop="deptName"/>
      <el-table-column label="状态" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status==='0'">待审核</el-tag>
          <el-tag type="success" v-else-if="scope.row.status==='1'">已通过</el-tag>
          <el-tag type="danger" v-else>已拒绝</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="申请时间" prop="createTime" width="160"/>
      <el-table-column label="操作" width="220" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="handleApprove(scope.row)" v-hasPermi="['system:deptApply:approve']" :disabled="scope.row.status!=='0'">通过</el-button>
          <el-button size="mini" type="warning" @click="handleReject(scope.row)" v-hasPermi="['system:deptApply:reject']" :disabled="scope.row.status!=='0'">拒绝</el-button>
          <el-button size="mini" type="danger" @click="handleDelete(scope.row)" v-hasPermi="['system:deptApply:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList"/>
  </div>
</template>

<script>
import { listDeptApply, approveDeptApply, rejectDeptApply, delDeptApply } from '@/api/system/deptApply'

export default {
  name: 'DeptApply',
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      list: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        status: ''
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() {
      this.loading = true
      listDeptApply(this.queryParams).then(res => {
        this.list = res.rows
        this.total = res.total
        this.loading = false
      }).catch(_ => { this.loading = false })
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.queryParams = { pageNum: 1, pageSize: 10, status: '' }; this.getList() },
    handleApprove(row) {
      this.$modal.confirm(`确定通过【${row.userName}】加入【${row.deptName}】吗？`).then(() => {
        return approveDeptApply(row.applyId)
      }).then(() => { this.$modal.msgSuccess('已通过'); this.getList() })
    },
    handleReject(row) {
      this.$modal.confirm(`确定拒绝该申请吗？`).then(() => {
        return rejectDeptApply(row.applyId)
      }).then(() => { this.$modal.msgSuccess('已拒绝'); this.getList() })
    },
    handleDelete(row) {
      this.$modal.confirm(`确认删除申请ID=${row.applyId}吗？`).then(() => {
        return delDeptApply(row.applyId)
      }).then(() => { this.$modal.msgSuccess('已删除'); this.getList() })
    }
  }
}
</script>

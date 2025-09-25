<template>
  <div class="app-container">
    <!-- 顶部查询 -->
    <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="80px">
      <el-form-item label="请假人">
        <el-input v-model="queryParams.userName" placeholder="请输入姓名" clearable />
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="queryParams.status" clearable>
          <el-option label="待审批" value="0"/>
          <el-option label="已通过" value="1"/>
          <el-option label="已拒绝" value="2"/>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 工具栏 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          v-hasPermi="['system:leave:add']"
          type="primary"
          plain
          icon="el-icon-plus"
          @click="handleAdd"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          v-hasPermi="['system:leave:remove']"
          type="danger"
          plain
          icon="el-icon-delete"
          :disabled="multiple"
          @click="handleDelete"
        >删除</el-button>
      </el-col>
    </el-row>

    <!-- 表格 -->
    <el-table v-loading="loading" :data="leaveList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column prop="leaveId" label="编号" width="80" />
      <el-table-column prop="userName" label="请假人" />
      <el-table-column prop="leaveType" label="类型" :formatter="typeFmt" />
      <el-table-column prop="startDate" label="开始时间" width="160" />
      <el-table-column prop="endDate" label="结束时间" width="160" />
      <el-table-column prop="reason" label="事由" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status==='0'">待审批</el-tag>
          <el-tag type="success" v-else-if="scope.row.status==='1'">已通过</el-tag>
          <el-tag type="danger" v-else>已拒绝</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="220">
        <template slot-scope="scope">
          <el-button size="mini" type="text" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button size="mini" type="text" @click="handleDetail(scope.row)">详情</el-button>
          <el-button
            v-if="scope.row.status==='0'"
            v-hasPermi="['system:leave:approve']"
            size="mini"
            type="text"
            @click="handleApprove(scope.row)"
          >通过</el-button>
          <el-button
            v-if="scope.row.status==='0'"
            v-hasPermi="['system:leave:reject']"
            size="mini"
            type="text"
            @click="handleReject(scope.row)"
          >拒绝</el-button>
          <el-button size="mini" type="text" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 新增/修改弹窗 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="请假类型" prop="leaveType">
          <el-select v-model="form.leaveType">
            <el-option label="事假" value="1"/>
            <el-option label="病假" value="2"/>
            <el-option label="年假" value="3"/>
          </el-select>
        </el-form-item>
        <el-form-item label="开始时间" prop="startDate">
          <el-date-picker v-model="form.startDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"/>
        </el-form-item>
        <el-form-item label="结束时间" prop="endDate">
          <el-date-picker v-model="form.endDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"/>
        </el-form-item>
        <el-form-item label="请假事由" prop="reason">
          <el-input v-model="form.reason" type="textarea" :rows="3"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="open=false">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 详情抽屉 -->
    <el-drawer title="请假详情" :visible.sync="drawer" size="50%">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="编号">{{ detail.leaveId }}</el-descriptions-item>
        <el-descriptions-item label="请假人">{{ detail.userName }}</el-descriptions-item>
        <el-descriptions-item label="类型">{{ typeFmt(null,null,detail.leaveType) }}</el-descriptions-item>
        <el-descriptions-item label="开始时间">{{ detail.startDate }}</el-descriptions-item>
        <el-descriptions-item label="结束时间">{{ detail.endDate }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ statusFmt(null,null,detail.status) }}</el-descriptions-item>
        <el-descriptions-item label="事由" :span="2">{{ detail.reason }}</el-descriptions-item>
      </el-descriptions>
    </el-drawer>
  </div>
</template>

<script>
import {
  listLeave,
  getLeave,
  addLeave,
  updateLeave,
  delLeave,
  approveLeave,
  rejectLeave
} from '@/api/system/leave'

export default {
  name: 'Leave',
  data() {
    return {
      loading: false,
      leaveList: [],
      total: 0,
      title: '',
      open: false,
      drawer: false,
      single: true,
      multiple: true,
      ids: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: '',
        status: ''
      },
      form: {
        leaveId: undefined,
        leaveType: '1',
        startDate: '',
        endDate: '',
        reason: ''
      },
      rules: {
        leaveType: [{ required: true, message: '请选择类型', trigger: 'change' }],
        startDate: [{ required: true, message: '请选择开始时间', trigger: 'change' }],
        endDate: [{ required: true, message: '请选择结束时间', trigger: 'change' }],
        reason: [{ required: true, message: '请填写事由', trigger: 'blur' }]
      },
      detail: {}
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listLeave(this.queryParams).then(response => {
        if (response.code === 200) {
          this.leaveList = response.rows || []
          this.total = response.total || 0
        } else {
          this.leaveList = []
          this.total = 0
        }
        this.loading = false
      }).catch(() => { 
        this.leaveList = []
        this.total = 0
        this.loading = false 
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.queryParams.userName = ''
      this.queryParams.status = ''
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(i => i.leaveId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.form = { leaveId: undefined, leaveType: '1', startDate: '', endDate: '', reason: '' }
      this.open = true
      this.title = '新增请假'
    },
    handleUpdate(row) {
      const leaveId = row?.leaveId || this.ids[0]
      getLeave(leaveId).then(res => {
        this.form = Object.assign({}, res.data || {})
        this.open = true
        this.title = '修改请假'
      })
    },
    handleDetail(row) {
      this.detail = Object.assign({}, row)
      this.drawer = true
    },
    submitForm() {
      this.$refs.formRef.validate(valid => {
        if (!valid) return
        const api = this.form.leaveId ? updateLeave : addLeave
        api(this.form).then(() => {
          this.$message.success(this.form.leaveId ? '修改成功' : '新增成功')
          this.open = false
          this.getList()
        })
      })
    },
    handleDelete(row) {
      const leaveIds = row?.leaveId ? [row.leaveId] : this.ids
      if (!leaveIds.length) return
      this.$confirm('确认删除选中的请假记录吗？', '提示', { type: 'warning' })
        .then(() => delLeave(leaveIds.join(',')))
        .then(() => {
          this.$message.success('删除成功')
          this.getList()
        })
    },
    handleApprove(row) {
      this.$confirm('确认通过该请假申请？', '提示').then(() =>
        approveLeave(row.leaveId).then(() => {
          this.$message.success('已通过')
          this.getList()
        })
      )
    },
    handleReject(row) {
      this.$confirm('确认拒绝该请假申请？', '提示').then(() =>
        rejectLeave(row.leaveId).then(() => {
          this.$message.success('已拒绝')
          this.getList()
        })
      )
    },
    // 简单格式化
    typeFmt(r, c, v) {
      return { 1: '事假', 2: '病假', 3: '年假' }[v] || v
    },
    statusFmt(r, c, v) {
      return { 0: '待审批', 1: '已通过', 2: '已拒绝' }[v] || v
    }
  }
}
</script>

<style scoped>
.mb8 { margin-bottom: 8px; }
</style>
<template>
  <div class="app-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>我的请假</span>
        <el-button style="float: right;" type="primary" size="mini" @click="handleAdd">新增请假</el-button>
      </div>

      <!-- 请假列表 -->
      <el-table v-loading="loading" :data="leaveList" style="width: 100%">
        <el-table-column prop="leaveId" label="编号" width="80" />
        <!-- <el-table-column prop="leaveType" label="请假类型" width="100">
          <template slot-scope="scope">
            <span>{{ leaveTypeFormat(scope.row) }}</span>
          </template>
        </el-table-column> -->
        <el-table-column prop="startTime" label="开始时间" width="160">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.startTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="endTime" label="结束时间" width="160">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.endTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="reason" label="请假事由" show-overflow-tooltip />
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.status === '0'">待审批</el-tag>
            <el-tag v-else-if="scope.row.status === '1'" type="success">已通过</el-tag>
            <el-tag v-else type="danger">已拒绝</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" align="center">
          <template slot-scope="scope">
            <el-button size="mini" type="text" @click="handleDetail(scope.row)">详情</el-button>
            <!-- <el-button v-if="scope.row.status === '0'" size="mini" type="text"
              @click="handleUpdate(scope.row)">修改</el-button>
            <el-button v-if="scope.row.status === '0'" size="mini" type="text"
              @click="handleDelete(scope.row)">删除</el-button> -->
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
        @pagination="getList" />
    </el-card>

    <!-- 新增/修改请假对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <!-- <el-form-item label="请假类型" prop="leaveType">
          <el-select v-model="form.leaveType" placeholder="请选择请假类型">
            <el-option label="事假" value="1" />
            <el-option label="病假" value="2" />
            <el-option label="年假" value="3" />
          </el-select>
        </el-form-item> -->
        <el-form-item label="请假标题" prop="title">
          <el-input v-model="form.title" type="textarea" :rows="3" placeholder="请输入请假标题" />
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-date-picker v-model="form.startTime" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择开始时间" style="width: 100%" />
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-date-picker v-model="form.endTime" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择结束时间" style="width: 100%" />
        </el-form-item>
        <el-form-item label="请假事由" prop="reason">
          <el-input v-model="form.reason" type="textarea" :rows="3" placeholder="请输入请假事由" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 请假详情对话框 -->
    <el-dialog title="请假详情" :visible.sync="detailOpen" width="700px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="编号">{{ detailInfo.leaveId }}</el-descriptions-item>
        <!-- <el-descriptions-item label="请假类型">{{ leaveTypeFormat(detailInfo) }}</el-descriptions-item> -->
        <el-descriptions-item label="开始时间">{{ parseTime(detailInfo.startTime) }}</el-descriptions-item>
        <el-descriptions-item label="结束时间">{{ parseTime(detailInfo.endTime) }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ statusFormat(detailInfo) }}</el-descriptions-item>
        <el-descriptions-item label="事由" :span="2">{{ detailInfo.reason }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { myLeave, addLeave, updateLeave, getLeave, delLeave } from '@/api/system/leave'

export default {
  name: 'MyLeave',
  data() {
    return {
      // 遮罩层
      loading: true,
      // 请假列表
      leaveList: [],
      // 总条数
      total: 0,
      // 弹出层标题
      title: '',
      // 是否显示弹出层
      open: false,
      // 是否显示详情弹出层
      detailOpen: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10
      },
      // 表单参数
      form: {},
      // 详情信息
      detailInfo: {},
      // 表单校验
      rules: {
        // leaveType: [
        //   { required: true, message: '请假类型不能为空', trigger: 'change' }
        // ],
        startTime: [
          { required: true, message: '开始时间不能为空', trigger: 'change' }
        ],
        endTime: [
          { required: true, message: '结束时间不能为空', trigger: 'change' }
        ],
        reason: [
          { required: true, message: '请假事由不能为空', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** 查询我的请假列表 */
    // getList() {
    //   this.loading = true
    //   myLeave(this.queryParams).then(response => {
    //     if (response.code === 200) {
    //       this.leaveList = response.rows || []
    //       this.total = response.total || 0
    //     } else {
    //       this.leaveList = []
    //       this.total = 0
    //     }
    //     this.loading = false
    //   }).catch(error => {
    //     console.error('获取请假列表失败:', error)
    //     this.leaveList = []
    //     this.total = 0
    //     this.loading = false
    //   })
    // },
    //     getList() {
    //   this.loading = true
    //   console.log('请求参数：', this.queryParams)   // 看过滤条件
    //   myLeave(this.queryParams).then(res => {
    //     console.log('列表返回：', res)              // 看整体
    //     console.log('rows：', res.data)            // 看数组
    //     this.leaveList = res.data || []
    //     this.total = res.total || 0
    //     this.loading = false
    //   }).catch(() => { this.loading = false })
    // },
    getList() {
      this.loading = true
      myLeave(this.queryParams).then(res => {
        console.log('原始返回：', res)
        console.log('第一条：', res.data?.[0])   // 看真实字段
        this.leaveList = res.data || []
        this.total = res.total || 0
        this.loading = false
      }).catch(() => { this.loading = false })
    },
    /** 请假类型格式化 */
    leaveTypeFormat(row) {
      const typeMap = {
        '1': '事假',
        '2': '病假',
        '3': '年假'
      }
      return typeMap[row.leaveType] || '未知类型'
    },

    /** 状态格式化 */
    statusFormat(row) {
      const statusMap = {
        '0': '待审批',
        '1': '已通过',
        '2': '已拒绝'
      }
      return statusMap[row.status] || '未知状态'
    },

    /** 新增按钮操作 */
    handleAdd() {
      this.open = true
      this.title = '新增请假'
      this.form = {}
    },

    /** 详情按钮操作 */
    handleDetail(row) {
      this.detailInfo = JSON.parse(JSON.stringify(row))
      this.detailOpen = true
    },

    /** 修改按钮操作 */
    handleUpdate(row) {
      getLeave(row.leaveId).then(response => {
        this.form = response.data
        this.open = true
        this.title = '修改请假'
      })
    },

    /** 提交按钮 */
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          if (this.form.leaveId != null) {
            updateLeave(this.form).then(response => {
              this.$message.success('修改成功')
              this.open = false
              this.getList()
            })
          } else {
            addLeave(this.form).then(response => {
              this.$message.success('新增成功')
              this.open = false
              this.getList()
            })
          }
        }
      })
    },

    /** 删除按钮操作 */
    handleDelete(row) {
      this.$confirm('是否确认删除请假编号为"' + row.leaveId + '"的数据项？', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(function () {
        return delLeave(row.leaveId)
      }).then(() => {
        this.$message.success('删除成功')
        this.getList()
      }).catch(() => { })
    },

    /** 取消按钮 */
    cancel() {
      this.open = false
      this.reset()
    },

    /** 表单重置 */
    reset() {
      this.form = {
        leaveId: null,
        leaveType: null,
        startTime: null,
        endTime: null,
        reason: null,
      }
      this.resetForm('form')
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
<template>
  <div class="leave-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">我的请假</h1>
        <p class="page-subtitle">请假申请与记录管理</p>
      </div>
      <div class="header-stats">
        <div class="stat-item">
          <div class="stat-number">{{ stats.pending }}</div>
          <div class="stat-label">待审批</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">{{ stats.approved }}</div>
          <div class="stat-label">已通过</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">{{ stats.rejected }}</div>
          <div class="stat-label">已拒绝</div>
        </div>
      </div>
    </div>

    <!-- 操作工具栏 -->
    <div class="toolbar-section">
      <el-card shadow="never" class="toolbar-card">
        <div class="toolbar-content">
          <el-button 
            type="primary" 
            icon="el-icon-plus" 
            @click="handleAdd" 
            v-hasPermi="['system:myLeave:add']"
            class="add-btn"
          >
            新增请假
          </el-button>
          <div class="toolbar-actions">
            <el-button 
              icon="el-icon-refresh" 
              @click="getList"
              :loading="loading"
              class="refresh-btn"
            >
              刷新
            </el-button>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 请假列表 -->
    <div class="leave-list-section">
      <el-card shadow="never" class="main-card">
        <!-- 网页版表格 -->
        <div class="desktop-view" v-if="!isMobile">
          <el-table v-loading="loading" :data="leaveList" style="width: 100%" class="leave-table">
            <el-table-column prop="leaveId" label="编号" width="80" align="center" />
            <el-table-column prop="startTime" label="开始时间" width="160">
              <template slot-scope="scope">
                <div class="time-cell">
                  <i class="el-icon-time"></i>
                  <span>{{ parseTime(scope.row.startTime) }}</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="endTime" label="结束时间" width="160">
              <template slot-scope="scope">
                <div class="time-cell">
                  <i class="el-icon-time"></i>
                  <span>{{ parseTime(scope.row.endTime) }}</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="reason" label="请假事由" min-width="200" show-overflow-tooltip />
            <el-table-column prop="status" label="状态" width="100" align="center">
              <template slot-scope="scope">
                <el-tag 
                  :type="getStatusType(scope.row.status)" 
                  effect="light"
                  class="status-tag"
                >
                  {{ statusFormat(scope.row) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120" align="center">
              <template slot-scope="scope">
                <el-button 
                  size="mini" 
                  type="text" 
                  icon="el-icon-view"
                  @click="handleDetail(scope.row)"
                  class="detail-btn"
                >
                  详情
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 移动端卡片列表 -->
        <div class="mobile-view" v-else>
          <div class="leave-cards">
            <div 
              v-for="leave in leaveList" 
              :key="leave.leaveId"
              class="leave-card"
              :class="`status-${leave.status}`"
            >
              <div class="card-header">
                <div class="leave-id">#{{ leave.leaveId }}</div>
                <el-tag 
                  :type="getStatusType(leave.status)" 
                  size="small"
                  class="mobile-status-tag"
                >
                  {{ statusFormat(leave) }}
                </el-tag>
              </div>
              
              <div class="card-content">
                <div class="time-range">
                  <div class="time-item">
                    <i class="el-icon-time"></i>
                    <span class="time-label">开始:</span>
                    <span class="time-value">{{ parseTime(leave.startTime) }}</span>
                  </div>
                  <div class="time-item">
                    <i class="el-icon-time"></i>
                    <span class="time-label">结束:</span>
                    <span class="time-value">{{ parseTime(leave.endTime) }}</span>
                  </div>
                </div>
                
                <div class="reason-section">
                  <div class="reason-label">请假事由:</div>
                  <div class="reason-content">{{ leave.reason }}</div>
                </div>
              </div>

              <div class="card-actions">
                <el-button 
                  size="mini" 
                  type="text" 
                  icon="el-icon-view"
                  @click="handleDetail(leave)"
                  class="mobile-detail-btn"
                >
                  查看详情
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-if="leaveList.length === 0 && !loading" class="empty-state">
          <el-empty description="暂无请假记录" image-size="120">
            <el-button type="primary" @click="handleAdd">新增请假</el-button>
          </el-empty>
        </div>

        <!-- 分页 -->
        <pagination 
          v-show="total > 0" 
          :total="total" 
          :page.sync="queryParams.pageNum" 
          :limit.sync="queryParams.pageSize"
          @pagination="getList" 
          class="pagination-section"
        />
      </el-card>
    </div>

    <!-- 新增/修改请假对话框 -->
    <el-dialog 
      :title="title" 
      :visible.sync="open" 
      :width="isMobile ? '95%' : '600px'"
      append-to-body
      class="leave-dialog"
    >
      <el-form ref="form" :model="form" :rules="rules" label-width="100px" class="leave-form">
        <el-form-item label="请假标题" prop="title">
          <el-input 
            v-model="form.title" 
            type="textarea" 
            :rows="3" 
            placeholder="请输入请假标题"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-date-picker 
            v-model="form.startTime" 
            type="datetime" 
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择开始时间" 
            style="width: 100%" 
            :picker-options="pickerOptions"
          />
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-date-picker 
            v-model="form.endTime" 
            type="datetime" 
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择结束时间" 
            style="width: 100%" 
            :picker-options="pickerOptions"
          />
        </el-form-item>
        <el-form-item label="请假事由" prop="reason">
          <el-input 
            v-model="form.reason" 
            type="textarea" 
            :rows="3" 
            placeholder="请输入请假事由"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">取消</el-button>
        <el-button type="primary" @click="submitForm" :loading="formLoading">确定</el-button>
      </div>
    </el-dialog>

    <!-- 请假详情对话框 -->
    <el-dialog 
      title="请假详情" 
      :visible.sync="detailOpen" 
      :width="isMobile ? '95%' : '700px'"
      append-to-body
      class="detail-dialog"
    >
      <el-card shadow="never" v-if="detailInfo.leaveId">
        <el-descriptions :column="isMobile ? 1 : 2" border>
          <el-descriptions-item label="请假编号">{{ detailInfo.leaveId }}</el-descriptions-item>
          <el-descriptions-item label="请假状态">
            <el-tag :type="getStatusType(detailInfo.status)" effect="light">
              {{ statusFormat(detailInfo) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="开始时间">
            <div class="detail-time">
              <i class="el-icon-time"></i>
              {{ parseTime(detailInfo.startTime) }}
            </div>
          </el-descriptions-item>
          <el-descriptions-item label="结束时间">
            <div class="detail-time">
              <i class="el-icon-time"></i>
              {{ parseTime(detailInfo.endTime) }}
            </div>
          </el-descriptions-item>
          <el-descriptions-item :span="isMobile ? 1 : 2" label="请假事由">
            <div class="detail-reason">{{ detailInfo.reason }}</div>
          </el-descriptions-item>
        </el-descriptions>
      </el-card>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailOpen = false">关闭</el-button>
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
      loading: true,
      formLoading: false,
      leaveList: [],
      total: 0,
      title: '',
      open: false,
      detailOpen: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10
      },
      form: {},
      detailInfo: {},
      rules: {
        startTime: [
          { required: true, message: '开始时间不能为空', trigger: 'change' }
        ],
        endTime: [
          { required: true, message: '结束时间不能为空', trigger: 'change' }
        ],
        reason: [
          { required: true, message: '请假事由不能为空', trigger: 'blur' }
        ]
      },
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < Date.now() - 8.64e7
        }
      }
    }
  },
  computed: {
    isMobile() {
      return window.innerWidth <= 768
    },
    stats() {
      const pending = this.leaveList.filter(item => item.status === '0').length
      const approved = this.leaveList.filter(item => item.status === '1').length
      const rejected = this.leaveList.filter(item => item.status === '2').length
      return { pending, approved, rejected }
    }
  },
  created() {
    this.getList()
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  },
  methods: {
    handleResize() {
      this.$forceUpdate()
    },
    
    /** 查询我的请假列表 */
    getList() {
      this.loading = true
      myLeave(this.queryParams).then(res => {
        console.log('原始返回：', res)
        console.log('第一条：', res.data?.[0])
        this.leaveList = res.data || []
        this.total = res.total || 0
        this.loading = false
      }).catch(() => { 
        this.loading = false 
      })
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

    /** 获取状态标签类型 */
    getStatusType(status) {
      const typeMap = {
        '0': 'warning',
        '1': 'success',
        '2': 'danger'
      }
      return typeMap[status] || 'info'
    },

    /** 新增按钮操作 */
    handleAdd() {
      this.open = true
      this.title = '新增请假'
      this.form = {
        title: '',
        startTime: '',
        endTime: '',
        reason: ''
      }
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
          this.formLoading = true
          const submitMethod = this.form.leaveId != null ? updateLeave : addLeave
          
          submitMethod(this.form).then(response => {
            this.$message.success(this.form.leaveId != null ? '修改成功' : '新增成功')
            this.open = false
            this.getList()
          }).finally(() => {
            this.formLoading = false
          })
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
        startTime: null,
        endTime: null,
        reason: null,
      }
      this.resetForm('form')
    }
  }
}
</script>

<style lang="scss" scoped>
.leave-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);
}

/* 页面头部 */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 24px;
  padding: 0 8px;
  
  .header-content {
    .page-title {
      font-size: 28px;
      font-weight: 700;
      color: #303133;
      margin: 0 0 8px 0;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    .page-subtitle {
      font-size: 16px;
      color: #909399;
      margin: 0;
    }
  }
  
  .header-stats {
    display: flex;
    gap: 24px;
    
    .stat-item {
      text-align: center;
      
      .stat-number {
        font-size: 32px;
        font-weight: 700;
        color: #409eff;
        line-height: 1;
      }
      
      .stat-label {
        font-size: 14px;
        color: #909399;
        margin-top: 4px;
      }
    }
  }
}

/* 工具栏 */
.toolbar-section {
  margin-bottom: 20px;
  
  .toolbar-card {
    border-radius: 12px;
    border: none;
  }
  
  .toolbar-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .add-btn {
      border-radius: 6px;
      font-weight: 500;
    }
  }
}

/* 请假列表区域 */
.leave-list-section {
  .main-card {
    border-radius: 12px;
    border: none;
  }
}

/* 网页版表格样式 */
.desktop-view {
  .leave-table {
    ::v-deep .el-table__row {
      transition: all 0.3s ease;
      
      &:hover {
        background: #f8f9fa;
      }
    }
    
    .time-cell {
      display: flex;
      align-items: center;
      gap: 6px;
      color: #606266;
    }
    
    .status-tag {
      font-weight: 500;
    }
    
    .detail-btn {
      color: #409eff;
      
      &:hover {
        color: #67c23a;
      }
    }
  }
}

/* 移动端卡片样式 */
.mobile-view {
  .leave-cards {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }
  
  .leave-card {
    background: white;
    border-radius: 12px;
    padding: 16px;
    border: 1px solid #e4e7ed;
    transition: all 0.3s ease;
    
    &:hover {
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    
    &.status-0 {
      border-left: 4px solid #e6a23c;
    }
    
    &.status-1 {
      border-left: 4px solid #67c23a;
    }
    
    &.status-2 {
      border-left: 4px solid #f56c6c;
    }
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
      
      .leave-id {
        font-size: 14px;
        font-weight: 600;
        color: #909399;
      }
    }
    
    .card-content {
      .time-range {
        margin-bottom: 12px;
        
        .time-item {
          display: flex;
          align-items: center;
          gap: 8px;
          margin-bottom: 6px;
          font-size: 14px;
          
          i {
            color: #909399;
            width: 16px;
          }
          
          .time-label {
            color: #606266;
            min-width: 40px;
          }
          
          .time-value {
            color: #303133;
            font-weight: 500;
          }
        }
      }
      
      .reason-section {
        .reason-label {
          font-size: 14px;
          color: #606266;
          margin-bottom: 4px;
          font-weight: 500;
        }
        
        .reason-content {
          font-size: 14px;
          color: #303133;
          line-height: 1.5;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          overflow: hidden;
        }
      }
    }
    
    .card-actions {
      margin-top: 12px;
      padding-top: 12px;
      border-top: 1px solid #f0f0f0;
      text-align: right;
      
      .mobile-detail-btn {
        color: #409eff;
      }
    }
  }
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 60px 20px;
}

/* 分页 */
.pagination-section {
  margin-top: 20px;
  text-align: right;
}

/* 对话框样式 */
.leave-dialog, .detail-dialog {
  ::v-deep .el-dialog {
    border-radius: 12px;
    
    &__header {
      border-bottom: 1px solid #e4e7ed;
    }
  }
}

.leave-form {
  .el-form-item {
    margin-bottom: 20px;
  }
}

.detail-dialog {
  .detail-time {
    display: flex;
    align-items: center;
    gap: 6px;
    color: #606266;
  }
  
  .detail-reason {
    padding: 8px 0;
    color: #303133;
    line-height: 1.6;
  }
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .leave-container {
    padding: 12px;
  }
  
  .page-header {
    flex-direction: column;
    align-items: stretch;
    gap: 16px;
    
    .header-stats {
      justify-content: space-around;
    }
  }
  
  .toolbar-content {
    flex-direction: column;
    gap: 12px;
    align-items: stretch !important;
    
    .add-btn {
      width: 100%;
    }
    
    .toolbar-actions {
      display: flex;
      justify-content: center;
    }
  }
  
  .desktop-view {
    display: none;
  }
}

@media screen and (min-width: 769px) {
  .mobile-view {
    display: none;
  }
}
</style>
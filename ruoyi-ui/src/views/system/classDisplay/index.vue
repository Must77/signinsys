<template>
  <div class="class-display-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">班级广场</h1>
        <p class="page-subtitle">培训中心所有班级</p>
      </div>
      
    </div>
    <!-- 顶部搜索和筛选区域 -->
    <div class="filter-section">
      <el-card shadow="never" class="filter-card">
        <div class="filter-content">
          <div class="search-input">
            <el-input
              v-model="queryParams.deptName"
              placeholder="搜索班级名称"
              prefix-icon="el-icon-search"
              clearable
              @keyup.enter.native="handleQuery"
              @clear="handleQuery"
            />
          </div>
          <div class="filter-buttons">
            <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 班级统计信息 -->
    <div class="stats-section">
      <el-row :gutter="20">
        <el-col :xs="12" :sm="6" v-for="stat in statsData" :key="stat.title">
          <el-card shadow="hover" class="stat-card" :class="stat.type">
            <div class="stat-content">
              <div class="stat-icon">
                <i :class="stat.icon"></i>
              </div>
              <div class="stat-info">
                <div class="stat-number">{{ stat.number }}</div>
                <div class="stat-title">{{ stat.title }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 班级列表 -->
    <div class="class-list-section">
      <el-card shadow="never">
        <template #header>
          <div class="card-header">
            <span class="header-title">班级列表</span>
            <div class="header-actions">
              <el-button 
                type="text" 
                icon="el-icon-refresh" 
                @click="getList"
                :loading="loading"
              >
                刷新
              </el-button>
            </div>
          </div>
        </template>

        <!-- 网页版表格 -->
        <div class="desktop-view" v-if="!isMobile">
          <el-table 
            v-loading="loading" 
            :data="classList" 
            row-key="deptId"
            style="width: 100%"
          >
            <el-table-column prop="deptName" label="班级名称" min-width="120" />
            <el-table-column prop="leader" label="负责人" width="100" />
            <el-table-column prop="phone" label="联系电话" width="120" />
            <el-table-column prop="status" label="状态" width="80">
              <template slot-scope="scope">
                <el-tag 
                  :type="scope.row.status === '0' ? 'success' : 'danger'"
                  size="small"
                >
                  {{ scope.row.status === '0' ? '正常' : '停用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="180" fixed="right">
              <template slot-scope="scope">
                <div class="action-buttons">
                  <el-button 
                    size="mini" 
                    type="text" 
                    icon="el-icon-view"
                    @click="handleView(scope.row)"
                  >
                    详情
                  </el-button>
                  <el-button 
                    size="mini" 
                    :class="[
                      'apply-button', 
                      { 
                        'apply-disabled': !canApply(scope.row),
                        'apply-success': canApply(scope.row)
                      }
                    ]"
                    :disabled="!canApply(scope.row)"
                    @click="handleApply(scope.row)"
                    icon="el-icon-check"
                  >
                    {{ getApplyButtonText(scope.row) }}
                  </el-button>
                </div>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 移动端卡片列表 -->
        <div class="mobile-view" v-else>
          <div class="class-cards">
            <div 
              v-for="classItem in classList" 
              :key="classItem.deptId"
              class="class-card"
              :class="{ 'disabled': !canApply(classItem) }"
            >
              <div class="card-header">
                <div class="class-name">{{ classItem.deptName }}</div>
                <el-tag 
                  :type="classItem.status === '0' ? 'success' : 'danger'"
                  size="small"
                >
                  {{ classItem.status === '0' ? '正常' : '停用' }}
                </el-tag>
              </div>
              
              <div class="card-content">
                <div class="info-row">
                  <i class="el-icon-user"></i>
                  <span>负责人：{{ classItem.leader }}</span>
                </div>
                <div class="info-row">
                  <i class="el-icon-phone"></i>
                  <span>{{ classItem.phone || '暂无电话' }}</span>
                </div>
              </div>

              <div class="card-actions">
                <el-button 
                  size="mini" 
                  type="text" 
                  @click="handleView(classItem)"
                  class="view-button"
                >
                  <i class="el-icon-view"></i>
                  详情
                </el-button>
                <el-button 
                  size="mini" 
                  :class="[
                    'apply-button', 
                    'mobile-apply-button',
                    { 
                      'apply-disabled': !canApply(classItem),
                      'apply-success': canApply(classItem)
                    }
                  ]"
                  :disabled="!canApply(classItem)"
                  @click="handleApply(classItem)"
                >
                  <i class="el-icon-check"></i>
                  {{ getApplyButtonText(classItem) }}
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-if="classList.length === 0 && !loading" class="empty-state">
          <el-empty description="暂无班级数据">
            <el-button type="primary" @click="getList">刷新</el-button>
          </el-empty>
        </div>
      </el-card>
    </div>

    <!-- 班级详情对话框 -->
    <el-dialog 
      :title="detailTitle" 
      :visible.sync="detailOpen" 
      :width="isMobile ? '90%' : '700px'"
      append-to-body
    >
      <el-card shadow="never">
        <el-descriptions :column="isMobile ? 1 : 2" border>
          <el-descriptions-item label="班级ID">{{ detailInfo.deptId }}</el-descriptions-item>
          <el-descriptions-item label="班级名称">{{ detailInfo.deptName }}</el-descriptions-item>
          <el-descriptions-item label="上级部门">{{ detailInfo.parentName }}</el-descriptions-item>
          <el-descriptions-item label="班级简介">{{ detailInfo.brief || '暂无简介' }}</el-descriptions-item>
          <el-descriptions-item label="负责人">{{ detailInfo.leader }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ detailInfo.phone || '暂无' }}</el-descriptions-item>
          <el-descriptions-item label="邮箱">{{ detailInfo.email || '暂无' }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="detailInfo.status === '0' ? 'success' : 'danger'">
              {{ detailInfo.status === '0' ? '正常' : '停用' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="开始时间">{{ detailInfo.startTime || '未设置' }}</el-descriptions-item>
          <el-descriptions-item label="结束时间">{{ detailInfo.endTime || '未设置' }}</el-descriptions-item>
          <!-- <el-descriptions-item label="自动加入">
            <el-tag :type="detailInfo.autoJoin === '1' ? 'success' : 'info'">
              {{ detailInfo.autoJoin === '1' ? '是' : '否' }}
            </el-tag>
          </el-descriptions-item> -->
          <!-- <el-descriptions-item :span="isMobile ? 1 : 2" label="封面图片">
            <el-image 
              v-if="detailInfo.coverURL" 
              :src="detailInfo.coverURL" 
              style="max-width: 200px; height: 150px"
              fit="cover"
              :preview-src-list="[detailInfo.coverURL]"
            ></el-image>
            <span v-else class="no-image">暂无图片</span>
          </el-descriptions-item> -->
        </el-descriptions>
      </el-card>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailOpen = false">关闭</el-button>
        <el-button 
          :class="[
            'apply-button', 
            'apply-dialog-button',
            { 
              'apply-disabled': !canApply(detailInfo),
              'apply-success': canApply(detailInfo)
            }
          ]"
          :disabled="!canApply(detailInfo)"
          @click="handleApply(detailInfo)"
          type="primary"
        >
          {{ getApplyButtonText(detailInfo) }}
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listDept, getDept } from '@/api/system/dept'
import { addDeptApply } from '@/api/system/deptApply'

export default {
  name: 'ClassDisplay',
  data() {
    return {
      loading: false,
      classList: [],
      detailOpen: false,
      detailTitle: '',
      queryParams: {
        deptName: ''
      },
      detailInfo: {
        deptId: null,
        parentId: null,
        ancestors: '',
        deptName: '',
        brief: '',
        coverURL: '',
        orderNum: null,
        leader: '',
        phone: '',
        email: '',
        status: '0',
        parentName: '',
        children: [],
        startTime: '',
        endTime: '',
        size: 0,
        cap: 0,
        autoJoin: '0'
      }
    }
  },
  computed: {
    // 判断是否为移动端
    isMobile() {
      return window.innerWidth <= 768
    },
    // 统计信息
    statsData() {
      const total = this.classList.length
      const active = this.classList.filter(item => item.status === '0').length
      const available = this.classList.filter(item => this.canApply(item)).length
      // 移除满员统计，因为不再限制容量
      
      return [
        {
          title: '总班级数',
          number: total,
          icon: 'el-icon-school',
          type: 'total'
        },
        {
          title: '正常班级',
          number: active,
          icon: 'el-icon-success',
          type: 'active'
        },
        {
          title: '可报名',
          number: available,
          icon: 'el-icon-check',
          type: 'available'
        }
        // 移除满员统计项
      ]
    }
  },
  created() {
    this.getList()
    // 监听窗口大小变化
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  },
  methods: {
    handleResize() {
      this.$forceUpdate()
    },
    
    /** 查询班级列表 */
    getList() {
      this.loading = true
      listDept({ status: '0', ...this.queryParams }).then(response => {
        let data = []
        if (response.data) {
          data = response.data
        } else if (response.rows) {
          data = response.rows
        }
        // 过滤掉根部门
        this.classList = data.filter(item => item.deptId !== 100 && item.deptId !== 101)
        this.loading = false
      }).catch(error => {
        console.error('获取班级列表失败:', error)
        this.loading = false
        this.$message.error('获取班级列表失败，请联系管理员')
      })
    },
    
    /** 搜索 */
    handleQuery() {
      this.getList()
    },
    
    /** 重置搜索 */
    resetQuery() {
      this.queryParams.deptName = ''
      this.getList()
    },
    
    /** 查看详情 */
    handleView(row) {
      getDept(row.deptId).then(response => {
        this.detailInfo = response.data
        this.detailTitle = `班级详情 - ${row.deptName}`
        this.detailOpen = true
      })
    },
    
    /** 报名班级 */
    handleApply(row) {
      this.$confirm(`确认要报名"${row.deptName}"班级吗？`, '提示', {
        confirmButtonText: '确定报名',
        cancelButtonText: '取消',
        type: 'warning',
        confirmButtonClass: 'confirm-apply-button'
      }).then(() => {
        const applyData = {
          deptId: row.deptId,
          userId: this.$store.getters.userId
        }
        return addDeptApply(applyData)
      }).then(() => {
        this.$message.success('报名成功，请等待审核')
        this.detailOpen = false
        this.getList()
      }).catch(error => {
        if (error !== 'cancel') {
          this.$message.error('报名失败，请稍后重试')
        }
      })
    },
    
    /** 判断是否可以报名 */
    canApply(row) {
      // 移除容量限制，只检查状态
      return row.status === '0'
    },
    
    /** 获取报名按钮文本 */
    getApplyButtonText(row) {
      if (row.status !== '0') return '已停用'
      // 移除容量满额检查
      return '报名'
    }
  }
}
</script>

<style lang="scss" scoped>

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



.class-display-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);
}

/* 筛选区域 */
.filter-section {
  margin-bottom: 20px;
  
  .filter-card {
    border-radius: 12px;
    border: none;
  }
  
  .filter-content {
    display: flex;
    gap: 16px;
    align-items: center;
    
    .search-input {
      flex: 1;
      max-width: 300px;
    }
  }
}

/* 统计卡片 */
.stats-section {
  margin-bottom: 20px;
  
  .stat-card {
    border-radius: 12px;
    border: none;
    transition: all 0.3s ease;
    
    &:hover {
      transform: translateY(-4px);
    }
    
    &.total {
      border-left: 4px solid #409eff;
    }
    
    &.active {
      border-left: 4px solid #67c23a;
    }
    
    &.available {
      border-left: 4px solid #e6a23c;
    }
    
    &.full {
      border-left: 4px solid #f56c6c;
    }
    
    .stat-content {
      display: flex;
      align-items: center;
      gap: 16px;
      
      .stat-icon {
        width: 50px;
        height: 50px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: white;
        
        .total & { background: #409eff; }
        .active & { background: #67c23a; }
        .available & { background: #e6a23c; }
        .full & { background: #f56c6c; }
      }
      
      .stat-info {
        .stat-number {
          font-size: 24px;
          font-weight: bold;
          color: #303133;
        }
        
        .stat-title {
          font-size: 14px;
          color: #909399;
          margin-top: 4px;
        }
      }
    }
  }
}

/* 班级列表区域 */
.class-list-section {
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .header-title {
      font-size: 18px;
      font-weight: 600;
      color: #303133;
    }
  }
}

/* 网页版表格样式 */
.desktop-view {
  .size-info {
    display: flex;
    align-items: center;
    gap: 4px;
    
    .current-size {
      color: #409eff;
      font-weight: 600;
    }
    
    .size-separator {
      color: #c0c4cc;
    }
    
    .total-size {
      color: #909399;
    }
  }
  
  .action-buttons {
    display: flex;
    gap: 8px;
    align-items: center;
  }
}

/* 移动端卡片样式 */
.mobile-view {
  .class-cards {
    display: grid;
    gap: 16px;
  }
  
  .class-card {
    background: white;
    border-radius: 12px;
    padding: 16px;
    border: 1px solid #e4e7ed;
    transition: all 0.3s ease;
    
    &:hover:not(.disabled) {
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      transform: translateY(-2px);
    }
    
    &.disabled {
      opacity: 0.6;
      background: #f5f7fa;
    }
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 12px;
      
      .class-name {
        font-size: 16px;
        font-weight: 600;
        color: #303133;
        flex: 1;
        margin-right: 12px;
      }
    }
    
    .card-content {
      .info-row {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 8px;
        font-size: 14px;
        color: #606266;
        
        i {
          color: #909399;
          width: 16px;
        }
      }
    }
    
    .card-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 16px;
      padding-top: 12px;
      border-top: 1px solid #f0f0f0;
      
      .view-button {
        color: #409eff;
      }
    }
  }
}

/* 报名按钮样式 */
.apply-button {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  color: white;
  font-weight: 600;
  border-radius: 6px;
  transition: all 0.3s ease;
  
  &:hover:not(.apply-disabled) {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
    background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
  }
  
  &.apply-success {
    background: linear-gradient(135deg, #67c23a 0%, #85ce61 100%);
    
    &:hover:not(.apply-disabled) {
      background: linear-gradient(135deg, #85ce61 0%, #67c23a 100%);
      box-shadow: 0 4px 12px rgba(103, 194, 58, 0.4);
    }
  }
}

.apply-disabled {
  background: #c0c4cc !important;
  color: #909399 !important;
  cursor: not-allowed !important;
  transform: none !important;
  box-shadow: none !important;
}

.mobile-apply-button {
  padding: 6px 12px;
  font-size: 12px;
}

.apply-dialog-button {
  padding: 10px 24px;
}

/* 对话框样式 */
.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.size-display {
  display: flex;
  align-items: center;
  gap: 4px;
  
  .current {
    color: #409eff;
    font-weight: 600;
  }
  
  .separator {
    color: #c0c4cc;
  }
  
  .total {
    color: #909399;
  }
}

.no-image {
  color: #909399;
  font-style: italic;
}

/* 空状态 */
.empty-state {
  padding: 40px 0;
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .class-display-container {
    padding: 12px;
  }
  
  .filter-content {
    flex-direction: column;
    align-items: stretch !important;
    
    .search-input {
      max-width: none !important;
    }
    
    .filter-buttons {
      display: flex;
      gap: 12px;
      
      .el-button {
        flex: 1;
      }
    }
  }
  
  .stats-section {
    .el-col {
      margin-bottom: 12px;
    }
    
    .stat-content {
      gap: 12px !important;
      
      .stat-icon {
        width: 40px !important;
        height: 40px !important;
        font-size: 20px !important;
      }
      
      .stat-number {
        font-size: 20px !important;
      }
    }
  }
  
  .mobile-view .class-cards {
    grid-template-columns: 1fr;
  }
}

@media screen and (min-width: 769px) and (max-width: 1200px) {
  .mobile-view .class-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media screen and (min-width: 1201px) {
  .mobile-view .class-cards {
    grid-template-columns: repeat(3, 1fr);
  }
}

/* 确认按钮特殊样式 */
.confirm-apply-button {
  background: linear-gradient(135deg, #67c23a 0%, #85ce61 100%) !important;
  border: none !important;
}
</style>
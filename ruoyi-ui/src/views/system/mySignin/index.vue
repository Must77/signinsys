<template>
  <div class="signin-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">我的签到</h1>
        <p class="page-subtitle">签到活动管理与参与</p>
      </div>
      <div class="header-stats">
        <div class="stat-item">
          <div class="stat-number">{{ stats.pending }}</div>
          <div class="stat-label">待签到</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">{{ stats.signed }}</div>
          <div class="stat-label">已签到</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">{{ stats.total }}</div>
          <div class="stat-label">总活动</div>
        </div>
      </div>
    </div>

    <!-- 主内容区域 -->
    <el-card class="main-card">
      <!-- 网页版标签页 -->
      <div class="desktop-view" v-if="!isMobile">
        <el-tabs v-model="activeTab" @tab-click="handleTabClick" class="signin-tabs">
          <!-- 我的待签到 -->
          <el-tab-pane label="我的待签到" name="pending">
            <div class="tab-content">
              <el-table v-loading="loading" :data="signinList" class="signin-table" empty-text="暂无待签到活动">
                <el-table-column label="活动信息" min-width="200">
                  <template slot-scope="scope">
                    <div class="activity-info">
                      <div class="activity-title">{{ scope.row.title }}</div>
                      <div class="activity-meta">
                        <span class="course-name">{{ scope.row.courseName }}</span>
                        <span class="dept-name">{{ scope.row.deptName }}</span>
                      </div>
                    </div>
                  </template>
                </el-table-column>
                
                <el-table-column label="时间信息" width="200">
                  <template slot-scope="scope">
                    <div class="time-info">
                      <div class="time-item">
                        <i class="el-icon-time"></i>
                        <span>开始: {{ parseTime(scope.row.startTime) }}</span>
                      </div>
                      <div class="time-item">
                        <i class="el-icon-time"></i>
                        <span>结束: {{ parseTime(scope.row.endTime) }}</span>
                      </div>
                    </div>
                  </template>
                </el-table-column>
                
                <el-table-column label="活动状态" width="100" align="center">
                  <template slot-scope="scope">
                    <el-tag :type="getActivityStatusType(scope.row)" effect="light">
                      {{ getActivityStatus(scope.row.startTime, scope.row.endTime) }}
                    </el-tag>
                  </template>
                </el-table-column>
                
                <el-table-column label="签到状态" width="100" align="center">
                  <template slot-scope="scope">
                    <el-tag type="warning" effect="light">未签到</el-tag>
                  </template>
                </el-table-column>
                
                <el-table-column label="操作" width="120" align="center">
                  <template slot-scope="scope">
                    <el-button 
                      size="mini" 
                      type="primary" 
                      @click="handleSignin(scope.row)" 
                      :disabled="getActivityStatus(scope.row.startTime, scope.row.endTime) !== '进行中'"
                      class="signin-btn"
                    >
                      <i class="el-icon-check"></i>
                      签到
                    </el-button>
                  </template>
                </el-table-column>
              </el-table>
              
              <pagination 
                v-show="total > 0" 
                :total="total" 
                :page.sync="queryParams.pageNum"
                :limit.sync="queryParams.pageSize" 
                @pagination="getList" 
                class="pagination"
              />
            </div>
          </el-tab-pane>
          
          <!-- 我的所有签到活动 -->
          <el-tab-pane label="我的所有签到活动" name="all">
            <div class="tab-content">
              <!-- 查询条件 -->
              <el-card shadow="never" class="filter-card">
                <el-form :model="queryParams" ref="queryForm" :inline="true" label-width="100px" class="filter-form">
                  <el-form-item label="活动名称" prop="title">
                    <el-input 
                      v-model="queryParams.title" 
                      placeholder="请输入活动名称" 
                      clearable 
                      size="small"
                      @keyup.enter.native="handleQuery"
                      class="search-input"
                    />
                  </el-form-item>
                  <el-form-item label="活动状态" prop="status">
                    <el-select 
                      v-model="queryParams.status" 
                      placeholder="请选择活动状态" 
                      clearable 
                      size="small"
                      class="status-select"
                    >
                      <el-option label="未开始" value="0" />
                      <el-option label="进行中" value="1" />
                      <el-option label="已结束" value="2" />
                    </el-select>
                  </el-form-item>
                  <el-form-item label="签到状态">
                    <el-select 
                      v-model="queryParams.signStatus" 
                      placeholder="请选择签到状态" 
                      clearable 
                      size="small"
                      class="sign-status-select"
                    >
                      <el-option label="未签到" value="0" />
                      <el-option label="已签到" value="1" />
                    </el-select>
                  </el-form-item>
                  <el-form-item>
                    <el-button type="primary" icon="el-icon-search" size="small" @click="handleQuery">搜索</el-button>
                    <el-button icon="el-icon-refresh" size="small" @click="resetQuery">重置</el-button>
                  </el-form-item>
                </el-form>
              </el-card>

              <!-- 数据表格 -->
              <el-table v-loading="loading" :data="signinList" class="signin-table" empty-text="暂无签到活动">
                <el-table-column label="活动信息" min-width="200">
                  <template slot-scope="scope">
                    <div class="activity-info">
                      <div class="activity-title">{{ scope.row.title }}</div>
                      <div class="activity-meta">
                        <span class="course-name">{{ scope.row.courseName }}</span>
                        <span class="dept-name">{{ scope.row.deptName }}</span>
                      </div>
                    </div>
                  </template>
                </el-table-column>
                
                <el-table-column label="时间信息" width="200">
                  <template slot-scope="scope">
                    <div class="time-info">
                      <div class="time-item">
                        <i class="el-icon-time"></i>
                        <span>开始: {{ parseTime(scope.row.startTime) }}</span>
                      </div>
                      <div class="time-item">
                        <i class="el-icon-time"></i>
                        <span>结束: {{ parseTime(scope.row.endTime) }}</span>
                      </div>
                    </div>
                  </template>
                </el-table-column>
                
                <el-table-column label="活动状态" width="100" align="center">
                  <template slot-scope="scope">
                    <el-tag :type="getStatusType(scope.row.status)" effect="light">
                      {{ getStatusText(scope.row.status) }}
                    </el-tag>
                  </template>
                </el-table-column>
                
                <el-table-column label="签到状态" width="100" align="center">
                  <template slot-scope="scope">
                    <el-tag 
                      :type="getSignStatusType(scope.row)" 
                      effect="light"
                    >
                      {{ getSignStatusText(scope.row) }}
                    </el-tag>
                  </template>
                </el-table-column>
                
                <el-table-column label="操作" width="120" align="center">
                  <template slot-scope="scope">
                    <el-button 
                      size="mini" 
                      type="primary" 
                      @click="handleSignin(scope.row)"
                      :disabled="scope.row.status !== '1' || scope.row.mySigninStatus === '1'"
                      class="signin-btn"
                    >
                      <i class="el-icon-check"></i>
                      签到
                    </el-button>
                  </template>
                </el-table-column>
              </el-table>

              <!-- 分页 -->
              <pagination 
                v-show="total > 0" 
                :total="total" 
                :page.sync="queryParams.pageNum"
                :limit.sync="queryParams.pageSize" 
                @pagination="getList" 
                class="pagination"
              />
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>

      <!-- 移动端视图 -->
      <div class="mobile-view" v-else>
        <!-- 移动端标签切换 -->
        <div class="mobile-tabs">
          <div 
            class="mobile-tab"
            :class="{ active: activeTab === 'pending' }"
            @click="activeTab = 'pending'"
          >
            <i class="el-icon-time"></i>
            <span>待签到</span>
            <span class="tab-badge" v-if="stats.pending > 0">{{ stats.pending }}</span>
          </div>
          <div 
            class="mobile-tab"
            :class="{ active: activeTab === 'all' }"
            @click="handleTabClick({ name: 'all' })"
          >
            <i class="el-icon-document"></i>
            <span>所有活动</span>
          </div>
        </div>

        <!-- 移动端内容 -->
        <div class="mobile-content">
          <!-- 待签到 -->
          <div v-show="activeTab === 'pending'" class="tab-content">
            <div class="activity-cards">
              <div 
                v-for="activity in signinList" 
                :key="activity.recordId"
                class="activity-card"
                :class="`status-${getActivityStatus(activity.startTime, activity.endTime)}`"
              >
                <div class="card-header">
                  <div class="activity-title-mobile">{{ activity.title }}</div>
                  <el-tag 
                    :type="getActivityStatusType(activity)" 
                    size="small"
                    class="status-tag"
                  >
                    {{ getActivityStatus(activity.startTime, activity.endTime) }}
                  </el-tag>
                </div>
                
                <div class="card-content">
                  <div class="activity-info-mobile">
                    <div class="info-item">
                      <i class="el-icon-notebook-2"></i>
                      <span>{{ activity.courseName }}</span>
                    </div>
                    <div class="info-item">
                      <i class="el-icon-school"></i>
                      <span>{{ activity.deptName }}</span>
                    </div>
                  </div>
                  
                  <div class="time-info-mobile">
                    <div class="time-item">
                      <i class="el-icon-time"></i>
                      <span class="time-label">开始:</span>
                      <span class="time-value">{{ parseTime(activity.startTime) }}</span>
                    </div>
                    <div class="time-item">
                      <i class="el-icon-time"></i>
                      <span class="time-label">结束:</span>
                      <span class="time-value">{{ parseTime(activity.endTime) }}</span>
                    </div>
                  </div>
                </div>

                <div class="card-actions">
                  <el-button 
                    size="small" 
                    type="primary" 
                    @click="handleSignin(activity)" 
                    :disabled="getActivityStatus(activity.startTime, activity.endTime) !== '进行中'"
                    class="mobile-signin-btn"
                  >
                    <i class="el-icon-check"></i>
                    立即签到
                  </el-button>
                </div>
              </div>
            </div>
            
            <!-- 空状态 -->
            <div v-if="signinList.length === 0 && !loading" class="empty-state">
              <el-empty description="暂无待签到活动" image-size="100">
                <el-button type="primary" @click="getList">刷新</el-button>
              </el-empty>
            </div>
          </div>

          <!-- 所有活动 -->
          <div v-show="activeTab === 'all'" class="tab-content">
            <!-- 移动端筛选 -->
            <el-card shadow="never" class="mobile-filter-card">
              <el-form :model="queryParams" ref="queryForm" class="mobile-filter-form">
                <el-form-item label="活动名称">
                  <el-input 
                    v-model="queryParams.title" 
                    placeholder="搜索活动名称" 
                    clearable 
                    @keyup.enter.native="handleQuery"
                  />
                </el-form-item>
                <el-form-item label="活动状态">
                  <el-select 
                    v-model="queryParams.status" 
                    placeholder="活动状态" 
                    clearable 
                    style="width: 100%"
                  >
                    <el-option label="未开始" value="0" />
                    <el-option label="进行中" value="1" />
                    <el-option label="已结束" value="2" />
                  </el-select>
                </el-form-item>
                <el-form-item label="签到状态">
                  <el-select 
                    v-model="queryParams.signStatus" 
                    placeholder="签到状态" 
                    clearable 
                    style="width: 100%"
                  >
                    <el-option label="未签到" value="0" />
                    <el-option label="已签到" value="1" />
                  </el-select>
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="handleQuery" style="width: 100%">搜索</el-button>
                  <el-button @click="resetQuery" style="width: 100%; margin-top: 8px">重置</el-button>
                </el-form-item>
              </el-form>
            </el-card>

            <div class="activity-cards">
              <div 
                v-for="activity in signinList" 
                :key="activity.recordId"
                class="activity-card"
                :class="`status-${activity.status}`"
              >
                <div class="card-header">
                  <div class="activity-title-mobile">{{ activity.title }}</div>
                  <div class="status-group">
                    <el-tag 
                      :type="getStatusType(activity.status)" 
                      size="small"
                      class="status-tag"
                    >
                      {{ getStatusText(activity.status) }}
                    </el-tag>
                    <el-tag 
                      :type="getSignStatusType(activity)" 
                      size="small"
                      class="sign-status-tag"
                    >
                      {{ getSignStatusText(activity) }}
                    </el-tag>
                  </div>
                </div>
                
                <div class="card-content">
                  <div class="activity-info-mobile">
                    <div class="info-item">
                      <i class="el-icon-notebook-2"></i>
                      <span>{{ activity.courseName }}</span>
                    </div>
                    <div class="info-item">
                      <i class="el-icon-school"></i>
                      <span>{{ activity.deptName }}</span>
                    </div>
                  </div>
                  
                  <div class="time-info-mobile">
                    <div class="time-item">
                      <i class="el-icon-time"></i>
                      <span class="time-label">开始:</span>
                      <span class="time-value">{{ parseTime(activity.startTime) }}</span>
                    </div>
                    <div class="time-item">
                      <i class="el-icon-time"></i>
                      <span class="time-label">结束:</span>
                      <span class="time-value">{{ parseTime(activity.endTime) }}</span>
                    </div>
                  </div>
                </div>

                <div class="card-actions">
                  <el-button 
                    size="small" 
                    type="primary" 
                    @click="handleSignin(activity)"
                    :disabled="activity.status !== '1' || activity.mySigninStatus === '1'"
                    class="mobile-signin-btn"
                  >
                    <i class="el-icon-check"></i>
                    {{ activity.mySigninStatus === '1' ? '已签到' : '立即签到' }}
                  </el-button>
                </div>
              </div>
            </div>
            
            <!-- 空状态 -->
            <div v-if="signinList.length === 0 && !loading" class="empty-state">
              <el-empty description="暂无签到活动" image-size="100">
                <el-button type="primary" @click="getList">刷新</el-button>
              </el-empty>
            </div>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
import { listMyPendingSignin, listSigninRecord, doSignin } from '@/api/system/userSignin'

export default {
  name: 'MySignin',
  data() {
    return {
      activeTab: 'pending',
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
  computed: {
    isMobile() {
      return window.innerWidth <= 768
    },
    stats() {
      const pending = this.activeTab === 'pending' ? this.signinList.length : 0
      const signed = this.signinList.filter(item => item.mySigninStatus === '1').length
      const total = this.signinList.length
      return { pending, signed, total }
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
    
    // 获取活动状态类型
    getActivityStatusType(row) {
      const status = this.getActivityStatus(row.startTime, row.endTime)
      const typeMap = {
        '未开始': 'info',
        '进行中': 'success',
        '已结束': 'danger'
      }
      return typeMap[status] || 'info'
    },
    
    // 获取状态类型
    getStatusType(status) {
      const typeMap = {
        '0': 'info',
        '1': 'success',
        '2': 'danger'
      }
      return typeMap[status] || 'info'
    },
    
    // 获取状态文本
    getStatusText(status) {
      const textMap = {
        '0': '未开始',
        '1': '进行中',
        '2': '已结束'
      }
      return textMap[status] || '未知状态'
    },
    
    // 获取签到状态类型
    getSignStatusType(row) {
      if (row.mySigninStatus === '1') return 'success'
      if (row.status !== '1') return 'info'
      return 'warning'
    },
    
    // 获取签到状态文本
    getSignStatusText(row) {
      if (row.mySigninStatus === '1') return '已签到'
      if (row.status !== '1') return '不可签'
      return '未签到'
    },
    
    // 标签页切换
    handleTabClick(tab) {
      this.activeTab = tab.name
      this.queryParams.pageNum = 1
      this.getList()
    },
    
    // 获取列表数据
    getList() {
      this.loading = true
      
      if (this.activeTab === 'pending') {
        const params = {
          pageNum: this.queryParams.pageNum,
          pageSize: this.queryParams.pageSize
        }
        listMyPendingSignin(params).then(res => {
          this.processResponseData(res)
        }).catch(() => {
          this.signinList = []
          this.total = 0
          this.loading = false
        })
      } else {
        const params = { ...this.queryParams }
        if (params.signStatus !== undefined && params.signStatus !== '') {
          params.status = params.signStatus
          delete params.signStatus
        }
        
        listSigninRecord(params).then(res => {
          this.processResponseData(res, true)
        }).catch(() => {
          this.signinList = []
          this.total = 0
          this.loading = false
        })
      }
    },

    // 处理响应数据
    processResponseData(res, isAllTab = false) {
      let rows = []
      let total = 0
      
      if (res.rows && Array.isArray(res.rows)) {
        rows = res.rows || []
        total = res.total || rows.length
      } else if (Array.isArray(res.data)) {
        rows = res.data || []
        total = rows.length
      } else if (res.data && res.data.rows && Array.isArray(res.data.rows)) {
        rows = res.data.rows || []
        total = res.data.total || rows.length
      }
      
      if (isAllTab) {
        rows = rows.map(r => ({
          ...r,
          mySigninStatus: r.status === '1' ? '1' : '0'
        }))
      }
      
      this.signinList = rows
      this.total = total
      this.loading = false
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

<style lang="scss" scoped>
.signin-container {
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

/* 主卡片 */
.main-card {
  border-radius: 12px;
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

/* 网页版样式 */
.desktop-view {
  .signin-tabs {
    ::v-deep .el-tabs__header {
      margin-bottom: 0;
    }
    
    ::v-deep .el-tabs__content {
      padding: 20px;
    }
  }
  
  .filter-card {
    margin-bottom: 20px;
    border: none;
    border-radius: 8px;
  }
  
  .filter-form {
    display: flex;
    flex-wrap: wrap;
    gap: 16px;
    align-items: flex-end;
  }
  
  .signin-table {
    ::v-deep .el-table__row {
      transition: all 0.3s ease;
      
      &:hover {
        background: #f8f9fa;
      }
    }
    
    .activity-info {
      .activity-title {
        font-size: 14px;
        font-weight: 500;
        color: #303133;
        margin-bottom: 4px;
      }
      
      .activity-meta {
        display: flex;
        gap: 12px;
        font-size: 12px;
        color: #909399;
      }
    }
    
    .time-info {
      .time-item {
        display: flex;
        align-items: center;
        gap: 6px;
        margin-bottom: 4px;
        font-size: 12px;
        color: #606266;
      }
    }
    
    .signin-btn {
      border-radius: 6px;
      font-weight: 500;
    }
  }
  
  .pagination {
    margin-top: 20px;
    text-align: right;
  }
}

/* 移动端样式 */
.mobile-view {
  .mobile-tabs {
    display: flex;
    background: #f8f9fa;
    border-radius: 8px;
    padding: 4px;
    margin-bottom: 20px;
    
    .mobile-tab {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      padding: 12px;
      border-radius: 6px;
      font-size: 14px;
      color: #606266;
      cursor: pointer;
      transition: all 0.3s ease;
      position: relative;
      
      &.active {
        background: white;
        color: #409eff;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }
      
      .tab-badge {
        background: #f56c6c;
        color: white;
        border-radius: 10px;
        padding: 2px 6px;
        font-size: 12px;
        min-width: 18px;
        text-align: center;
      }
    }
  }
  
  .mobile-content {
    padding: 0 8px;
  }
  
  .mobile-filter-card {
    margin-bottom: 16px;
    border: none;
    border-radius: 8px;
  }
  
  .mobile-filter-form {
    .el-form-item {
      margin-bottom: 16px;
    }
  }
  
  .activity-cards {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }
  
  .activity-card {
    background: white;
    border-radius: 12px;
    padding: 16px;
    border: 1px solid #e4e7ed;
    transition: all 0.3s ease;
    
    &:hover {
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 12px;
      
      .activity-title-mobile {
        font-size: 16px;
        font-weight: 500;
        color: #303133;
        line-height: 1.3;
        flex: 1;
        margin-right: 12px;
      }
      
      .status-group {
        display: flex;
        flex-direction: column;
        gap: 4px;
        align-items: flex-end;
      }
    }
    
    .card-content {
      .activity-info-mobile {
        margin-bottom: 12px;
        
        .info-item {
          display: flex;
          align-items: center;
          gap: 6px;
          margin-bottom: 6px;
          font-size: 14px;
          color: #606266;
        }
      }
      
      .time-info-mobile {
        .time-item {
          display: flex;
          align-items: center;
          gap: 6px;
          margin-bottom: 4px;
          font-size: 13px;
          color: #606266;
          
          .time-label {
            color: #909399;
            min-width: 40px;
          }
          
          .time-value {
            color: #303133;
            font-weight: 500;
          }
        }
      }
    }
    
    .card-actions {
      margin-top: 12px;
      padding-top: 12px;
      border-top: 1px solid #f0f0f0;
      text-align: center;
      
      .mobile-signin-btn {
        width: 100%;
        border-radius: 6px;
        font-weight: 500;
      }
    }
  }
  
  .empty-state {
    text-align: center;
    padding: 40px 20px;
  }
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .signin-container {
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
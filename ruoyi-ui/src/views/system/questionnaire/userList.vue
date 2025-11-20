<template>
  <div class="mobile-questionnaire">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">填写问卷</h1>
        <p class="page-subtitle">请填写以下问卷</p>
      </div>
      
    </div>
    
    <div class="content" v-loading="loading">
      <!-- 评价列表 -->
      <div v-if="questionnaireList.length > 0" class="questionnaire-list">
        <div 
          v-for="questionnaire in questionnaireList" 
          :key="questionnaire.metaId"
          class="questionnaire-item"
          @click="handleFill(questionnaire)"
        >
          <div class="questionnaire-header">
            <h3 class="title">{{ questionnaire.title }}</h3>
            <span 
              class="status" 
              :class="getStatusClass(questionnaire)"
            >
              {{ getStatusText(questionnaire) }}
            </span>
          </div>
          <p class="description">{{ questionnaire.description }}</p>
          <div class="questionnaire-footer">
            <span class="time">截止时间: {{ questionnaire.endTime}}</span>
            <i class="el-icon-arrow-right arrow"></i>
          </div>
        </div>
      </div>
      
      <!-- 空状态 -->
      <div v-else class="empty-state">
        <i class="el-icon-document"></i>
        <p>暂无评价</p>
      </div>
    </div>
  </div>
</template>

<script>
import { listQuestionnaire } from '@/api/system/questionnaire'
import { parseTime } from '@/utils'

export default {
  name: 'MobileQuestionnaireList',
  data() {
    return {
      loading: false,
      questionnaireList: []
    }
  },
  mounted() {
    this.getList()
  },
  methods: {
    parseTime,
    
    /** 查询评价列表 */
    getList() {
      this.loading = true
      // 获取路由中的查询参数
      const courseId = this.$route.query.courseId
      
      const queryParams = {
        pageNum: 1,
        pageSize: 100 // 显示更多数据
      }
      
      // 如果有课程ID参数，则添加筛选条件
      if (courseId) {
        queryParams.targetType = 'C'
        queryParams.targetRefId = courseId
      } else {
        // 如果没有课程ID参数，则只显示班级评价
        queryParams.targetType = 'D'
      }
      
      listQuestionnaire(queryParams).then(response => {
        this.questionnaireList = response.rows || response.data || []
        this.loading = false
      }).catch(error => {
        console.error('获取评价列表失败:', error)
        this.loading = false
        this.$message.error('获取评价列表失败')
      })
    },
    
    /** 填写评价按钮操作 */
    handleFill(row) {
      // 检查评价状态
      if (this.isExpired(row)) {
        this.$message.warning('该评价已过期，无法填写')
        return
      }
      
      if (this.isNotStarted(row)) {
        this.$message.warning('该评价未开始，无法填写')
        return
      }
      
      const metaId = row.metaId
      console.log('跳转到评价填写页面，评价ID:', metaId)
      
      // 使用移动端路由
      this.$router.push({
        path: `/mobile/questionnaire/userSubmit/${metaId}`
      })
    },
    
    /** 判断评价是否已过期 */
    isExpired(row) {
      if (!row.endTime) return false
      const now = new Date()
      const end = new Date(row.endTime)
      return now > end
    },
    
    /** 判断评价是否未开始 */
    isNotStarted(row) {
      if (!row.startTime) return false
      const now = new Date()
      const start = new Date(row.startTime)
      return now < start
    },
    
    /** 获取状态样式 */
    getStatusClass(row) {
      if (this.isExpired(row)) return 'status-expired'
      if (this.isNotStarted(row)) return 'status-pending'
      return 'status-active'
    },
    
    /** 获取状态文本 */
    getStatusText(row) {
      if (this.isExpired(row)) return '已过期'
      if (this.isNotStarted(row)) return '未开始'
      return '进行中'
    }
  }
}
</script>

<style scoped>
.mobile-questionnaire {
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


.header {
  background: white;
  padding: 15px;
  border-bottom: 1px solid #e4e7ed;
  display: flex;
  align-items: center;
  position: sticky;
  top: 0;
  z-index: 100;
}

.back-btn {
  background: none;
  border: none;
  font-size: 16px;
  margin-right: 10px;
  cursor: pointer;
  color: #606266;
}

.content {
  padding: 15px;
}

/* 评价列表样式 */
.questionnaire-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.questionnaire-item {
  background: white;
  border-radius: 8px;
  padding: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
}

.questionnaire-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.questionnaire-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 10px;
}

.title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin: 0;
  flex: 1;
  margin-right: 10px;
}

.status {
  font-size: 12px;
  padding: 4px 8px;
  border-radius: 10px;
  white-space: nowrap;
}

.status-active {
  background: #f6ffed;
  color: #52c41a;
}

.status-pending {
  background: #fff7e6;
  color: #fa8c16;
}

.status-expired {
  background: #fff2f0;
  color: #ff4d4f;
}

.description {
  font-size: 14px;
  color: #606266;
  margin: 0 0 10px 0;
  line-height: 1.4;
}

.questionnaire-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.time {
  font-size: 12px;
  color: #909399;
}

.arrow {
  color: #c0c4cc;
}

/* 空状态样式 */
.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #909399;
}

.empty-state i {
  font-size: 60px;
  margin-bottom: 20px;
  color: #dcdfe6;
}

.empty-state p {
  font-size: 16px;
  margin: 0;
}
</style>
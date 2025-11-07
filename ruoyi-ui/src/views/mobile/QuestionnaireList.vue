<template>
  <div class="mobile-questionnaire">
    <div class="header">
      <button @click="$router.back()" class="back-btn">← 返回</button>
      <h2>评价列表</h2>
    </div>
    
    <div class="content" v-loading="loading">
      <!-- 问卷列表 -->
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
        <p>暂无问卷</p>
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
    
    /** 查询问卷列表 */
    getList() {
      this.loading = true
      // 获取路由中的查询参数
      const courseId = this.$route.query.courseId
      
      const queryParams = {
        pageNum: 1,
        pageSize: 100 // 移动端显示更多数据
      }
      
      // 如果有课程ID参数，则添加筛选条件
      if (courseId) {
        queryParams.targetType = 'C'
        queryParams.targetRefId = courseId
      }
      
      listQuestionnaire(queryParams).then(response => {
        this.questionnaireList = response.rows || response.data || []
        this.loading = false
      }).catch(error => {
        console.error('获取问卷列表失败:', error)
        this.loading = false
        this.$message.error('获取问卷列表失败')
      })
    },
    
    /** 填写问卷按钮操作 */
    handleFill(row) {
      // 检查问卷状态
      if (this.isExpired(row)) {
        this.$message.warning('该问卷已过期，无法填写')
        return
      }
      
      if (this.isNotStarted(row)) {
        this.$message.warning('该问卷未开始，无法填写')
        return
      }
      
      const metaId = row.metaId
      console.log('跳转到问卷填写页面，问卷ID:', metaId)
      
      // 使用移动端路由
      this.$router.push({
        path: `/mobile/questionnaire/userSubmit/${metaId}`
      })
    },
    
    /** 判断问卷是否已过期 */
    isExpired(row) {
      if (!row.endTime) return false
      const now = new Date()
      const end = new Date(row.endTime)
      return now > end
    },
    
    /** 判断问卷是否未开始 */
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
  min-height: 100vh;
  background: #f5f7fa;
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

/* 问卷列表样式 */
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
  border-radius: 4px;
  font-weight: 500;
}

.status-active {
  background: #e8f4e8;
  color: #67c23a;
}

.status-expired {
  background: #fdecea;
  color: #f56c6c;
}

.status-pending {
  background: #f0f5ff;
  color: #409eff;
}

.description {
  font-size: 14px;
  color: #606266;
  margin: 0 0 12px 0;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.questionnaire-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  color: #909399;
}

.time {
  flex: 1;
}

.arrow {
  font-size: 16px;
  color: #c0c4cc;
}

/* 空状态样式 */
.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #909399;
}

.empty-state i {
  font-size: 48px;
  margin-bottom: 16px;
  color: #dcdfe6;
}

.empty-state p {
  font-size: 16px;
  margin: 0;
}
</style>
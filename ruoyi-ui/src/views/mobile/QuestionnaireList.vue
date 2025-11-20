<template>
  <div class="mobile-questionnaire">
    <div class="header">
      <el-page-header @back="goBack" content="评价列表">
      </el-page-header>
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
      } else {
        // 如果没有课程ID参数，则只显示班级评价
        queryParams.targetType = 'D'
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
    },
    /** 返回上一页 */
    goBack() {
      this.$router.go(-1);
    }
  }
}
</script>

<style scoped>
.mobile-questionnaire {
  padding: 10px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

.header {
  margin-bottom: 15px;
  
  ::v-deep .el-page-header {
    background: white;
    padding: 10px 15px;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  }
  
  ::v-deep .el-page-header__content {
    font-weight: bold;
    font-size: 16px;
  }
}

.back-btn {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  border-radius: 50%;
  width: 36px;
  height: 36px;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: white;
  transition: all 0.3s ease;
}

.back-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(1.05);
}

.header h2 {
  flex: 1;
  text-align: center;
  color: white;
  font-size: 18px;
  font-weight: 500;
  margin: 0;
  padding-right: 36px; /* 为返回按钮留出空间 */
}

.content {
  padding: 20px 15px;
}

/* 问卷列表样式 */
.questionnaire-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.questionnaire-item {
  background: white;
  border-radius: 16px;
  padding: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(64, 158, 255, 0.1);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.questionnaire-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, #409eff, #1a73e8);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.3s ease;
}

.questionnaire-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
}

.questionnaire-item:hover::before {
  transform: scaleX(1);
}

.questionnaire-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
}

.title {
  font-size: 17px;
  font-weight: 600;
  color: #303133;
  margin: 0;
  flex: 1;
  margin-right: 12px;
  line-height: 1.4;
}

.status {
  font-size: 12px;
  padding: 5px 10px;
  border-radius: 20px;
  font-weight: 500;
  white-space: nowrap;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.status-active {
  background: linear-gradient(90deg, #67c23a, #4daf1f);
  color: white;
}

.status-expired {
  background: linear-gradient(90deg, #f56c6c, #e43939);
  color: white;
}

.status-pending {
  background: linear-gradient(90deg, #409eff, #1a73e8);
  color: white;
}

.description {
  font-size: 14px;
  color: #606266;
  margin: 0 0 15px 0;
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
  padding-top: 12px;
  border-top: 1px dashed #eee;
}

.time {
  flex: 1;
}

.arrow {
  font-size: 16px;
  color: #c0c4cc;
  transition: transform 0.3s ease;
}

.questionnaire-item:hover .arrow {
  transform: translateX(3px);
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
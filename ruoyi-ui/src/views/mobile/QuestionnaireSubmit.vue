<template>
  <div class="mobile-questionnaire-submit">
    <div class="header">
      <button @click="cancel" class="back-btn">← 返回</button>
      <h2>评价课程</h2>
    </div>
    
    <div class="content" v-loading="loading">
      <div class="questionnaire-info">
        <h3 class="questionnaire-title">{{ form.title }}</h3>
        <p class="questionnaire-description">{{ form.description }}</p>
        <div class="questionnaire-time">
          <span>评价时间：{{ form.startTime }} 至 {{ form.endTime}}</span>
        </div>
      </div>
      
      <div class="questions-section">
        <div v-if="form.items && form.items.length > 0">
          <div 
            v-for="(question, index) in form.items" 
            :key="question.itemId" 
            class="question-item"
          >
            <div class="question-title">
              {{ index + 1 }}. {{ question.questionText }}
              <span class="required" v-if="question.required">*</span>
            </div>
            
            <div class="question-options">
              <div v-if="question.options && question.options.length > 0">
                <div 
                  v-for="(option, optIndex) in question.options" 
                  :key="optIndex"
                  class="option-item"
                  :class="{ selected: question.answer === option }"
                  @click="selectOption(question, option)"
                >
                  <div class="option-content">
                    <span class="option-letter">{{ String.fromCharCode(65 + optIndex) }}.</span>
                    <span class="option-text">{{ option }}</span>
                  </div>
                  <div class="option-check">
                    <i class="el-icon-check"></i>
                  </div>
                </div>
              </div>
              <div v-else class="no-options">
                <i class="el-icon-warning-outline"></i>
                该题目没有可用的选项
              </div>
            </div>
          </div>
        </div>
        
        <div v-else class="no-questions">
          <i class="el-icon-info"></i>
          该问卷暂无题目
        </div>
      </div>
      
      <div class="submit-section">
        <el-button 
          type="primary" 
          @click="submitForm" 
          :loading="submitLoading" 
          :disabled="!canSubmit"
          class="submit-btn"
        >
          提交问卷
        </el-button>
      </div>
    </div>
  </div>
</template>

<script>
import { getQuestionnaire, submitQuestionnaire, getQuestionnaireItems } from '@/api/system/questionnaire'
import { parseTime } from '@/utils'

export default {
  name: 'MobileQuestionnaireSubmit',
  data() {
    return {
      questionnaireMetaId: undefined,
      loading: false,
      submitLoading: false,
      form: {
        metaId: undefined,
        title: '',
        description: '',
        startTime: '',
        endTime: '',
        status: '',
        items: []
      },
      questionnaireItems: [],
      // 固定选项 - 与管理员侧保持一致
      fixedOptions: ["非常满意", "满意", "一般", "不满意", "非常不满意"]
    }
  },
  computed: {
    canSubmit() {
      if (!this.form.startTime || !this.form.endTime) return false
      const now = new Date()
      const start = new Date(this.form.startTime)
      const end = new Date(this.form.endTime)
      return now >= start && now <= end
    }
  },
  created() {
    const id = this.$route.params.questionnaireMetaId || this.$route.query.questionnaireMetaId
    if (!id) {
      this.$message.error('缺少问卷ID')
      this.$router.go(-1)
      return
    }
    this.questionnaireMetaId = Number(id)
    this.getQuestionnaireDetail(this.questionnaireMetaId)
  },
  methods: {
    parseTime,

    /** 获取问卷详情和题目信息 */
    async getQuestionnaireDetail(questionnaireMetaId) {
      try {
        this.loading = true
        // 并行获取问卷基本信息和题目信息
        const [questionnaireRes, itemsRes] = await Promise.all([
          getQuestionnaire(questionnaireMetaId),
          getQuestionnaireItems(questionnaireMetaId)
        ])

        if (questionnaireRes.code === 200) {
          this.form = questionnaireRes.data
        }

        if (itemsRes.code === 200) {
          this.questionnaireItems = itemsRes.data
          // 将题目信息同步到form.items用于表单填写
          this.form.items = this.processQuestionnaireItems(itemsRes.data)
        }
      } catch (error) {
        console.error('获取问卷详情失败:', error)
        this.$message.error('获取问卷信息失败')
      } finally {
        this.loading = false
      }
    },

    /** 处理题目数据，确保选项正确格式化 */
    processQuestionnaireItems(items) {
      if (!items || !items.length) {
        return []
      }

      return items.map(item => {
        // 确保每个题目都有answer属性
        const processedItem = {
          ...item,
          answer: item.answer || '' // 初始化答案为空字符串
        }

        // 始终使用固定选项
        processedItem.options = [...this.fixedOptions];

        return processedItem
      })
    },

    /** 选择选项 */
    selectOption(question, option) {
      // 单选逻辑：如果已选中则取消选择，否则选择该选项
      if (question.answer === option) {
        question.answer = ''
      } else {
        question.answer = option
      }
    },

    /** 提交表单 */
    submitForm() {
      // 检查必答题是否已填写
      const unansweredRequiredQuestions = this.form.items.filter(item => 
        item.required && (!item.answer || item.answer.trim() === '')
      )
      
      if (unansweredRequiredQuestions.length > 0) {
        this.$message.warning('请填写所有必答题')
        return
      }
      
      // 构造提交数据
      const submitData = this.form.items.map(item => ({
        itemId: item.itemId,
        answer: item.answer || ''
      }))
      
      this.submitLoading = true
      submitQuestionnaire(this.questionnaireMetaId, submitData)
        .then(response => {
          if (response.code === 200) {
            this.$message.success('问卷提交成功')
            this.$router.go(-1)
          } else {
            this.$message.error(response.msg || '提交失败')
          }
        })
        .catch(error => {
          console.error('提交问卷失败:', error)
          this.$message.error('提交问卷失败')
        })
        .finally(() => {
          this.submitLoading = false
        })
    },

    /** 取消 */
    cancel() {
      this.$router.go(-1)
    }
  }
}
</script>

<style scoped>
.mobile-questionnaire-submit {
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

.questionnaire-info {
  background: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.questionnaire-title {
  font-size: 20px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 10px 0;
}

.questionnaire-description {
  font-size: 14px;
  color: #606266;
  margin: 0 0 15px 0;
  line-height: 1.5;
}

.questionnaire-time {
  font-size: 12px;
  color: #909399;
  padding-top: 10px;
  border-top: 1px solid #eee;
}

.questions-section {
  background: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.question-item {
  margin-bottom: 25px;
}

.question-item:last-child {
  margin-bottom: 0;
}

.question-title {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
}

.required {
  color: #f56c6c;
  margin-left: 4px;
}

.option-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 15px;
  margin-bottom: 10px;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
  cursor: pointer;
  transition: all 0.3s ease;
}

.option-item:hover {
  border-color: #409eff;
  background-color: #f0f9ff;
}

.option-item.selected {
  border-color: #409eff;
  background-color: #ecf5ff;
}

.option-content {
  display: flex;
  align-items: center;
  flex: 1;
}

.option-letter {
  font-weight: 500;
  margin-right: 8px;
  color: #409eff;
}

.option-text {
  font-size: 14px;
  color: #606266;
}

.option-check {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 1px solid #dcdfe6;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.option-item.selected .option-check {
  background-color: #409eff;
  border-color: #409eff;
}

.option-item.selected .option-check i {
  color: white;
  font-size: 12px;
}

.no-options, .no-questions {
  text-align: center;
  padding: 30px;
  color: #909399;
  font-size: 14px;
}

.no-options i, .no-questions i {
  font-size: 24px;
  margin-bottom: 10px;
  display: block;
  color: #dcdfe6;
}

.submit-section {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  bottom: 0;
}

.submit-btn {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 500;
}
</style>
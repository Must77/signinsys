<template>
  <div class="app-container">
    <el-card class="questionnaire-card">
      <div slot="header" class="clearfix">
        <span class="questionnaire-title">{{ form.title }}</span>
      </div>

      <el-form ref="form" :model="form" label-width="0px">
        <el-row>
          <el-col :span="24">
            <div class="questionnaire-description">{{ form.description }}</div>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24">
            <div class="questionnaire-time">
              <span>问卷时间：{{ parseTime(form.startTime) }} 至 {{ parseTime(form.endTime) }}</span>
            </div>
          </el-col>
        </el-row>

        <!-- 题目信息展示区域 -->
        <el-row>
          <el-col :span="24">
            <el-card class="box-card">
              <div slot="header" class="clearfix">
                <span>题目信息</span>
              </div>
              <div v-if="questionnaireItems && questionnaireItems.length > 0">
                <div
                  v-for="(item, index) in questionnaireItems"
                  :key="item.itemId"
                  class="question-item-info"
                >
                  <h4>{{ index + 1 }}. {{ item.questionText }}</h4>
                  <p><strong>题目类型:</strong>
                    <span v-if="item.itemType === 'R'">单选题</span>
                    <span v-else-if="item.itemType === 'T'">文本题</span>
                    <span v-else>其他类型</span>
                  </p>
                  <p><strong>是否必填:</strong> {{ item.required ? '是' : '否' }}</p>
                  <div v-if="item.options && item.options.length > 0">
                    <p><strong>选项:</strong></p>
                    <ul>
                      <li v-for="(option, optIndex) in item.options" :key="optIndex">
                        {{ option }}
                      </li>
                    </ul>
                  </div>
                  <el-divider v-if="index < questionnaireItems.length - 1"></el-divider>
                </div>
              </div>
              <div v-else>
                <el-alert
                  title="暂无题目信息"
                  type="info"
                  show-icon
                  :closable="false"
                />
              </div>
            </el-card>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24">
            <div v-if="form.items && form.items.length > 0">
              <div
                v-for="(question, index) in form.items"
                :key="question.itemId"
                class="question-item"
              >
                <el-form-item
                  :prop="'items.' + index + '.answer'"
                  :rules="getQuestionRules(question)"
                >
                  <div class="question-title">
                    {{ index + 1 }}. {{ question.questionText }}
                    <span v-if="question.required" class="required">*</span>
                  </div>

                  <!-- 单选题 -->
                  <div v-if="question.itemType === 'R'" class="question-options">
                    <div v-if="question.options && question.options.length > 0">
                      <el-radio-group v-model="question.answer" class="radio-group">
                        <div
                          v-for="(option, optIndex) in question.options"
                          :key="optIndex"
                          class="radio-option"
                        >
                          <el-radio
                            :label="option"
                            class="custom-radio"
                          >
                            {{ String.fromCharCode(65 + optIndex) }}. {{ option }}
                          </el-radio>
                        </div>
                      </el-radio-group>
                    </div>
                    <div v-else class="no-options">
                      <el-alert
                        title="该题目没有可用的选项"
                        type="warning"
                        show-icon
                        :closable="false"
                      />
                    </div>
                  </div>

                  <!-- 文本题 -->
                  <div v-else-if="question.itemType === 'T'" class="question-text">
                    <el-input
                      v-model="question.answer"
                      type="textarea"
                      :rows="4"
                      :placeholder="question.placeholder || '请输入您的回答'"
                      class="text-answer"
                      clearable
                    />
                  </div>

                  <!-- 未知题型提示 -->
                  <div v-else class="unknown-question-type">
                    <el-alert
                      :title="'不支持的题目类型: ' + question.itemType"
                      type="warning"
                      show-icon
                    />
                  </div>
                </el-form-item>
              </div>
            </div>

            <div v-else class="no-questions">
              <el-alert
                title="该问卷暂无题目"
                type="info"
                show-icon
                :closable="false"
              />
            </div>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24" class="submit-button-container">
            <el-button
              type="primary"
              @click="submitForm"
              :loading="submitLoading"
              :disabled="!canSubmit"
            >
              提交问卷
            </el-button>
            <el-button @click="cancel">取消</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { getQuestionnaire, submitQuestionnaire, getQuestionnaireItems } from '@/api/system/questionnaire'
import { parseTime } from '@/utils'

export default {
  name: 'UserQuestionnaireSubmit',
  data() {
    return {
      questionnaireMetaId: undefined,
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
      questionnaireItems: []
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
      this.$modal.msgError('缺少问卷ID')
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
        // 并行获取问卷基本信息和题目信息
        const [questionnaireRes, itemsRes] = await Promise.all([
          getQuestionnaire(questionnaireMetaId),
          getQuestionnaireItems(questionnaireMetaId)
        ])
        
        console.log('问卷基本信息响应:', questionnaireRes)
        console.log('题目信息响应:', itemsRes)
        
        if (questionnaireRes.code === 200) {
          this.form = questionnaireRes.data
        }
        
        if (itemsRes.code === 200) {
          this.questionnaireItems = itemsRes.data
          // 将题目信息同步到form.items用于表单填写
          this.form.items = this.processQuestionnaireItems(itemsRes.data)
          console.log('处理后的题目数据:', this.form.items)
        }
        
      } catch (error) {
        console.error('获取问卷详情失败:', error)
        this.$modal.msgError('获取问卷信息失败')
      }
    },

    /** 处理题目数据，确保选项正确格式化 */
    processQuestionnaireItems(items) {
      if (!items || !items.length) {
        console.log('题目数据为空或未定义')
        return []
      }
      
      console.log('开始处理题目数据，原始数据:', items)
      
      const processedItems = items.map((item, index) => {
        console.log(`处理第${index + 1}个题目:`, item)
        
        // 确定问题文本
        let questionText = item.questionText || item.text || ''
        
        // 处理选项数据
        let options = []
        
        // 情况1: options字段直接包含选项数组
        if (item.options && Array.isArray(item.options)) {
          console.log(`题目${index + 1}的options字段:`, item.options)
          
          if (item.options.length > 0) {
            if (typeof item.options[0] === 'string') {
              // 选项是字符串数组
              options = item.options
            } else if (typeof item.options[0] === 'object') {
              // 选项是对象数组，提取文本
              options = item.options.map(opt => {
                return opt.optionText || opt.text || opt.value || opt.label || JSON.stringify(opt)
              }).filter(opt => opt && opt.trim() !== '')
            }
          }
        }
        
        // 情况2: 如果options为空，使用智能默认选项
        if (options.length === 0 && item.itemType === 'R') {
          options = this.getSmartDefaultOptions(questionText)
          console.log(`使用智能默认选项 for 题目${index + 1}:`, options)
        }
        
        console.log(`题目${index + 1}处理结果:`, {
          问题文本: questionText,
          选项: options,
          类型: item.itemType,
          必填: item.required
        })
        
        return {
          itemId: item.itemId || item.id || index,
          questionText: questionText,
          itemType: item.itemType || 'R',
          required: item.required !== false,
          answer: item.itemType === 'T' ? '' : null,
          options: options
        }
      })
      
      console.log('所有题目处理完成:', processedItems)
      return processedItems
    },

    /** 获取智能默认选项 */
    getSmartDefaultOptions(questionText) {
      const text = questionText.toLowerCase()
      
      // 根据问题内容提供相关的默认选项
      if (text.includes('满意') || text.includes('评价') || text.includes('评分')) {
        return ['非常满意', '满意', '一般', '不满意', '非常不满意']
      } else if (text.includes('频率') || text.includes('经常')) {
        return ['总是', '经常', '有时', '很少', '从不']
      } else if (text.includes('同意') || text.includes('认同')) {
        return ['非常同意', '同意', '一般', '不同意', '非常不同意']
      } else if (text.includes('重要') || text.includes('重视')) {
        return ['非常重要', '重要', '一般', '不重要', '非常不重要']
      } else {
        // 通用选项
        return ['选项A', '选项B', '选项C', '选项D', '选项E']
      }
    },

    /** 校验规则 */
    getQuestionRules(question) {
      if (!question.required) return []
      if (question.itemType === 'R') {
        return [{ required: true, message: '请选择一个选项', trigger: 'change' }]
      } else if (question.itemType === 'T') {
        return [
          { required: true, message: '请输入回答内容', trigger: 'blur' },
          { min: 1, max: 500, message: '长度在 1 到 500 个字符', trigger: 'blur' }
        ]
      }
      return [{ required: true, message: '该题目不能为空', trigger: 'change' }]
    },

    /** 提交问卷 */
    async submitForm() {
      try {
        // 表单验证
        const valid = await this.$refs.form.validate()
        if (!valid) return
        
        if (!this.canSubmit) {
          this.$modal.msgError('问卷不在有效期内，无法提交')
          return
        }
        
        if (!this.form.items || this.form.items.length === 0) {
          this.$modal.msgError('问卷没有题目，无法提交')
          return
        }

        // 构建提交数据
        const submissionData = {
          metaId: this.questionnaireMetaId,
          answers: this.form.items.map(item => ({
            itemId: item.itemId,
            answer: item.answer || '',
            itemType: item.itemType
          }))
        }

        console.log('提交的数据:', submissionData)
        
        this.submitLoading = true
        const response = await submitQuestionnaire(this.questionnaireMetaId, submissionData)
        
        if (response.code === 200) {
          this.$modal.msgSuccess('问卷提交成功')
          this.$router.go(-1)
        } else {
          this.$modal.msgError(response.msg || '提交失败')
        }
      } catch (error) {
        console.error('提交失败:', error)
        if (error && !error.message.includes('validation')) {
          this.$modal.msgError('提交失败，请重试')
        }
      } finally {
        this.submitLoading = false
      }
    },

    /** 返回上一页 */
    cancel() {
      this.$router.go(-1)
    }
  }
}
</script>

<style scoped>
.questionnaire-card {
  max-width: 800px;
  margin: 0 auto;
}
.questionnaire-title {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}
.questionnaire-description {
  font-size: 16px;
  color: #606266;
  margin: 15px 0;
  line-height: 1.6;
}
.questionnaire-time {
  font-size: 14px;
  color: #909399;
  margin-bottom: 20px;
  padding: 10px;
  background-color: #f4f4f5;
  border-radius: 4px;
}
.question-item-info {
  padding: 15px 0;
}
.question-item-info h4 {
  margin: 0 0 10px 0;
  color: #303133;
}
.question-item-info p {
  margin: 5px 0;
  color: #606266;
}
.question-item-info ul {
  margin: 5px 0 5px 20px;
  padding: 0;
}
.question-item-info li {
  margin: 3px 0;
  color: #606266;
}
.question-item {
  margin-bottom: 30px;
  padding: 20px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  background-color: #fafafa;
}
.question-title {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 15px;
}
.required {
  color: #f56c6c;
}
.question-options {
  margin-top: 10px;
}
.radio-group {
  display: flex;
  flex-direction: column;
}
.radio-option {
  margin-bottom: 10px;
}
.custom-radio {
  width: 100%;
  margin-right: 0;
  padding: 10px;
  border-radius: 4px;
  transition: all 0.3s;
}
.custom-radio:hover {
  background-color: #f0f9eb;
}
.question-text {
  margin-top: 10px;
}
.text-answer {
  width: 100%;
}
.unknown-question-type {
  margin-top: 10px;
}
.no-options {
  padding: 10px;
  background-color: #fffbf0;
  border: 1px solid #fdf6ec;
  border-radius: 4px;
  margin-top: 10px;
}
.no-questions {
  text-align: center;
  padding: 40px 0;
}
.submit-button-container {
  text-align: center;
  margin-top: 30px;
}
</style>
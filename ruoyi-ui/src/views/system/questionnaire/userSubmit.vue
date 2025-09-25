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
                          {{ option }}
                        </el-radio>
                      </div>
                    </el-radio-group>
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
    /** 获取问卷详情 */
    getQuestionnaireDetail(questionnaireMetaId) {
      getQuestionnaire(questionnaireMetaId).then(response => {
        this.form = response.data
        if (this.form.items && this.form.items.length > 0) {
          this.form.items.forEach(question => {
            if (question.itemType === 'R') {
              this.$set(question, 'answer', null)
            } else {
              this.$set(question, 'answer', '')
            }

            if (!question.options) {
              this.$set(question, 'options', [])
            } else if (question.options.length && typeof question.options[0] === 'object') {
              const formattedOptions = question.options.map(opt =>
                typeof opt === 'object' && opt !== null ? opt.optionText || opt.optionValue || '' : opt || ''
              )
              this.$set(question, 'options', formattedOptions)
            }
          })
        }
      })
      this.getQuestionnaireItems(questionnaireMetaId)
    },

    /** 获取题目信息 */
    getQuestionnaireItems(questionnaireMetaId) {
      getQuestionnaireItems(questionnaireMetaId).then(response => {
        this.questionnaireItems = response.data
      })
    },

    /** 校验规则 */
    getQuestionRules(question) {
      if (!question.required) return []
      if (question.itemType === 'R') {
        return [{ required: true, message: '请选择一个选项', trigger: 'change' }]
      } else if (question.itemType === 'T') {
        return [{ required: true, message: '请输入回答内容', trigger: 'blur' }]
      }
      return [{ required: true, message: '该题目不能为空', trigger: 'change' }]
    },

    /** 提交问卷 - 只传纯数组 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        if (!this.canSubmit) {
          this.$modal.msgError('问卷不在有效期内，无法提交')
          return
        }
        const questions = this.form.items.length ? this.form.items : this.questionnaireItems
        if (!questions.length) {
          this.$modal.msgError('问卷没有题目，无法提交')
          return
        }

        // 直接生成纯数组，不再包对象
        const answers = questions.map(q => ({
          itemId: q.itemId,
          score: q.itemType === 'R' && q.answer !== null ? q.options.findIndex(o => o === q.answer) + 1 : null,
          textAnswer: q.itemType === 'T' ? (q.answer || '') : ''
        }))

        this.submitLoading = true
        submitQuestionnaire(this.questionnaireMetaId, answers)
          .then(() => {
            this.$modal.msgSuccess('问卷提交成功')
            this.submitLoading = false
            this.$router.go(-1)
          })
          .catch(() => {
            this.submitLoading = false
            this.$modal.msgError('提交失败，请重试')
          })
      })
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
.no-questions {
  text-align: center;
  padding: 40px 0;
}
.submit-button-container {
  text-align: center;
  margin-top: 30px;
}
</style>
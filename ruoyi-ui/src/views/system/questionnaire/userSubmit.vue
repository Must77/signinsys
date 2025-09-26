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

        <el-row>
          <el-col :span="24">
            <div v-if="form.items && form.items.length > 0">
              <div v-for="(question, index) in form.items" :key="question.itemId" class="question-item">
                <el-form-item :prop="'items.' + index + '.answer'" :rules="getQuestionRules(question)">
                  <div class="question-title">
                    {{ index + 1 }}. {{ question.questionText }}
                    <span class="required">*</span>
                  </div>

                  <!-- 单选题 -->
                  <div class="question-options">
                    <div v-if="question.options && question.options.length > 0">
                      <el-radio-group v-model="question.answer" class="radio-group">
                        <div v-for="(option, optIndex) in question.options" :key="optIndex" class="radio-option">
                          <el-radio :label="option" class="custom-radio">
                            {{ String.fromCharCode(65 + optIndex) }}. {{ option }}
                          </el-radio>
                        </div>
                      </el-radio-group>
                    </div>
                    <div v-else class="no-options">
                      <el-alert title="该题目没有可用的选项" type="warning" show-icon :closable="false" />
                    </div>
                  </div>
                </el-form-item>
              </div>
            </div>

            <div v-else class="no-questions">
              <el-alert title="该问卷暂无题目" type="info" show-icon :closable="false" />
            </div>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24" class="submit-button-container">
            <el-button type="primary" @click="submitForm" :loading="submitLoading" :disabled="!canSubmit">
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

        // 处理选项数据 - 直接使用固定选项，忽略后端返回的选项
        let options = [...this.fixedOptions] // 使用固定选项的副本

        console.log(`题目${index + 1}处理结果:`, {
          问题文本: questionText,
          选项: options,
          类型: item.itemType,
          必填: item.required
        })

        return {
          itemId: item.itemId || item.id || index,
          questionText: questionText,
          itemType: 'R', // 固定为单选题
          required: true, // 所有题目都必填
          answer: null, // 初始化为null
          options: options
        }
      })

      console.log('所有题目处理完成:', processedItems)
      return processedItems
    },

    /** 校验规则 */
    getQuestionRules(question) {
      // 所有题目都必填
      return [{ required: true, message: '请选择一个选项', trigger: 'change' }]
    },

    /** 提交问卷 */
    async submitForm() {
      try {
        // 表单验证
        const valid = await this.$refs.form.validate()
        if (!valid) {
          this.$modal.msgError('请完成所有题目的填写')
          return
        }

        if (!this.canSubmit) {
          this.$modal.msgError('问卷不在有效期内，无法提交')
          return
        }

        if (!this.form.items || this.form.items.length === 0) {
          this.$modal.msgError('问卷没有题目，无法提交')
          return
        }

        // 验证是否所有题目都已填写
        const unansweredQuestions = this.form.items.filter(item =>
          !item.answer || item.answer.toString().trim() === ''
        )

        if (unansweredQuestions.length > 0) {
          this.$modal.msgError('请完成所有题目的填写')
          return
        }

        // ========== 添加字段映射调试代码开始 ==========
        console.log('=== 字段映射调试 ===');
        this.form.items.forEach((item, index) => {
          const scoreMap = {
            "非常满意": 5, "满意": 4, "一般": 3, "不满意": 2, "非常不满意": 1
          };
          const score = scoreMap[item.answer] || null;

          console.log(`题目${index + 1}:`, {
            原始答案: item.answer,
            映射分数: score,
            itemId: item.itemId
          });
        });
        // ========== 添加字段映射调试代码结束 ==========

        // 选项到分数的映射
        const optionScoreMap = {
          "非常满意": 5,
          "满意": 4,
          "一般": 3,
          "不满意": 2,
          "非常不满意": 1
        };

        // 构建提交数据：使用后端期望的字段名
        const answers = this.form.items.map(item => {
          // 根据选项内容计算分数
          let score = null;
          let textAnswer = "";

          if (item.answer) {
            // 如果是选择题，映射分数
            if (optionScoreMap.hasOwnProperty(item.answer)) {
              score = optionScoreMap[item.answer];
              textAnswer = ""; // 选择题文本答案为空
            } else {
              // 如果是其他答案（理论上不会发生，因为只有固定选项）
              score = null;
              textAnswer = item.answer; // 将答案作为文本答案
            }
          }

          return {
            itemId: item.itemId,
            score: score,
            textAnswer: textAnswer
          };
        });

        console.log('提交的数据（修正后）:', JSON.stringify(answers, null, 2));

        this.submitLoading = true;

        // 直接传递修正后的数据给后端
        const response = await submitQuestionnaire(this.questionnaireMetaId, answers);

        if (response.code === 200) {
          this.$modal.msgSuccess('问卷提交成功');
          setTimeout(() => {
            this.$router.go(-1);
          }, 1500);
        } else {
          this.$modal.msgError(response.msg || '提交失败');
        }
      } catch (error) {
        console.error('提交失败详情:', error);
        this.handleSubmitError(error);
      } finally {
        this.submitLoading = false;
      }
    },
    /** 处理提交错误 */
    handleSubmitError(error) {
      if (error.response) {
        const status = error.response.status;
        const data = error.response.data;

        if (status === 400) {
          // 检查是否是字段不匹配错误
          if (data.message && (
            data.message.includes('score') ||
            data.message.includes('textAnswer') ||
            data.message.includes('field') ||
            data.message.includes('property')
          )) {
            this.$modal.msgError('数据字段不匹配，请联系管理员检查接口文档');
          } else {
            this.$modal.msgError('请求数据格式错误: ' + (data.message || '请检查填写内容'));
          }
        } else if (status === 409) {
          this.$modal.msgWarning("该用户已提交过该问卷");
        } else if (status === 500) {
          this.$modal.msgError('服务器错误，请稍后重试');
        } else {
          this.$modal.msgError(`提交失败: ${data.message || error.message}`);
        }
      } else if (error.request) {
        this.$modal.msgError('网络错误，请检查网络连接');
      } else {
        this.$modal.msgError(`提交失败: ${error.message}`);
      }
    },
    /** 处理重复提交错误 */
    handleDuplicateSubmission() {
      this.$modal.confirm('检测到您可能因为网络或数据格式问题被标记为已提交，是否尝试清除提交记录并重新提交？', '提示', {
        confirmButtonText: '清除并重新提交',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          // 调用清除重复提交记录的API
          await this.clearSubmissionRecord()
          this.$modal.msgSuccess('清除成功，请重新提交问卷')
          // 重新加载页面以重置状态
          location.reload()
        } catch (error) {
          this.$modal.msgError('清除失败，请联系管理员')
        }
      }).catch(() => {
        this.$modal.msgInfo('已取消操作')
      })
    },

    /** 清除重复提交记录 */
    async clearSubmissionRecord() {
      // 这里需要调用后端的清除重复提交记录的接口
      // 如果没有专门的接口，可能需要后端配合添加
      return new Promise((resolve) => {
        setTimeout(() => resolve(), 1000)
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
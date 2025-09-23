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
              <div 
                v-for="(question, index) in form.items" 
                :key="question.questionId" 
                class="question-item"
              >
                <el-form-item 
                  :prop="'items.' + index + '.answer'" 
                  :rules="getQuestionRules(question)"
                >
                  <div class="question-title">
                    {{ index + 1 }}. {{ question.questionTitle }}
                    <span v-if="question.questionType !== 'text'" class="required">*</span>
                  </div>
                  
                  <!-- 单选题 -->
                  <div v-if="question.questionType === 'radio'" class="question-options">
                    <el-radio-group v-model="question.answer" class="radio-group">
                      <div 
                        v-for="(option, optIndex) in question.options" 
                        :key="optIndex" 
                        class="radio-option"
                      >
                        <el-radio 
                          :label="option.optionText" 
                          class="custom-radio"
                        >
                          {{ option.optionText }}
                        </el-radio>
                      </div>
                    </el-radio-group>
                  </div>
                  
                  <!-- 多选题 -->
                  <div v-else-if="question.questionType === 'checkbox'" class="question-options">
                    <el-checkbox-group v-model="question.answer" class="checkbox-group">
                      <div 
                        v-for="(option, optIndex) in question.options" 
                        :key="optIndex" 
                        class="checkbox-option"
                      >
                        <el-checkbox 
                          :label="option.optionText" 
                          class="custom-checkbox"
                        >
                          {{ option.optionText }}
                        </el-checkbox>
                      </div>
                    </el-checkbox-group>
                  </div>
                  
                  <!-- 文本题 -->
                  <div v-else-if="question.questionType === 'text'" class="question-text">
                    <el-input 
                      v-model="question.answer" 
                      type="textarea" 
                      :rows="4" 
                      placeholder="请输入您的回答"
                      class="text-answer"
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
import { getQuestionnaire, submitQuestionnaire } from "@/api/system/questionnaire";
import { parseTime } from "@/utils/ruoyi";

export default {
  name: "UserQuestionnaireSubmit",
  data() {
    return {
      metaId: undefined,
      submitLoading: false,
      form: {
        metaId: undefined,
        title: undefined,
        description: undefined,
        startTime: undefined,
        endTime: undefined,
        status: undefined,
        items: []
      }
    };
  },
  computed: {
    canSubmit() {
      // 检查问卷是否在有效期内
      if (!this.form.startTime || !this.form.endTime) return false;
      
      const now = new Date();
      const start = new Date(this.form.startTime);
      const end = new Date(this.form.endTime);
      
      return now >= start && now <= end;
    }
  },
  created() {
    const metaId = this.$route.params.metaId || this.$route.query.metaId;
    this.metaId = metaId;
    this.getQuestionnaireDetail(metaId);
  },
  methods: {
    /** 获取问卷详情 */
    getQuestionnaireDetail(metaId) {
      getQuestionnaire(metaId).then(response => {
        this.form = response.data;
        // 初始化答案数组
        if (this.form.items && this.form.items.length > 0) {
          this.form.items.forEach(question => {
            if (question.questionType === 'checkbox') {
              // 多选题初始化为空数组
              this.$set(question, 'answer', []);
            } else {
              // 单选和文本题初始化为空字符串
              this.$set(question, 'answer', '');
            }
          });
        }
      });
    },
    
    /** 获取题目验证规则 */
    getQuestionRules(question) {
      // 文本题可选，其他题目必填
      if (question.questionType === 'text') {
        return [];
      }
      
      return [
        { 
          required: true, 
          message: '该题目不能为空', 
          trigger: question.questionType === 'radio' ? 'change' : 'change' 
        }
      ];
    },
    
    /** 提交表单 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 检查问卷是否在有效期内
          if (!this.canSubmit) {
            this.$modal.msgError("问卷不在有效期内，无法提交");
            return;
          }
          
          // 构造提交数据
          const submitData = {
            metaId: this.form.metaId,
            answers: []
          };
          
          // 处理每个问题的答案
          this.form.items.forEach(question => {
            let answerValue = question.answer;
            
            // 多选题需要转换为逗号分隔的字符串
            if (question.questionType === 'checkbox' && Array.isArray(answerValue)) {
              answerValue = answerValue.join(',');
            }
            
            submitData.answers.push({
              questionId: question.questionId,
              answerText: answerValue || ''
            });
          });
          
          this.submitLoading = true;
          submitQuestionnaire(this.metaId, submitData).then(response => {
            this.$modal.msgSuccess("问卷提交成功");
            this.submitLoading = false;
            // 提交成功后返回上一页或指定页面
            this.$router.go(-1);
          }).catch(error => {
            console.error(error);
            this.$modal.msgError("提交失败，请重试");
            this.submitLoading = false;
          });
        }
      });
    },
    
    /** 取消 */
    cancel() {
      this.$router.go(-1);
    },
    
    parseTime
  }
};
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

.radio-group, .checkbox-group {
  display: flex;
  flex-direction: column;
}

.radio-option, .checkbox-option {
  margin-bottom: 10px;
}

.custom-radio, .custom-checkbox {
  width: 100%;
  margin-right: 0;
  padding: 10px;
  border-radius: 4px;
  transition: all 0.3s;
}

.custom-radio:hover, .custom-checkbox:hover {
  background-color: #f0f9eb;
}

.question-text {
  margin-top: 10px;
}

.text-answer {
  width: 100%;
}

.no-questions {
  text-align: center;
  padding: 40px 0;
}

.submit-button-container {
  text-align: center;
  margin-top: 30px;
}
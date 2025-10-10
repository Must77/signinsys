<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="问卷标题" prop="title">
        <el-input v-model="queryParams.title" placeholder="请输入问卷标题" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['system:questionnaire:list']">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd"
          v-hasPermi="['system:questionnaire:add']">新增</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="questionnaireList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="问卷ID" align="center" prop="metaId" />
      <el-table-column label="问卷标题" align="center" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="描述" align="center" prop="description" :show-overflow-tooltip="true" />
      <el-table-column label="开始时间" align="center" prop="startTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.startTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="结束时间" align="center" prop="endTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.endTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-tickets" @click="handleViewItems(scope.row)"
            v-hasPermi="['system:questionnaire:query']">查看题目</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['system:questionnaire:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)"
            v-hasPermi="['system:questionnaire:remove']">删除</el-button>
          <el-button size="mini" type="text" icon="el-icon-document" @click="handleSubmissions(scope.row)"
            v-hasPermi="['']">提交记录</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
      @pagination="getList" />

    <!-- 添加或修改问卷对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="900px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="问卷标题" prop="title">
              <el-input v-model="form.title" placeholder="请输入问卷标题" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="描述" prop="description">
              <el-input v-model="form.description" type="textarea" placeholder="请输入描述" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="开始时间" prop="startTime">
              <el-date-picker v-model="form.startTime" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"
                placeholder="请选择开始时间">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束时间" prop="endTime">
              <el-date-picker v-model="form.endTime" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"
                placeholder="请选择结束时间">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-card class="box-card">
              <div slot="header" class="clearfix">
                <span>问题列表</span>
                <el-button style="float: right; padding: 3px 0" type="primary" icon="el-icon-plus"
                  @click="addQuestion">添加问题</el-button>
              </div>

              <!-- 题目信息表格形式展示 -->
              <el-table :data="form.items" style="width: 100%" border>
                <el-table-column label="序号" type="index" width="50" align="center"></el-table-column>
                <el-table-column label="题目类型" width="100">
                  <template slot-scope="scope">
                    <!-- 只显示单选题，移除文本题选项 -->
                    <el-tag type="primary">单选题</el-tag>
                    <input type="hidden" v-model="scope.row.questionType" value="R" />
                  </template>
                </el-table-column>
                <el-table-column label="题目内容" prop="questionText">
                  <template slot-scope="scope">
                    <el-input v-model="scope.row.questionText" placeholder="请输入题目内容" size="mini"></el-input>
                  </template>
                </el-table-column>
                <el-table-column label="选项" width="300">
                  <template slot-scope="scope">
                    <!-- 固定选项显示，不可编辑 -->
                    <div class="fixed-options">
                      <div v-for="(option, optIndex) in scope.row.options" :key="optIndex" class="fixed-option-item">
                        <span class="option-label">{{ String.fromCharCode(65 + optIndex) }}.</span>
                        <span class="option-text">{{ option }}</span>
                      </div>
                      <div class="fixed-options-tip">此为固定选项，不可修改</div>
                    </div>
                  </template>
                </el-table-column>
                <el-table-column label="操作" width="100">
                  <template slot-scope="scope">
                    <el-button @click="moveUp(scope.$index)" type="primary" size="mini" icon="el-icon-arrow-up" circle
                      :disabled="scope.$index === 0"></el-button>
                    <el-button @click="moveDown(scope.$index)" type="primary" size="mini" icon="el-icon-arrow-down"
                      circle :disabled="scope.$index === form.items.length - 1"></el-button>
                    <el-button @click="removeQuestion(scope.$index)" type="danger" size="mini" icon="el-icon-delete"
                      circle></el-button>
                  </template>
                </el-table-column>
              </el-table>
            </el-card>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 问卷提交记录对话框 -->
    <el-dialog title="提交记录" :visible.sync="submissionsOpen" width="1000px" append-to-body>

      <el-table :data="submissions" border>
        <el-table-column prop="submissionId" label="提交ID" width="80" />
        <!-- <el-table-column prop="userName" label="提交人" width="120" /> -->
        <el-table-column prop="createTime" label="提交时间" width="180" />
        <el-table-column label="操作" width="150">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view"
              @click="handleViewAnswers(scope.row)">查看回答</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination v-show="submissionsTotal > 0" :total="submissionsTotal" :page.sync="submissionsQueryParams.pageNum"
        :limit.sync="submissionsQueryParams.pageSize" @pagination="getSubmissions" />
    </el-dialog>

    <!-- 回答详情对话框 -->
    <el-dialog title="回答详情" :visible.sync="answersOpen" width="800px" append-to-body>
      <el-table :data="answers" border>
        <!-- 与对象完全一致 -->
        <el-table-column prop="answerId" label="回答ID" width="80" />
        <el-table-column prop="itemId" label="题目ID" width="80" />
        <el-table-column prop="score" label="得分" width="80" />
        <!-- <el-table-column prop="textAnswer" label="文本回答" /> -->
        <el-table-column prop="createTime" label="回答时间" width="180" />
      </el-table>
    </el-dialog>

    <!-- 题目信息对话框 -->
    <el-dialog title="题目信息" :visible.sync="itemsOpen" width="800px" append-to-body>
      <el-table :data="questionItems" border>
        <el-table-column label="序号" type="index" width="50" align="center" />
        <el-table-column label="题目类型" prop="itemType" width="80" align="center">
          <template slot-scope="scope">
            <el-tag>单选</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="题目内容" prop="questionText" />
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import { addQuestionnaire, getQuestionnaire, listQuestionnaire, updateQuestionnaire, delQuestionnaire, listSubmissions, getSubmissionAnswers, listSubmission, getQuestionnaireItems } from "@/api/system/questionnaire";

export default {
  name: "Questionnaire",
  data() {
    // 定义固定选项
    const defaultOptions = ["非常满意", "满意", "一般", "不满意", "非常不满意"];

    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 问卷表格数据
      questionnaireList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否显示提交记录弹出层
      submissionsOpen: false,
      // 是否显示题目信息弹出层
      itemsOpen: false,
      // 是否显示回答详情弹出层
      answersOpen: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        title: undefined,
        status: undefined
      },
      // 表单参数
      form: {
        metaId: undefined,
        title: undefined,
        description: undefined,
        startTime: undefined,
        endTime: undefined,
        status: "0",
        allowRepeat: "0",
        targetType: "C",
        targetRefId: 120,
        deptId: 16,
        items: []
      },
      // 固定选项
      defaultOptions: defaultOptions,
      // 表单校验
      rules: {
        title: [
          { required: true, message: "问卷标题不能为空", trigger: "blur" }
        ],
        startTime: [
          { required: true, message: "开始时间不能为空", trigger: "change" }
        ],
        endTime: [
          { required: true, message: "结束时间不能为空", trigger: "change" }
        ]
      },
      // 提交记录数据
      submissions: [],
      // 题目信息数据
      questionItems: [],
      // 提交记录总数
      submissionsTotal: 0,
      // 提交记录查询参数
      submissionsQueryParams: {
        pageNum: 1,
        pageSize: 10,
        metaId: undefined
      },
      // 回答数据
      answers: []
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询问卷列表 */
    getList() {
      this.loading = true;
      listQuestionnaire(this.queryParams).then(response => {
        this.questionnaireList = response.data;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 查询提交记录 */
    getSubmissions() {
      listSubmissions(this.submissionsQueryParams.metaId, this.submissionsQueryParams).then(response => {
        console.log('【调试】提交记录原始返回', response)
        // 接口返回的是 data 数组，不是 rows
        this.submissions = Array.isArray(response.data) ? response.data : []
        this.submissionsTotal = this.submissions.length
        console.log('【调试】this.submissions', this.submissions)
      }).catch(err => {
        console.error('【调试】接口异常', err)
        this.submissions = []
        this.submissionsTotal = 0
      })
    },
    /** 查询回答详情 */
    // getAnswers(submissionId) {
    //   getSubmissionAnswers(submissionId).then(response => {
    //     this.answers = response.data;
    //   });
    // },
    getAnswers(submissionId) {
      getSubmissionAnswers(submissionId).then(response => {
        console.log('【调试】回答详情原始返回', response)
        // 接口返回的是 data 数组，不是 rows
        this.answers = Array.isArray(response.data) ? response.data : []
        console.log('【调试】this.answers', this.answers)
      }).catch(err => {
        console.error('【调试】接口异常', err)
        this.answers = []
      })
    },
    /** 查询题目信息 */
    getQuestionItems(metaId) {
      getQuestionnaireItems(metaId).then(response => {
        this.questionItems = response.data;
        this.itemsOpen = true;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.metaId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加问卷";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const metaId = row.metaId || this.ids
      getQuestionnaire(metaId).then(response => {
        this.form = response.data;

        // 转换题目列表结构以适配前端表单
        if (this.form.items && Array.isArray(this.form.items)) {
          this.form.items = this.form.items.map(item => {
            // 所有题目都是单选题
            let questionType = "R";

            // 处理选项结构
            let options = [];
            if (item.options && Array.isArray(item.options)) {
              // 如果选项是对象数组，提取optionText；如果是字符串数组，直接使用
              options = item.options.map(opt =>
                typeof opt === 'object' && opt !== null ? opt.optionText : opt
              );
            }

            // 如果没有选项，使用默认选项
            if (options.length === 0) {
              options = [...this.defaultOptions];
            }

            return {
              questionType: questionType,
              questionText: item.questionText,
              options: options
            };
          });
        }

        this.open = true;
        this.title = "修改问卷";
      });
    },
    /** 提交记录按钮操作 */
    handleSubmissions(row) {
      this.submissionsQueryParams.metaId = row.metaId;
      this.getSubmissions();
      this.submissionsOpen = true;
    },
    /** 查看回答按钮操作 */
    handleViewAnswers(row) {
      this.getAnswers(row.submissionId);
      this.answersOpen = true;
    },
    /** 查看题目按钮操作 */
    handleViewItems(row) {
      this.getQuestionItems(row.metaId);
    },
    /** 表单重置 */
    reset() {
      this.form = {
        metaId: undefined,
        title: undefined,
        description: undefined,
        startTime: undefined,
        endTime: undefined,
        status: "0",
        allowRepeat: "0",
        targetType: "C",
        targetRefId: 120,
        deptId: 16,
        items: []
      };
      this.resetForm("form");
    },
    /** 取消按钮 */
    cancel() {
      this.open = false;
      this.reset();
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return;

        // 1. 深拷贝
        const postData = JSON.parse(JSON.stringify(this.form));

        // 2. 转换数据格式以匹配后端API要求
        // 添加缺失的字段
        postData.targetType = "C";
        postData.targetRefId = 120;
        postData.deptId = 16;

        // 转换 items 字段格式
        postData.items = (postData.items || []).map((q, idx) => {
          // 处理选项字段
          let options = [];
          if (q.options && Array.isArray(q.options)) {
            // 如果选项是对象数组，提取optionText；如果是字符串数组，直接使用
            options = q.options.map(opt =>
              typeof opt === 'object' && opt !== null ? opt.optionText : opt
            );
          }

          return {
            itemType: "R",  // 固定为单选题
            questionText: q.questionText,
            orderNum: idx + 1,
            required: true,  // 所有题目都必填
            options: options
          };
        });

        // 3. 发请求
        const api = postData.metaId
          ? updateQuestionnaire(postData)
          : addQuestionnaire(postData);

        api.then(() => {
          this.$modal.msgSuccess(postData.metaId ? '修改成功' : '新增成功');
          this.open = false;
          this.getList();
        });
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const metaIds = row.metaId || this.ids;
      this.$modal.confirm('是否确认删除问卷编号为"' + metaIds + '"的数据项？').then(function () {
        return delQuestionnaire(metaIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => { });
    },
    /** 添加问题 */
    addQuestion() {
      // 确保items数组存在
      if (!this.form.items) {
        this.$set(this.form, 'items', []);
      }

      this.form.items.push({
        questionType: "R",
        questionText: "",
        options: [...this.defaultOptions] // 使用固定选项的副本
      });
    },
    /** 删除问题 */
    removeQuestion(index) {
      this.form.items.splice(index, 1);
    },
    /** 上移题目 */
    moveUp(index) {
      if (index > 0) {
        const temp = this.form.items[index];
        this.$set(this.form.items, index, this.form.items[index - 1]);
        this.$set(this.form.items, index - 1, temp);
      }
    },
    /** 下移题目 */
    moveDown(index) {
      if (index < this.form.items.length - 1) {
        const temp = this.form.items[index];
        this.$set(this.form.items, index, this.form.items[index + 1]);
        this.$set(this.form.items, index + 1, temp);
      }
    },
    /** 格式化回答 */
    formatAnswer(answer) {
      if (Array.isArray(answer.answerText)) {
        return answer.answerText.join(', ');
      }
      return answer.answerText;
    }
  }
};
</script>

<style scoped>
.question-list {
  padding: 0;
  list-style: none;
}

.question-item {
  margin-bottom: 15px;
}

.question-card {
  border-radius: 4px;
}

/* 固定选项样式 */
.fixed-options {
  padding: 8px;
  border: 1px solid #e6e6e6;
  border-radius: 4px;
  background-color: #f9f9f9;
}

.fixed-option-item {
  display: flex;
  align-items: center;
  margin-bottom: 5px;
  padding: 4px 0;
}

.option-label {
  font-weight: bold;
  margin-right: 8px;
  min-width: 20px;
}

.option-text {
  color: #666;
}

.fixed-options-tip {
  margin-top: 8px;
  padding-top: 8px;
  border-top: 1px dashed #ddd;
  font-size: 12px;
  color: #999;
  text-align: center;
}

.no-options-hint {
  margin-top: 10px;
}
</style>
<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="问卷标题" prop="title">
        <el-input v-model="queryParams.title" placeholder="请输入问卷标题" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <!-- <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="草稿" value="0" />
          <el-option label="发布" value="1" />
          <el-option label="关闭" value="2" />
        </el-select>
      </el-form-item> -->
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd"
          v-hasPermi="['system:questionnaire:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate"
          v-hasPermi="['system:questionnaire:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['system:questionnaire:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="questionnaireList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="问卷ID" align="center" prop="metaId" />
      <el-table-column label="问卷标题" align="center" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="描述" align="center" prop="description" :show-overflow-tooltip="true" />
      <!-- <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === '0'">草稿</el-tag>
          <el-tag type="success" v-else-if="scope.row.status === '1'">发布</el-tag>
          <el-tag type="danger" v-else>关闭</el-tag>
        </template>
</el-table-column> -->
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
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleDetail(scope.row)"
            v-hasPermi="['system:questionnaire:query']">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['system:questionnaire:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)"
            v-hasPermi="['system:questionnaire:remove']">删除</el-button>
          <el-button size="mini" type="text" icon="el-icon-tickets" @click="handleSubmissions(scope.row)"
            v-hasPermi="['system:questionnaire:query']">提交记录</el-button>
          <el-button size="mini" type="text" icon="el-icon-position" @click="handleUserSubmit(scope.row)"
            v-if="scope.row.status === '0'">用户填写</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
      @pagination="getList" />

    <!-- 添加或修改问卷对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="780px" append-to-body>
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
          <!-- <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择状态">
                <el-option label="草稿" value="0" />
                <el-option label="发布" value="1" />
                <el-option label="关闭" value="2" />
              </el-select>
            </el-form-item>
          </el-col> -->
          <el-col :span="12">
            <el-form-item label="允许重复">
              <el-radio-group v-model="form.allowRepeat">
                <el-radio label="0">否</el-radio>
                <el-radio label="1">是</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="问题列表">
              <el-button type="primary" size="mini" @click="addQuestion">添加问题</el-button>
              <draggable v-model="form.items" tag="ul" class="question-list">
                <li v-for="(question, index) in form.items" :key="index" class="question-item">
                  <el-card class="question-card">
                    <div slot="header" class="clearfix">
                      <span>问题 {{ index + 1 }}</span>
                      <el-button style="float: right; padding: 3px 0" type="text"
                        @click="removeQuestion(index)">删除</el-button>
                    </div>
                    <el-form-item label="问题类型" :prop="'items.' + index + '.questionType'">
                      <el-select v-model="question.questionType" placeholder="请选择问题类型"
                        @change="changeQuestionType(question)">
                        <el-option label="单选题" value="radio" />
                        <el-option label="多选题" value="checkbox" />
                        <el-option label="文本题" value="text" />
                      </el-select>
                    </el-form-item>
                    <el-form-item label="问题标题" :prop="'items.' + index + '.questionText'">
                      <el-input v-model="question.questionText" placeholder="请输入问题标题" />
                    </el-form-item>
                    <div v-if="question.questionType === 'radio' || question.questionType === 'checkbox'">
                      <el-form-item v-for="(option, optIndex) in question.options" :key="optIndex"
                        :label="'选项' + (optIndex + 1)"
                        :prop="'items.' + index + '.options.' + optIndex + '.optionText'">
                        <el-input v-model="option.optionText" placeholder="请输入选项内容" style="width: 80%" />
                        <el-button @click="removeOption(index, optIndex)" type="danger" size="mini"
                          icon="el-icon-delete" circle></el-button>
                      </el-form-item>
                      <el-button @click="addOption(index)" type="primary" size="mini">添加选项</el-button>
                    </div>
                  </el-card>
                </li>
              </draggable>
            </el-form-item>
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
        <el-table-column label="提交ID" prop="submissionId" width="80" />
        <el-table-column label="提交人" prop="userName" width="120" />
        <el-table-column label="提交时间" prop="createTime" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
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
      <el-descriptions :column="1" border>
        <el-descriptions-item v-for="(answer, index) in answers" :key="index" :label="answer.questionText">
          <span v-if="answer.questionType === 'text'">{{ answer.answerText }}</span>
          <span v-else>{{ formatAnswer(answer) }}</span>
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script>
import { addQuestionnaire, getQuestionnaire, listQuestionnaire, updateQuestionnaire, delQuestionnaire, listSubmissions, getSubmissionAnswers, listSubmission } from "@/api/system/questionnaire";
import draggable from 'vuedraggable'

export default {
  name: "Questionnaire",
  components: {
    draggable
  },
  data() {
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
        items: []
      },
      // 表单校验
      rules: {
        title: [
          { required: true, message: "问卷标题不能为空", trigger: "blur" }
        ],
        // status: [
        //   { required: true, message: "状态不能为空", trigger: "change" }
        // ],
        startTime: [
          { required: true, message: "开始时间不能为空", trigger: "change" }
        ],
        endTime: [
          { required: true, message: "结束时间不能为空", trigger: "change" }
        ]
      },
      // 提交记录数据
      submissions: [],
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
        this.submissions = response.rows;
        this.submissionsTotal = response.total;
      });
    },
    /** 查询回答详情 */
    getAnswers(submissionId) {
      getSubmissionAnswers(submissionId).then(response => {
        this.answers = response.data;
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
    /** 用户填写按钮操作 */
    handleUserSubmit(row) {
      this.$router.push({
        name: 'UserQuestionnaireSubmit',
        params: { metaId: row.metaId }
      });
    },
    /** 详情按钮操作 */
    handleDetail(row) {
      this.reset();
      getQuestionnaire(row.metaId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "问卷详情";
        // 禁用表单编辑
        this.$nextTick(() => {
          this.$refs.form.clearValidate();
          const form = this.$refs.form;
          for (let i = 0; i < form.fields.length; i++) {
            form.fields[i].$el.disabled = true;
          }
        });
      });
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
    // submitForm() {
    //   this.$refs["form"].validate(valid => {
    //     if (valid) {
    //       if (this.form.metaId != null) {
    //         updateQuestionnaire(this.form).then(response => {
    //           this.$modal.msgSuccess("修改成功");
    //           this.open = false;
    //           this.getList();
    //         });
    //       } else {
    //         addQuestionnaire(this.form).then(response => {
    //           this.$modal.msgSuccess("新增成功");
    //           this.open = false;
    //           this.getList();
    //         });
    //       }
    //     }
    //   });
    // },
    /** 提交按钮 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return;

        // 1. 深拷贝
        const postData = JSON.parse(JSON.stringify(this.form));

        // 2. 关键：把 items 转成后端字段
        postData.items = (postData.items || []).map((q, idx) => ({
          questionText: q.questionText,
          itemType: q.questionType,   // 就是这里缺
          orderNum: idx + 1,
          options: (q.options || []).map(opt => ({
            optionText: opt.optionText
          }))
        }));

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
        questionType: "radio",
        questionText: "",

        options: [
          { optionText: "" }
        ]
      });
    },
    /** 删除问题 */
    removeQuestion(index) {
      this.form.items.splice(index, 1);
    },
    /** 添加选项 */
    addOption(questionIndex) {
      this.form.items[questionIndex].options.push({ optionText: "" });
    },
    /** 删除选项 */
    removeOption(questionIndex, optionIndex) {
      this.form.items[questionIndex].options.splice(optionIndex, 1);
    },
    /** 改变问题类型 */
    changeQuestionType(question) {
      if (question.questionType === "radio" || question.questionType === "checkbox") {
        // 如果是选择题，确保有选项
        if (!question.options || question.options.length === 0) {
          this.$set(question, "options", [{ optionText: "" }]);
        }
      } else {
        // 如果是非选择题，删除选项
        this.$delete(question, "options");
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
</style>
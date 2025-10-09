<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>课程作业管理 - {{ courseName }}</span>
      </div>

      <!-- 作业操作 -->
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAdd">发布作业</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" icon="el-icon-delete" size="mini" :disabled="multiple"
            @click="handleDelete">删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="info" icon="el-icon-back" size="mini" @click="goBack">返回</el-button>
        </el-col>
      </el-row>

      <!-- 作业列表 -->
      <el-table :data="assignmentList" v-loading="loading" style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="assignmentId" label="作业ID" width="80" />
        <el-table-column prop="assignmentTitle" label="作业标题" />
        <el-table-column prop="assignmentDescribe" label="作业描述" />
        <el-table-column prop="startTime" label="开始时间" width="160">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.startTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="endTime" label="结束时间" width="160">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.endTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="deadline" label="截止时间" width="160">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.deadline) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="160">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleViewSubmissions(scope.row)">查看提交</el-button>
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
        @pagination="getList" />

    </el-card>

    <!-- 添加或修改作业对话框 -->
    <el-dialog :title="assignmentForm.title" :visible.sync="assignmentForm.open" width="600px" append-to-body>
      <el-form ref="assignmentForm" :model="assignmentForm.form" :rules="assignmentForm.rules" label-width="100px">
        <el-form-item label="作业标题" prop="assignmentTitle">
          <el-input v-model="assignmentForm.form.assignmentTitle" placeholder="请输入作业标题" />
        </el-form-item>
        <el-form-item label="作业描述" prop="assignmentDescribe">
          <el-input v-model="assignmentForm.form.assignmentDescribe" type="textarea" placeholder="请输入作业描述" />
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-date-picker
            v-model="assignmentForm.form.startTime"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择开始时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-date-picker
            v-model="assignmentForm.form.endTime"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择结束时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="截止时间" prop="deadline">
          <el-date-picker
            v-model="assignmentForm.form.deadline"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择截止时间">
          </el-date-picker>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAssignmentForm">确 定</el-button>
        <el-button @click="cancelAssignmentForm">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 作业提交情况对话框 -->
    <el-dialog title="作业提交情况" :visible.sync="submission.open" width="800px" append-to-body>
      <el-tabs v-model="submission.activeTab">
        <el-tab-pane label="已提交" name="submitted">
          <el-table :data="submission.submittedList" v-loading="submission.loading" style="width: 100%">
            <el-table-column prop="userName" label="学生姓名" width="120" />
            <el-table-column prop="submitTime" label="提交时间" width="160">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.submitTime) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="fileName" label="提交文件名" />
            <el-table-column prop="fileType" label="文件类型" width="100" />
            <el-table-column prop="fileSize" label="文件大小" width="120">
              <template slot-scope="scope">
                <span>{{ scope.row.fileSize }} 字节</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="100">
              <template slot-scope="scope">
                <el-button size="mini" type="text" @click="handleDownloadSubmission(scope.row)">下载</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="未提交" name="unsubmitted">
          <el-table :data="submission.unsubmittedList" v-loading="submission.loading" style="width: 100%">
            <el-table-column prop="userName" label="学生姓名" width="120" />
            <el-table-column prop="createTime" label="加入时间" width="160">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.createTime) }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
  </div>
</template>

<script>
import { listCourseAssignment, getCourseAssignment, addCourseAssignment, updateCourseAssignment, delCourseAssignment, getCourseAssignmentSubmissions } from "@/api/system/courseAssignment";
import { parseTime } from "@/utils";

export default {
  name: "AssignmentManage",
  props: {
    courseId: {
      type: Number,
      required: true
    },
    courseName: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      loading: false,
      assignmentList: [],
      total: 0,
      ids: [],
      single: true,
      multiple: true,
      assignmentForm: {
        title: "",
        open: false,
        form: {
          assignmentId: undefined,
          courseId: undefined,
          assignmentTitle: "",
          assignmentDescribe: "",
          startTime: "",
          endTime: "",
          deadline: ""
        },
        rules: {
          assignmentTitle: [
            { required: true, message: "作业标题不能为空", trigger: "blur" }
          ],
          assignmentDescribe: [
            { required: true, message: "作业描述不能为空", trigger: "blur" }
          ],
          startTime: [
            { required: true, message: "开始时间不能为空", trigger: "blur" }
          ],
          endTime: [
            { required: true, message: "结束时间不能为空", trigger: "blur" }
          ],
          deadline: [
            { required: true, message: "截止时间不能为空", trigger: "blur" }
          ]
        }
      },
      submission: {
        open: false,
        loading: false,
        activeTab: "submitted",
        submittedList: [],
        unsubmittedList: [],
        assignmentId: null
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        courseId: null
      }
    };
  },

  created() {
    // 设置查询参数中的课程ID
    this.queryParams.courseId = this.courseId;
    // 根据课程ID查询作业列表
    this.getList();
  },
  
  methods: {
    parseTime,
    
    goBack() {
      this.$emit('close');
    },

    /** 查询作业列表 */
    getList() {
      this.loading = true;
      // 确保传递课程ID参数，只获取指定课程的作业
      if (this.courseId) {
        this.queryParams.courseId = this.courseId;
      }

      listCourseAssignment(this.queryParams).then(res => {
        this.assignmentList = res.rows || [];
        this.total = res.total || 0;
        this.loading = false;
      }).catch(() => { 
        this.loading = false; 
        this.$message.error('获取作业列表失败');
      });
    },
    
    /** 发布作业 */
    handleAdd() {
      this.assignmentForm.open = true;
      this.assignmentForm.title = "发布作业";
      this.assignmentForm.form = {
        assignmentId: undefined,
        courseId: this.courseId,
        assignmentTitle: "",
        assignmentDescribe: "",
        startTime: "",
        endTime: "",
        deadline: ""
      };
    },

    /** 修改作业 */
    handleUpdate(row) {
      this.assignmentForm.open = true;
      this.assignmentForm.title = "修改作业";
      this.assignmentForm.form = {
        assignmentId: row.assignmentId,
        courseId: this.courseId,
        assignmentTitle: row.assignmentTitle,
        assignmentDescribe: row.assignmentDescribe,
        startTime: row.startTime,
        endTime: row.endTime,
        deadline: row.deadline
      };
    },
    
    /** 提交发布/修改表单 */
    submitAssignmentForm() {
      this.$refs["assignmentForm"].validate(valid => {
        if (valid) {
          // 如果是新增作业
          if (!this.assignmentForm.form.assignmentId) {
            // 检查课程ID是否存在
            if (!this.courseId) {
              this.$modal.msgError("缺少课程ID");
              return;
            }
            
            // 调用新增接口
            addCourseAssignment(this.assignmentForm.form).then(response => {
              this.$modal.msgSuccess("发布成功");
              this.assignmentForm.open = false;
              this.getList();
            }).catch(err => {
              this.$modal.msgError("发布失败: " + err.message);
            });
          } else {
            // 修改作业信息
            updateCourseAssignment(this.assignmentForm.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.assignmentForm.open = false;
              this.getList();
            }).catch(err => {
              this.$modal.msgError("修改失败: " + err.message);
            });
          }
        }
      });
    },
    
    /** 取消发布/修改表单 */
    cancelAssignmentForm() {
      this.assignmentForm.open = false;
      this.resetAssignmentForm();
    },
    
    /** 重置发布/修改表单 */
    resetAssignmentForm() {
      this.assignmentForm.form = {
        assignmentId: undefined,
        courseId: this.courseId,
        assignmentTitle: "",
        assignmentDescribe: "",
        startTime: "",
        endTime: "",
        deadline: ""
      };
      this.resetForm("assignmentForm");
    },
    
    /** 删除作业 */
    handleDelete(row) {
      const assignmentIds = row.assignmentId || this.ids;
      this.$modal.confirm('是否确认删除作业编号为"' + assignmentIds + '"的数据项？').then(function() {
        return delCourseAssignment(assignmentIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    
    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.assignmentId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    
    /** 查看作业提交情况 */
    handleViewSubmissions(row) {
      this.submission.open = true;
      this.submission.assignmentId = row.assignmentId;
      this.getSubmissionList(row.assignmentId);
    },
    
    /** 获取作业提交列表 */
    getSubmissionList(assignmentId) {
      this.submission.loading = true;
      getCourseAssignmentSubmissions(assignmentId).then(response => {
        this.submission.submittedList = response.data.submitted || [];
        this.submission.unsubmittedList = response.data.unsubmitted || [];
        this.submission.loading = false;
      }).catch(() => {
        this.submission.loading = false;
        this.$message.error('获取作业提交情况失败');
      });
    },
    
    /** 下载作业提交文件 */
    handleDownloadSubmission(row) {
      window.open(row.filePath, '_blank');
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
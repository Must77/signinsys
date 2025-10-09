<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>我的作业 - {{ courseName }}</span>
      </div>

      <el-tabs v-model="activeTab" @tab-click="handleTabClick">
        <!-- 待提交作业 -->
        <el-tab-pane label="待提交作业" name="pending">
          <el-table :data="pendingAssignments" v-loading="loading.pending" style="width: 100%">
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
            <el-table-column label="操作" width="120">
              <template slot-scope="scope">
                <el-button size="mini" type="primary" @click="handleSubmit(scope.row)">提交</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <!-- 已提交作业 -->
        <el-tab-pane label="已提交作业" name="submitted">
          <el-table :data="submittedAssignments" v-loading="loading.submitted" style="width: 100%">
            <el-table-column prop="assignmentId" label="作业ID" width="80" />
            <el-table-column prop="assignmentTitle" label="作业标题" />
            <el-table-column prop="assignmentDescribe" label="作业描述" />
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
                <el-button size="mini" type="text" @click="handleDownload(scope.row)">下载</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <!-- 提交作业对话框 -->
    <el-dialog title="提交作业" :visible.sync="submitForm.open" width="500px" append-to-body>
      <el-form ref="submitForm" :model="submitForm.form" :rules="submitForm.rules" label-width="80px">
        <el-form-item label="作业标题">{{ submitForm.form.assignmentTitle }}</el-form-item>
        <el-form-item label="作业描述">{{ submitForm.form.assignmentDescribe }}</el-form-item>
        <el-form-item label="作业文件" prop="file">
          <el-upload
            ref="upload"
            :limit="1"
            accept=".doc,.docx,.pdf,.xls,.xlsx,.ppt,.pptx,.zip,.rar"
            :auto-upload="false"
            :on-change="handleFileChange"
            :file-list="fileList"
          >
            <el-button slot="trigger" size="mini" type="primary">选取文件</el-button>
            <div slot="tip" class="el-upload__tip">只能上传doc/docx/pdf/xls/xlsx/ppt/pptx/zip/rar文件，且不超过100MB</div>
          </el-upload>
        </el-form-item>
        <el-form-item label="文件名" prop="fileName">
          <el-input v-model="submitForm.form.fileName" placeholder="请输入文件名（可选）" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAssignment">确 定</el-button>
        <el-button @click="cancelSubmit">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPendingAssignments, listMySubmissions, submitAssignment } from "@/api/system/courseAssignmentUser";
import { parseTime } from "@/utils";

export default {
  name: "AssignmentUser",
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
      activeTab: "pending",
      loading: {
        pending: false,
        submitted: false
      },
      pendingAssignments: [],
      submittedAssignments: [],
      submitForm: {
        open: false,
        form: {
          assignmentId: undefined,
          assignmentTitle: "",
          assignmentDescribe: "",
          file: null,
          fileName: ""
        },
        rules: {
          file: [
            { required: true, message: "请选择要上传的文件", trigger: "change" }
          ]
        }
      },
      fileList: [],
      currentAssignment: null
    };
  },

  created() {
    this.getPendingAssignments();
  },
  
  methods: {
    parseTime,
    
    /** 获取待提交作业 */
    getPendingAssignments() {
      this.loading.pending = true;
      listPendingAssignments(this.courseId).then(response => {
        this.pendingAssignments = response.data || [];
        this.loading.pending = false;
      }).catch(() => {
        this.loading.pending = false;
        this.$message.error('获取待提交作业失败');
      });
    },
    
    /** 获取已提交作业 */
    getSubmittedAssignments() {
      this.loading.submitted = true;
      listMySubmissions(this.courseId).then(response => {
        this.submittedAssignments = response.data || [];
        this.loading.submitted = false;
      }).catch(() => {
        this.loading.submitted = false;
        this.$message.error('获取已提交作业失败');
      });
    },
    
    /** 标签页切换 */
    handleTabClick(tab) {
      if (tab.name === "submitted") {
        this.getSubmittedAssignments();
      }
    },
    
    /** 提交作业 */
    handleSubmit(row) {
      this.submitForm.open = true;
      this.submitForm.form = {
        assignmentId: row.assignmentId,
        assignmentTitle: row.assignmentTitle,
        assignmentDescribe: row.assignmentDescribe,
        file: null,
        fileName: ""
      };
      this.currentAssignment = row;
    },
    
    /** 文件选择 */
    handleFileChange(file, fileList) {
      // 只保留最新文件
      if (fileList.length > 1) fileList.splice(0, 1);
      // 存文件对象
      this.submitForm.form.file = file.raw;
      // 自动填充文件名
      if (!this.submitForm.form.fileName || this.submitForm.form.fileName.trim() === '') {
        this.submitForm.form.fileName = file.name;
      }
    },
    
    /** 取消提交 */
    cancelSubmit() {
      this.submitForm.open = false;
      this.resetSubmitForm();
    },
    
    /** 重置提交表单 */
    resetSubmitForm() {
      this.submitForm.form = {
        assignmentId: undefined,
        assignmentTitle: "",
        assignmentDescribe: "",
        file: null,
        fileName: ""
      };
      this.fileList = [];
      this.currentAssignment = null;
      this.resetForm("submitForm");
    },
    
    /** 提交作业 */
    submitAssignment() {
      this.$refs["submitForm"].validate(valid => {
        if (valid) {
          // 检查是否有选择文件
          if (!this.submitForm.form.file) {
            this.$modal.msgError("请先选择要上传的文件");
            return;
          }
          
          // 验证文件大小（最大100MB）
          if (this.submitForm.form.file.size > 100 * 1024 * 1024) {
            this.$modal.msgError("文件大小超过限制，请上传小于100MB的文件");
            return;
          }
          
          // 创建FormData对象
          const formData = new FormData();
          formData.append("file", this.submitForm.form.file);
          formData.append("assignmentId", this.submitForm.form.assignmentId);
          formData.append("fileName", this.submitForm.form.fileName);
          
          // 调用提交接口
          submitAssignment(formData).then(response => {
            this.$modal.msgSuccess("提交成功");
            this.submitForm.open = false;
            this.getPendingAssignments();
            this.getSubmittedAssignments();
          }).catch(err => {
            this.$modal.msgError("提交失败: " + err.message);
          });
        }
      });
    },
    
    /** 下载作业提交文件 */
    handleDownload(row) {
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
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
            <el-table-column prop="courseName" label="课程名称" />
            <el-table-column prop="createTime" label="创建时间" width="160">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.createTime) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="updateTime" label="更新时间" width="160">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.updateTime) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120">
              <template slot-scope="scope">
                <el-button size="mini" type="primary" @click="handleSubmit(scope.row)" v-hasPermi="['system:myCourse:assignment:submit']">提交</el-button>
              </template>
            </el-table-column>
          </el-table>

          <!-- 添加空状态提示 -->
          <div v-if="pendingAssignments.length === 0 && !loading.pending" class="empty-state">
            <el-empty description="暂无待提交的作业"></el-empty>
          </div>
        </el-tab-pane>

        <!-- 已提交作业 -->
        <!-- <el-tab-pane label="已提交作业" name="submitted">
          <el-table :data="submittedAssignments" v-loading="loading.submitted" style="width: 100%">
            <el-table-column prop="assignmentId" label="作业ID" width="80" />
            <el-table-column prop="assignmentTitle" label="作业标题" />
            <el-table-column prop="courseName" label="课程名称" />
            <el-table-column prop="createTime" label="创建时间" width="160">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.createTime) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="updateTime" label="更新时间" width="160">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.updateTime) }}</span>
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

         
          <div v-if="submittedAssignments.length === 0 && !loading.submitted" class="empty-state">
            <el-empty description="暂无已提交的作业"></el-empty>
          </div>
        </el-tab-pane> -->
      </el-tabs>
    </el-card>

    <!-- 提交作业对话框 -->
    <el-dialog title="提交作业" :visible.sync="submitForm.open" width="500px" append-to-body>
      <el-form ref="submitFormRef" :model="submitForm.form" :rules="submitForm.rules" label-width="80px">
        <el-form-item label="作业标题">
          <span>{{ currentAssignment ? currentAssignment.assignmentTitle : '' }}</span>
        </el-form-item>
        <el-form-item label="课程名称">
          <span>{{ courseName }}</span>
        </el-form-item>
        <el-form-item label="作业文件" prop="file">
          <el-upload ref="upload" :limit="1" accept=".doc,.docx,.pdf,.xls,.xlsx,.ppt,.pptx,.zip,.rar"
            :auto-upload="false" :on-change="handleFileChange" :on-remove="handleFileRemove" :file-list="fileList">
            <el-button slot="trigger" size="mini" type="primary">选取文件</el-button>
            <div slot="tip" class="el-upload__tip">只能上传doc/docx/pdf/xls/xlsx/ppt/pptx/zip/rar文件，且不超过100MB</div>
          </el-upload>
        </el-form-item>
        <el-form-item label="文件名" prop="fileName">
          <el-input v-model="submitForm.form.fileName" placeholder="请输入文件名（可选）" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAssignment" :loading="submitForm.loading">确 定</el-button>
        <el-button @click="cancelSubmit">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPendingAssignments, listMySubmissions, submitAssignment, uploadAssignmentFile } from "@/api/system/courseAssignmentUser";
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
        loading: false,
        form: {
          assignmentId: undefined,
          assignmentTitle: "",
          fileName: "",
          filePath: ""
        },
        rules: {
          file: [
            { required: true, message: "请选择要上传的文件", trigger: "change" }
          ]
        }
      },
      fileList: [],
      currentAssignment: null,
      selectedFile: null
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
        console.log('【待提交作业原始响应】', JSON.stringify(response, null, 2));
        this.pendingAssignments = response.rows || [];
        this.loading.pending = false;
      }).catch(() => {
        this.loading.pending = false;
        this.$message.error('获取待提交作业失败');
      });
    },

    /** 获取已提交作业 */
    getSubmittedAssignments() {
      this.loading.submitted = true;
      
      // 收集所有作业ID
      const assignmentIds = this.pendingAssignments.map(item => item.assignmentId);
      
      // 如果没有作业，直接返回空数组
      if (assignmentIds.length === 0) {
        this.submittedAssignments = [];
        this.loading.submitted = false;
        return;
      }
      
      // 并行请求所有作业的提交情况
      const promises = assignmentIds.map(id => listMySubmissions(id));
      
      Promise.all(promises)
        .then(responses => {
          // 合并所有已提交的作业
          let allSubmissions = [];
          responses.forEach((response, index) => {
            // 后端接口返回的是一个对象数组，不是分页数据，也不是单个对象
            if (response.data) {
              // response.data 应该是一个数组
              if (Array.isArray(response.data)) {
                response.data.forEach(item => {
                  // 添加作业标题等信息
                  const assignment = this.pendingAssignments.find(a => a.assignmentId === assignmentIds[index]);
                  if (assignment) {
                    item.assignmentTitle = assignment.assignmentTitle;
                    item.courseName = assignment.courseName;
                  }
                  // 只添加已提交的作业（有文件名的）
                  if (item.fileName && item.fileName !== '') {
                    allSubmissions.push(item);
                  }
                });
              }
            }
          });
          
          this.submittedAssignments = allSubmissions;
          this.loading.submitted = false;
        })
        .catch(error => {
          console.error('获取已提交作业失败:', error);
          this.submittedAssignments = [];
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
      console.log('准备提交作业:', row);
      this.submitForm.open = true;
      this.submitForm.form = {
        assignmentId: row.assignmentId,
        assignmentTitle: row.assignmentTitle,
        fileName: "",
        filePath: ""
      };
      this.currentAssignment = {
        ...row,              // ✅ 把整行数据都存下来
        submissionId: row.submissionId // ✅ 关键字段
      };
      this.selectedFile = null;
      this.fileList = [];
    },

    /** 文件选择 */
    handleFileChange(file, fileList) {
      console.log('文件选择:', file, fileList);
      // 只保留最新文件
      if (fileList.length > 1) {
        fileList.splice(0, 1);
      }
      // 存文件对象
      this.selectedFile = file.raw;
      // 自动填充文件名
      if (!this.submitForm.form.fileName || this.submitForm.form.fileName.trim() === '') {
        this.submitForm.form.fileName = file.name;
      }
    },

    /** 文件移除 */
    handleFileRemove(file, fileList) {
      console.log('文件移除:', file, fileList);
      this.selectedFile = null;
      this.fileList = [];
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
        fileName: "",
        filePath: ""
      };
      this.fileList = [];
      this.currentAssignment = null;
      this.selectedFile = null;
      if (this.$refs.submitFormRef) {
        this.$refs.submitFormRef.resetFields();
      }
      if (this.$refs.upload) {
        this.$refs.upload.clearFiles();
      }
    },

    /** 提交作业 */
    /** 提交作业 */
    async submitAssignment() {
      try {
        // 检查是否有选择文件
        if (!this.selectedFile) {
          this.$message.error("请先选择要上传的文件");
          return;
        }

        // 验证文件大小（最大100MB）
        if (this.selectedFile.size > 100 * 1024 * 1024) {
          this.$message.error("文件大小超过限制，请上传小于100MB的文件");
          return;
        }

        this.submitForm.loading = true;

        // 第一步：上传文件
        const fileFormData = new FormData();
        fileFormData.append("file", this.selectedFile);

        console.log('开始上传文件...');
        const uploadResponse = await uploadAssignmentFile(fileFormData);
        console.log('文件上传响应:', uploadResponse);

        if (uploadResponse.code !== 200) {
          throw new Error(uploadResponse.msg || '文件上传失败');
        }

        // 获取文件路径 - 根据实际API响应调整
        const filePath = uploadResponse.fileName || uploadResponse.url || uploadResponse.data?.url;
        const fileName = this.submitForm.form.fileName || this.selectedFile.name;

        // 第二步：提交作业信息
        const submitData = {
          submissionId: this.currentAssignment.submissionId, // ✅ 动态获取

          //assignmentId: this.submitForm.form.assignmentId,
          //courseId: this.courseId,
          fileName: fileName,
          filePath: filePath,
          fileType: this.selectedFile.type,
          fileSize: this.selectedFile.size
        };

        console.log('提交作业数据:', submitData);

        // 添加更详细的调试信息
        console.log('准备调用 submitAssignment API，参数:', JSON.stringify(submitData, null, 2));

        const submitResponse = await submitAssignment(submitData);
        console.log('【后端实际返回】', submitResponse);

        if (submitResponse.code !== 200) {
          throw new Error(submitResponse.msg || '作业提交失败');
        }

        this.$message.success("提交成功");
        this.submitForm.open = false;
        this.resetSubmitForm();
        this.getPendingAssignments();

        // ✅ 无论当前在哪个标签页，都刷新已提交列表
        this.getSubmittedAssignments();
      } catch (err) {
        console.error('提交异常', err);          // ✅ 只打印原始错误
        const msg = err?.message || '未知错误';
        this.$message.error('提交失败: ' + msg);
      }
      finally {
        this.submitForm.loading = false;
      }
    },

    /** 下载作业提交文件 */
    handleDownload(row) {
      if (row.filePath) {
        // 如果filePath是相对路径，可能需要拼接完整的URL
        const fullUrl = row.filePath.startsWith('http') ? row.filePath :
          `http://117.72.126.104:8080${row.filePath}`;
        window.open(fullUrl, '_blank');
      } else {
        this.$message.warning('该作业没有上传文件');
      }
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.empty-state {
  text-align: center;
  padding: 40px 0;
}
</style>
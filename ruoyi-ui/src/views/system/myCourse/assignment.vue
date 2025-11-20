<template>
  <div class="assignment-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">我的作业</h1>
        <p class="course-name">{{ courseName }}</p>
      </div>
      <div class="header-stats">
        <div class="stat-item">
          <div class="stat-number">{{ pendingAssignments.length }}</div>
          <div class="stat-label">待提交</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">{{ submittedAssignments.length }}</div>
          <div class="stat-label">已提交</div>
        </div>
      </div>
    </div>

    <el-card class="main-card">
      <!-- 卡片头部 -->
      <div slot="header" class="card-header">
        <div class="header-left">
          <span class="header-title">作业管理</span>
          <el-button 
            icon="el-icon-refresh" 
            size="mini" 
            @click="getPendingAssignments"
            :loading="loading.pending"
            class="refresh-btn"
          >
            刷新
          </el-button>
        </div>
        <div class="header-actions" v-if="!isMobile">
          <el-button 
            type="text" 
            icon="el-icon-document"
            :class="{ active: activeTab === 'pending' }"
            @click="activeTab = 'pending'"
          >
            待提交作业
          </el-button>
          <!-- <el-button 
            type="text" 
            icon="el-icon-check"
            :class="{ active: activeTab === 'submitted' }"
            @click="handleTabClick({ name: 'submitted' })"
          >
            已提交作业
          </el-button> -->
        </div>
      </div>

      <!-- 移动端标签页 -->
      <div class="mobile-tabs" v-if="isMobile">
        <div 
          class="mobile-tab"
          :class="{ active: activeTab === 'pending' }"
          @click="activeTab = 'pending'"
        >
          <i class="el-icon-document"></i>
          <span>待提交</span>
          <span class="tab-badge" v-if="pendingAssignments.length > 0">
            {{ pendingAssignments.length }}
          </span>
        </div>
        <!-- <div 
          class="mobile-tab"
          :class="{ active: activeTab === 'submitted' }"
          @click="handleTabClick({ name: 'submitted' })"
        >
          <i class="el-icon-check"></i>
          <span>已提交</span>
          <span class="tab-badge" v-if="submittedAssignments.length > 0">
            {{ submittedAssignments.length }}
          </span>
        </div> -->
      </div>

      <!-- 待提交作业 -->
      <div v-show="activeTab === 'pending'" class="tab-content">
        <!-- 网页版表格 -->
        <div class="desktop-view" v-if="!isMobile">
          <el-table 
            :data="pendingAssignments" 
            v-loading="loading.pending" 
            class="assignment-table"
            empty-text="暂无待提交的作业"
          >
            <el-table-column label="作业信息" min-width="200">
              <template slot-scope="scope">
                <div class="assignment-info">
                  <div class="assignment-title">{{ scope.row.assignmentTitle }}</div>
                  <div class="assignment-meta">
                    <span class="assignment-id">ID: {{ scope.row.assignmentId }}</span>
                    <span class="update-time">{{ scope.row.updateTime }}</span>
                  </div>
                </div>
              </template>
            </el-table-column>
            <!-- <el-table-column label="作业描述" min-width="200">
              <template slot-scope="scope">
                <div class="assignment-description">{{ scope.row.assignmentDescribe }}</div>
              </template> -->
            <!-- </el-table-column> -->
            <el-table-column label="创建时间" width="200">
              <template slot-scope="scope">
                <div class="time-cell">
                  <i class="el-icon-time"></i>
                  <span>{{ scope.row.createTime}}</span>
                </div>
              </template>
            </el-table-column>
            
            <el-table-column label="操作" width="120" align="center">
              <template slot-scope="scope">
                <el-button 
                  size="mini" 
                  type="primary" 
                  @click="handleSubmit(scope.row)"
                  class="submit-btn"
                >
                  <i class="el-icon-upload2"></i>
                  提交
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 移动端卡片列表 -->
        <div class="mobile-view" v-else>
          <div class="assignment-cards">
            <div 
              v-for="assignment in pendingAssignments" 
              :key="assignment.assignmentId"
              class="assignment-card"
            >
              <div class="card-main">
                <div class="assignment-icon">
                  <i class="el-icon-document"></i>
                </div>
                <div class="assignment-details">
                  <div class="assignment-title-mobile">{{ assignment.assignmentTitle }}</div>
                  <div class="assignment-meta-mobile">
                    <div class="meta-item">
                      <i class="el-icon-time"></i>
                      <span>创建: {{ parseTime(assignment.createTime) }}</span>
                    </div>
                    <div class="meta-item">
                      <i class="el-icon-refresh"></i>
                      <span>更新: {{ parseTime(assignment.updateTime) }}</span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="card-actions">
                <el-button 
                  size="small" 
                  type="primary" 
                  @click="handleSubmit(assignment)"
                  class="mobile-submit-btn"
                >
                  <i class="el-icon-upload2"></i>
                  提交作业
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-if="pendingAssignments.length === 0 && !loading.pending" class="empty-state">
          <el-empty description="暂无待提交的作业" image-size="120">
            <el-button type="primary" @click="getPendingAssignments">刷新</el-button>
          </el-empty>
        </div>
      </div>

      <!-- 已提交作业 -->
      <!-- <div v-show="activeTab === 'submitted'" class="tab-content">
        <div class="desktop-view" v-if="!isMobile">
          <el-table 
            :data="submittedAssignments" 
            v-loading="loading.submitted" 
            class="assignment-table"
            empty-text="暂无已提交的作业"
          >
            <el-table-column label="作业信息" min-width="200">
              <template slot-scope="scope">
                <div class="assignment-info">
                  <div class="assignment-title">{{ scope.row.assignmentTitle }}</div>
                  <div class="file-info">
                    <i class="el-icon-document"></i>
                    <span class="file-name">{{ scope.row.fileName }}</span>
                  </div>
                </div>
              </template>
            </el-table-column>
            
            <el-table-column label="文件信息" width="150">
              <template slot-scope="scope">
                <div class="file-meta">
                  <span class="file-type">{{ scope.row.fileType }}</span>
                  <span class="file-size">{{ scope.row.fileSize }} 字节</span>
                </div>
              </template>
            </el-table-column>
            
            <el-table-column label="提交时间" width="160">
              <template slot-scope="scope">
                <div class="time-cell">
                  <i class="el-icon-time"></i>
                  <span>{{ parseTime(scope.row.createTime) }}</span>
                </div>
              </template>
            </el-table-column>
            
            <el-table-column label="操作" width="100" align="center">
              <template slot-scope="scope">
                <el-button 
                  size="mini" 
                  type="text" 
                  @click="handleDownload(scope.row)"
                  class="download-btn"
                >
                  <i class="el-icon-download"></i>
                  下载
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <div class="mobile-view" v-else>
          <div class="assignment-cards">
            <div 
              v-for="assignment in submittedAssignments" 
              :key="assignment.assignmentId"
              class="assignment-card submitted"
            >
              <div class="card-main">
                <div class="assignment-icon submitted">
                  <i class="el-icon-check"></i>
                </div>
                <div class="assignment-details">
                  <div class="assignment-title-mobile">{{ assignment.assignmentTitle }}</div>
                  <div class="file-info-mobile">
                    <i class="el-icon-document"></i>
                    <span class="file-name">{{ assignment.fileName }}</span>
                  </div>
                  <div class="assignment-meta-mobile">
                    <div class="meta-item">
                      <i class="el-icon-time"></i>
                      <span>{{ parseTime(assignment.createTime) }}</span>
                    </div>
                    <div class="meta-item">
                      <span class="file-size">{{ assignment.fileSize }} 字节</span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="card-actions">
                <el-button 
                  size="small" 
                  type="text" 
                  @click="handleDownload(assignment)"
                  class="mobile-download-btn"
                >
                  <i class="el-icon-download"></i>
                  下载
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <div v-if="submittedAssignments.length === 0 && !loading.submitted" class="empty-state">
          <el-empty description="暂无已提交的作业" image-size="120">
            <el-button type="primary" @click="getSubmittedAssignments">刷新</el-button>
          </el-empty>
        </div>
      </div> -->
    </el-card>

    <!-- 提交作业对话框 -->
    <el-dialog 
      :title="`提交作业 - ${currentAssignment ? currentAssignment.assignmentTitle : ''}`" 
      :visible.sync="submitForm.open" 
      :width="isMobile ? '95%' : '500px'"
      append-to-body
      class="submit-dialog"
    >
      <el-form 
        ref="submitFormRef" 
        :model="submitForm.form" 
        :rules="submitForm.rules" 
        label-width="80px"
        class="submit-form"
      >
        <el-form-item label="作业标题">
          <div class="form-value">{{ currentAssignment ? currentAssignment.assignmentTitle : '' }}</div>
        </el-form-item>
        <el-form-item label="课程名称">
          <div class="form-value">{{ courseName }}</div>
        </el-form-item>
        <el-form-item label="作业文件" prop="file" class="file-upload-item">
          <el-upload 
            ref="upload" 
            :limit="1" 
            accept=".doc,.docx,.pdf,.xls,.xlsx,.ppt,.pptx,.zip,.rar"
            :auto-upload="false" 
            :on-change="handleFileChange" 
            :on-remove="handleFileRemove" 
            :file-list="fileList"
            class="file-upload"
          >
            <el-button slot="trigger" size="small" type="primary" icon="el-icon-folder-opened">
              选择文件
            </el-button>
            <div slot="tip" class="el-upload__tip">
              支持格式: doc/docx/pdf/xls/xlsx/ppt/pptx/zip/rar，最大100MB
            </div>
          </el-upload>
        </el-form-item>
        <el-form-item label="文件名" prop="fileName">
          <el-input 
            v-model="submitForm.form.fileName" 
            placeholder="请输入文件名（可选，默认使用上传文件名）" 
            size="small"
          />
        </el-form-item>
      </el-form>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancelSubmit" :disabled="submitForm.loading">取消</el-button>
        <el-button 
          type="primary" 
          @click="submitAssignment" 
          :loading="submitForm.loading"
          class="confirm-submit-btn"
        >
          {{ submitForm.loading ? '提交中...' : '确认提交' }}
        </el-button>
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

  computed: {
    isMobile() {
      return window.innerWidth <= 768;
    }
  },

  created() {
    window.addEventListener('resize', this.handleResize);
  },

  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize);
  },

  watch: {
    courseId: {
      handler(newVal) {
        if (newVal) {
          this.getPendingAssignments();
        }
      },
      immediate: true
    }
  },

  methods: {
    handleResize() {
      this.$forceUpdate();
    },

    parseTime,

    /** 获取待提交作业 */
    getPendingAssignments() {
      this.loading.pending = true;
      console.log('正在获取课程ID为', this.courseId, '的待提交作业');
      listPendingAssignments(this.courseId).then(response => {
        console.log('【待提交作业原始响应】', JSON.stringify(response, null, 2));
        // 添加额外的过滤，确保只显示当前课程的作业
        const allAssignments = response.rows || [];
        this.pendingAssignments = allAssignments.filter(assignment => 
          assignment.courseId === this.courseId
        );
        console.log('过滤后的作业数量:', this.pendingAssignments.length);
        this.loading.pending = false;
      }).catch((error) => {
        console.error('获取待提交作业失败:', error);
        this.loading.pending = false;
        this.$message.error('获取待提交作业失败');
      });
    },

    /** 获取已提交作业 */
    getSubmittedAssignments() {
      this.loading.submitted = true;
      
      const assignmentIds = this.pendingAssignments.map(item => item.assignmentId);
      
      if (assignmentIds.length === 0) {
        this.submittedAssignments = [];
        this.loading.submitted = false;
        return;
      }
      
      const promises = assignmentIds.map(id => listMySubmissions(id));
      
      Promise.all(promises)
        .then(responses => {
          let allSubmissions = [];
          responses.forEach((response, index) => {
            if (response.data) {
              if (Array.isArray(response.data)) {
                response.data.forEach(item => {
                  const assignment = this.pendingAssignments.find(a => a.assignmentId === assignmentIds[index]);
                  if (assignment) {
                    item.assignmentTitle = assignment.assignmentTitle;
                    item.courseName = assignment.courseName;
                  }
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
        ...row,
        submissionId: row.submissionId
      };
      this.selectedFile = null;
      this.fileList = [];
    },

    /** 文件选择 */
    handleFileChange(file, fileList) {
      console.log('文件选择:', file, fileList);
      if (fileList.length > 1) {
        fileList.splice(0, 1);
      }
      this.selectedFile = file.raw;
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
    async submitAssignment() {
      try {
        if (!this.selectedFile) {
          this.$message.error("请先选择要上传的文件");
          return;
        }

        if (this.selectedFile.size > 100 * 1024 * 1024) {
          this.$message.error("文件大小超过限制，请上传小于100MB的文件");
          return;
        }

        this.submitForm.loading = true;

        const fileFormData = new FormData();
        fileFormData.append("file", this.selectedFile);

        console.log('开始上传文件...');
        const uploadResponse = await uploadAssignmentFile(fileFormData);
        console.log('文件上传响应:', uploadResponse);

        if (uploadResponse.code !== 200) {
          throw new Error(uploadResponse.msg || '文件上传失败');
        }

        const filePath = uploadResponse.fileName || uploadResponse.url || uploadResponse.data?.url;
        const fileName = this.submitForm.form.fileName || this.selectedFile.name;

        const submitData = {
          submissionId: this.currentAssignment.submissionId,
          fileName: fileName,
          filePath: filePath,
          fileType: this.selectedFile.type,
          fileSize: this.selectedFile.size
        };

        console.log('提交作业数据:', submitData);
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
        this.getSubmittedAssignments();
      } catch (err) {
        console.error('提交异常', err);
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

<style lang="scss" scoped>
.assignment-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);
}

/* 页面头部 */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 24px;
  padding: 0 8px;
  
  .header-content {
    .page-title {
      font-size: 28px;
      font-weight: 700;
      color: #303133;
      margin: 0 0 8px 0;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    .course-name {
      font-size: 16px;
      color: #909399;
      margin: 0;
      font-weight: 500;
    }
  }
  
  .header-stats {
    display: flex;
    gap: 24px;
    
    .stat-item {
      text-align: center;
      
      .stat-number {
        font-size: 32px;
        font-weight: 700;
        color: #409eff;
        line-height: 1;
      }
      
      .stat-label {
        font-size: 14px;
        color: #909399;
        margin-top: 4px;
      }
    }
  }
}

/* 主卡片 */
.main-card {
  border-radius: 12px;
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

/* 卡片头部 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  
  .header-left {
    display: flex;
    align-items: center;
    gap: 12px;
    
    .header-title {
      font-size: 18px;
      font-weight: 600;
      color: #303133;
    }
    
    .refresh-btn {
      border: none;
      color: #409eff;
    }
  }
  
  .header-actions {
    .el-button {
      color: #606266;
      font-weight: 500;
      
      &.active {
        color: #409eff;
        background: #ecf5ff;
      }
    }
  }
}

/* 移动端标签页 */
.mobile-tabs {
  display: flex;
  background: #f8f9fa;
  border-radius: 8px;
  padding: 4px;
  margin-bottom: 20px;
  
  .mobile-tab {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    padding: 10px;
    border-radius: 6px;
    font-size: 14px;
    color: #606266;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    
    &.active {
      background: white;
      color: #409eff;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    
    .tab-badge {
      background: #f56c6c;
      color: white;
      border-radius: 10px;
      padding: 2px 6px;
      font-size: 12px;
      min-width: 18px;
      text-align: center;
    }
  }
}

/* 标签内容 */
.tab-content {
  min-height: 400px;
}

/* 网页版表格 */
.desktop-view {
  .assignment-table {
    ::v-deep .el-table__row {
      transition: all 0.3s ease;
      
      &:hover {
        background: #f8f9fa;
      }
    }
    
    .assignment-info {
      .assignment-title {
        font-size: 14px;
        font-weight: 500;
        color: #303133;
        margin-bottom: 4px;
      }
      
      .assignment-meta {
        display: flex;
        gap: 12px;
        font-size: 12px;
        color: #909399;
      }
    }
    
    .time-cell {
      display: flex;
      align-items: center;
      gap: 6px;
      color: #606266;
    }
    
    .submit-btn {
      border-radius: 6px;
      font-weight: 500;
    }
    
    .download-btn {
      color: #409eff;
      
      &:hover {
        color: #67c23a;
      }
    }
  }
}

/* 移动端卡片 */
.mobile-view {
  .assignment-cards {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }
  
  .assignment-card {
    background: white;
    border-radius: 12px;
    padding: 16px;
    border: 1px solid #f0f0f0;
    transition: all 0.3s ease;
    
    &:hover {
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    
    &.submitted {
      border-left: 4px solid #67c23a;
    }
    
    .card-main {
      display: flex;
      align-items: flex-start;
      gap: 12px;
      margin-bottom: 12px;
      
      .assignment-icon {
        width: 40px;
        height: 40px;
        border-radius: 8px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        
        &.submitted {
          background: linear-gradient(135deg, #67c23a 0%, #85ce61 100%);
        }
        
        i {
          font-size: 20px;
          color: white;
        }
      }
      
      .assignment-details {
        flex: 1;
        
        .assignment-title-mobile {
          font-size: 16px;
          font-weight: 500;
          color: #303133;
          margin-bottom: 8px;
          line-height: 1.3;
        }
        
        .file-info-mobile {
          display: flex;
          align-items: center;
          gap: 6px;
          font-size: 14px;
          color: #606266;
          margin-bottom: 6px;
        }
        
        .assignment-meta-mobile {
          .meta-item {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            color: #909399;
            margin-bottom: 2px;
          }
        }
      }
    }
    
    .card-actions {
      display: flex;
      justify-content: flex-end;
      
      .mobile-submit-btn {
        border-radius: 6px;
        font-weight: 500;
      }
      
      .mobile-download-btn {
        color: #409eff;
      }
    }
  }
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 60px 20px;
}

/* 提交对话框 */
.submit-dialog {
  ::v-deep .el-dialog {
    border-radius: 12px;
    
    &__header {
      border-bottom: 1px solid #e4e7ed;
    }
  }
  
  .submit-form {
    .form-value {
      padding: 8px 0;
      color: #303133;
      font-weight: 500;
    }
    
    .file-upload-item {
      ::v-deep .el-upload {
        display: block;
      }
      
      ::v-deep .el-upload-dragger {
        width: 100%;
      }
    }
  }
  
  .dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    
    .confirm-submit-btn {
      border-radius: 6px;
      font-weight: 500;
    }
  }
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .assignment-container {
    padding: 12px;
  }
  
  .page-header {
    flex-direction: column;
    align-items: stretch;
    gap: 16px;
    
    .header-stats {
      justify-content: space-around;
    }
  }
  
  .desktop-view {
    display: none;
  }
}

@media screen and (min-width: 769px) {
  .mobile-view {
    display: none;
  }
  
  .mobile-tabs {
    display: none;
  }
}
</style>
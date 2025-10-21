<template>
  <div class="resource-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-main">
        <div class="back-section">
          <el-button 
            icon="el-icon-arrow-left" 
            type="text" 
            @click="goBack"
            class="back-btn"
          >
            返回
          </el-button>
        </div>
        <div class="title-section">
          <h1 class="page-title">课程资源</h1>
          <p class="course-name">{{ courseName }}</p>
        </div>
        <div class="stats-section">
          <div class="stat-item">
            <div class="stat-number">{{ resourceList.length }}</div>
            <div class="stat-label">资源数量</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">{{ totalSize }}</div>
            <div class="stat-label">总大小</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 操作工具栏 -->
    <div class="toolbar-section">
      <el-card shadow="never" class="toolbar-card">
        <div class="toolbar-content">
          <div class="search-filter">
            <el-input
              v-model="searchText"
              placeholder="搜索资源文件..."
              prefix-icon="el-icon-search"
              clearable
              size="small"
              @input="handleSearch"
              class="search-input"
            />
            <el-select 
              v-model="filterType" 
              placeholder="文件类型" 
              clearable 
              size="small"
              @change="handleFilter"
              class="type-filter"
            >
              <el-option label="文档" value="document" />
              <el-option label="图片" value="image" />
              <el-option label="视频" value="video" />
              <el-option label="压缩包" value="archive" />
              <el-option label="其他" value="other" />
            </el-select>
          </div>
          <div class="toolbar-actions">
            <el-button 
              type="primary" 
              icon="el-icon-download" 
              size="small"
              @click="downloadAllResources"
              :disabled="resourceList.length === 0"
              class="download-all-btn"
            >
              下载全部
            </el-button>
            <el-button 
              icon="el-icon-refresh" 
              size="small"
              @click="getList"
              :loading="loading"
            >
              刷新
            </el-button>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 资源列表 -->
    <div class="resource-list-section">
      <el-card shadow="never" class="resource-card">
        <template #header>
          <div class="card-header">
            <span class="header-title">资源列表</span>
            <span class="header-count">共 {{ filteredResources.length }} 个资源</span>
          </div>
        </template>

        <!-- 网页版表格 -->
        <div class="desktop-view" v-if="!isMobile">
          <el-table 
            :data="filteredResources" 
            v-loading="loading" 
            style="width: 100%"
            class="resource-table"
            empty-text="暂无资源"
          >
            <el-table-column label="文件信息" min-width="300">
              <template slot-scope="scope">
                <div class="file-info">
                  <div class="file-icon" :class="getFileTypeClass(scope.row.fileType)">
                    <i :class="getFileIcon(scope.row.fileType)"></i>
                  </div>
                  <div class="file-details">
                    <div class="file-name">{{ scope.row.fileName }}</div>
                    <div class="file-meta">
                      <span class="file-type">{{ getFileTypeText(scope.row.fileType) }}</span>
                      <span class="file-size">{{ formatFileSize(scope.row.fileSize) }}</span>
                      <span class="file-time">{{ parseTime(scope.row.createTime) }}</span>
                    </div>
                  </div>
                </div>
              </template>
            </el-table-column>
            
            <el-table-column prop="resourceId" label="资源ID" width="100" align="center" />
            
            <el-table-column label="操作" width="150" align="center">
              <template slot-scope="scope">
                <div class="action-buttons">
                  <el-tooltip content="下载" placement="top">
                    <el-button 
                      type="primary" 
                      icon="el-icon-download" 
                      size="mini"
                      circle
                      @click="handleDownload(scope.row)"
                      class="download-btn"
                    />
                  </el-tooltip>
                  <el-tooltip content="预览" placement="top">
                    <el-button 
                      type="success" 
                      icon="el-icon-view" 
                      size="mini"
                      circle
                      @click="handlePreview(scope.row)"
                      class="preview-btn"
                    />
                  </el-tooltip>
                  <el-tooltip content="详细信息" placement="top">
                    <el-button 
                      type="info" 
                      icon="el-icon-info" 
                      size="mini"
                      circle
                      @click="showFileInfo(scope.row)"
                      class="info-btn"
                    />
                  </el-tooltip>
                </div>
              </template>
            </el-table-column>
          </el-table>
        </div>

        <!-- 移动端卡片列表 -->
        <div class="mobile-view" v-else>
          <div class="resource-cards">
            <div 
              v-for="resource in filteredResources" 
              :key="resource.resourceId"
              class="resource-card-mobile"
            >
              <div class="card-main">
                <div class="file-icon-mobile" :class="getFileTypeClass(resource.fileType)">
                  <i :class="getFileIcon(resource.fileType)"></i>
                </div>
                <div class="file-info-mobile">
                  <div class="file-name-mobile">{{ resource.fileName }}</div>
                  <div class="file-meta-mobile">
                    <span class="file-type">{{ getFileTypeText(resource.fileType) }}</span>
                    <span class="file-size">{{ formatFileSize(resource.fileSize) }}</span>
                  </div>
                  <div class="file-time-mobile">
                    {{ parseTime(resource.createTime) }}
                  </div>
                </div>
              </div>
              <div class="card-actions">
                <el-button 
                  type="text" 
                  icon="el-icon-download" 
                  size="mini"
                  @click="handleDownload(resource)"
                  class="mobile-download-btn"
                >
                  下载
                </el-button>
                <el-button 
                  type="text" 
                  icon="el-icon-view" 
                  size="mini"
                  @click="handlePreview(resource)"
                  class="mobile-preview-btn"
                >
                  预览
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-if="filteredResources.length === 0 && !loading" class="empty-state">
          <el-empty description="暂无资源文件" image-size="120">
            <el-button type="primary" @click="getList">刷新</el-button>
          </el-empty>
        </div>
      </el-card>
    </div>

    <!-- 文件信息对话框 -->
    <el-dialog 
      title="文件详细信息" 
      :visible.sync="fileInfoVisible" 
      :width="isMobile ? '90%' : '500px'"
      append-to-body
    >
      <div v-if="currentFile" class="file-info-dialog">
        <div class="file-info-header">
          <div class="file-icon-large" :class="getFileTypeClass(currentFile.fileType)">
            <i :class="getFileIcon(currentFile.fileType)"></i>
          </div>
          <div class="file-info-main">
            <h3>{{ currentFile.fileName }}</h3>
            <p class="file-type-text">{{ getFileTypeText(currentFile.fileType) }}</p>
          </div>
        </div>
        
        <el-divider />
        
        <el-descriptions :column="1" border>
          <el-descriptions-item label="资源ID">{{ currentFile.resourceId }}</el-descriptions-item>
          <el-descriptions-item label="文件大小">{{ formatFileSize(currentFile.fileSize) }}</el-descriptions-item>
          <el-descriptions-item label="文件类型">{{ currentFile.fileType }}</el-descriptions-item>
          <el-descriptions-item label="创建时间">{{ parseTime(currentFile.createTime) }}</el-descriptions-item>
        </el-descriptions>
      </div>
      
      <div slot="footer" class="dialog-footer">
        <el-button @click="fileInfoVisible = false">关闭</el-button>
        <el-button type="primary" @click="handleDownload(currentFile)">下载文件</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getCourseResource } from "@/api/system/courseResource";
import { parseTime } from "@/utils";

export default {
  name: "MyCourseResource",
  data() {
    return {
      loading: false,
      resourceList: [],
      courseId: null,
      courseName: '',
      searchText: '',
      filterType: '',
      fileInfoVisible: false,
      currentFile: null
    };
  },

  computed: {
    isMobile() {
      return window.innerWidth <= 768;
    },
    
    filteredResources() {
      let resources = this.resourceList;
      
      // 搜索过滤
      if (this.searchText) {
        resources = resources.filter(resource => 
          resource.fileName.toLowerCase().includes(this.searchText.toLowerCase())
        );
      }
      
      // 类型过滤
      if (this.filterType) {
        resources = resources.filter(resource => {
          const fileType = resource.fileType?.toLowerCase();
          switch (this.filterType) {
            case 'document':
              return ['doc', 'docx', 'pdf', 'xls', 'xlsx', 'ppt', 'pptx'].includes(fileType);
            case 'image':
              return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg'].includes(fileType);
            case 'video':
              return ['mp4', 'avi', 'mov', 'wmv', 'flv'].includes(fileType);
            case 'archive':
              return ['zip', 'rar', '7z', 'tar', 'gz'].includes(fileType);
            case 'other':
              return !['doc', 'docx', 'pdf', 'xls', 'xlsx', 'ppt', 'pptx', 'jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg', 'mp4', 'avi', 'mov', 'wmv', 'flv', 'zip', 'rar', '7z', 'tar', 'gz'].includes(fileType);
            default:
              return true;
          }
        });
      }
      
      return resources;
    },
    
    totalSize() {
      const totalBytes = this.resourceList.reduce((sum, resource) => sum + (resource.fileSize || 0), 0);
      return this.formatFileSize(totalBytes);
    }
  },

  created() {
    this.courseId = this.$route.params.courseId || this.$route.query.courseId;
    this.courseName = this.$route.query.courseName || '';

    if (!this.courseId) {
      this.$message.error('缺少课程ID，即将返回');
      this.$router.go(-1);
      return;
    }

    this.getList();
    window.addEventListener('resize', this.handleResize);
  },

  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize);
  },

  methods: {
    handleResize() {
      this.$forceUpdate();
    },
    
    parseTime,

    goBack() {
      this.$router.go(-1);
    },

    /** 格式化文件大小 */
    formatFileSize(bytes) {
      if (bytes === 0 || !bytes) return '0 B';
      const k = 1024;
      const sizes = ['B', 'KB', 'MB', 'GB'];
      const i = Math.floor(Math.log(bytes) / Math.log(k));
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    },

    /** 获取文件图标 */
    getFileIcon(fileType) {
      const iconMap = {
        'pdf': 'el-icon-document',
        'doc': 'el-icon-document',
        'docx': 'el-icon-document',
        'xls': 'el-icon-document',
        'xlsx': 'el-icon-document',
        'ppt': 'el-icon-document',
        'pptx': 'el-icon-document',
        'zip': 'el-icon-folder',
        'rar': 'el-icon-folder',
        '7z': 'el-icon-folder',
        'jpg': 'el-icon-picture',
        'jpeg': 'el-icon-picture',
        'png': 'el-icon-picture',
        'gif': 'el-icon-picture',
        'mp4': 'el-icon-video-play',
        'avi': 'el-icon-video-play',
        'mov': 'el-icon-video-play'
      };
      return iconMap[fileType?.toLowerCase()] || 'el-icon-document';
    },

    /** 获取文件类型样式类 */
    getFileTypeClass(fileType) {
      const type = fileType?.toLowerCase();
      if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'].includes(type)) {
        return 'file-type-document';
      } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg'].includes(type)) {
        return 'file-type-image';
      } else if (['mp4', 'avi', 'mov', 'wmv', 'flv'].includes(type)) {
        return 'file-type-video';
      } else if (['zip', 'rar', '7z', 'tar', 'gz'].includes(type)) {
        return 'file-type-archive';
      } else {
        return 'file-type-other';
      }
    },

    /** 获取文件类型文本 */
    getFileTypeText(fileType) {
      const type = fileType?.toLowerCase();
      if (['pdf'].includes(type)) return 'PDF文档';
      if (['doc', 'docx'].includes(type)) return 'Word文档';
      if (['xls', 'xlsx'].includes(type)) return 'Excel文档';
      if (['ppt', 'pptx'].includes(type)) return 'PPT文档';
      if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg'].includes(type)) return '图片文件';
      if (['mp4', 'avi', 'mov', 'wmv', 'flv'].includes(type)) return '视频文件';
      if (['zip', 'rar', '7z', 'tar', 'gz'].includes(type)) return '压缩文件';
      return '其他文件';
    },

    /** 查询资源列表 */
    getList() {
      this.loading = true;
      console.log('准备调接口，courseId=', this.courseId);
      getCourseResource(this.courseId).then(res => {
        console.log('接口原始返回', res);
        if (res.code === 200) {
          this.resourceList = res.data ? [res.data] : [];
          console.log('resourceList', this.resourceList);
        } else {
          this.$message.error('获取资源失败：' + res.msg);
          this.resourceList = [];
        }
        this.loading = false;
      }).catch(err => {
        console.error('接口异常', err);
        this.$message.error('获取资源异常');
        this.loading = false;
      });
    },

    /** 搜索处理 */
    handleSearch() {
      // 搜索逻辑已经在 computed 中处理
    },

    /** 过滤处理 */
    handleFilter() {
      // 过滤逻辑已经在 computed 中处理
    },

    /** 下载资源 */
    handleDownload(resource) {
      const link = document.createElement('a');
      link.href = resource.filePath;
      link.download = resource.fileName;
      link.target = '_blank';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      
      this.$message.success('开始下载: ' + resource.fileName);
    },

    /** 预览资源 */
    handlePreview(resource) {
      window.open(resource.filePath, '_blank');
      this.$message.info('在新窗口中预览文件');
    },

    /** 显示文件信息 */
    showFileInfo(resource) {
      this.currentFile = resource;
      this.fileInfoVisible = true;
    },

    /** 下载全部资源 */
    downloadAllResources() {
      if (this.resourceList.length === 0) {
        this.$message.warning('暂无资源可下载');
        return;
      }

      this.$confirm(`确定要下载全部 ${this.resourceList.length} 个资源文件吗？`, '提示', {
        confirmButtonText: '确定下载',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.resourceList.forEach(resource => {
          this.handleDownload(resource);
        });
        this.$message.success(`开始下载 ${this.resourceList.length} 个文件`);
      }).catch(() => {
        // 取消下载
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.resource-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);
}

/* 页面头部 */
.page-header {
  margin-bottom: 24px;
  
  .header-main {
    display: flex;
    align-items: center;
    gap: 24px;
    
    .back-section {
      .back-btn {
        color: #606266;
        font-weight: 500;
        
        &:hover {
          color: #409eff;
        }
      }
    }
    
    .title-section {
      flex: 1;
      
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
    
    .stats-section {
      display: flex;
      gap: 24px;
      
      .stat-item {
        text-align: center;
        
        .stat-number {
          font-size: 24px;
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
}

/* 工具栏 */
.toolbar-section {
  margin-bottom: 20px;
  
  .toolbar-card {
    border-radius: 12px;
    border: none;
  }
  
  .toolbar-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    
    .search-filter {
      display: flex;
      gap: 12px;
      align-items: center;
      
      .search-input {
        width: 240px;
      }
      
      .type-filter {
        width: 120px;
      }
    }
    
    .toolbar-actions {
      display: flex;
      gap: 8px;
    }
  }
}

/* 资源列表区域 */
.resource-list-section {
  .resource-card {
    border-radius: 12px;
    border: none;
  }
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .header-title {
      font-size: 18px;
      font-weight: 600;
      color: #303133;
    }
    
    .header-count {
      font-size: 14px;
      color: #909399;
    }
  }
}

/* 网页版表格样式 */
.desktop-view {
  .resource-table {
    ::v-deep .el-table__row {
      transition: all 0.3s ease;
      
      &:hover {
        background: #f8f9fa;
      }
    }
    
    .file-info {
      display: flex;
      align-items: center;
      gap: 12px;
      
      .file-icon {
        width: 48px;
        height: 48px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        
        &.file-type-document {
          background: linear-gradient(135deg, #409eff, #66b1ff);
        }
        
        &.file-type-image {
          background: linear-gradient(135deg, #67c23a, #85ce61);
        }
        
        &.file-type-video {
          background: linear-gradient(135deg, #e6a23c, #ebb563);
        }
        
        &.file-type-archive {
          background: linear-gradient(135deg, #f56c6c, #f78989);
        }
        
        &.file-type-other {
          background: linear-gradient(135deg, #909399, #b1b3b8);
        }
        
        i {
          font-size: 24px;
          color: white;
        }
      }
      
      .file-details {
        flex: 1;
        
        .file-name {
          font-size: 14px;
          font-weight: 500;
          color: #303133;
          margin-bottom: 4px;
          word-break: break-all;
        }
        
        .file-meta {
          display: flex;
          gap: 12px;
          font-size: 12px;
          color: #909399;
          
          .file-type {
            background: #f4f4f5;
            padding: 2px 6px;
            border-radius: 3px;
          }
        }
      }
    }
    
    .action-buttons {
      display: flex;
      gap: 8px;
      justify-content: center;
      
      .download-btn, .preview-btn, .info-btn {
        border: none;
      }
    }
  }
}

/* 移动端卡片样式 */
.mobile-view {
  .resource-cards {
    display: grid;
    gap: 12px;
  }
  
  .resource-card-mobile {
    background: white;
    border-radius: 12px;
    padding: 16px;
    border: 1px solid #e4e7ed;
    transition: all 0.3s ease;
    
    &:hover {
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    
    .card-main {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 12px;
      
      .file-icon-mobile {
        width: 40px;
        height: 40px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        
        &.file-type-document {
          background: linear-gradient(135deg, #409eff, #66b1ff);
        }
        
        &.file-type-image {
          background: linear-gradient(135deg, #67c23a, #85ce61);
        }
        
        &.file-type-video {
          background: linear-gradient(135deg, #e6a23c, #ebb563);
        }
        
        &.file-type-archive {
          background: linear-gradient(135deg, #f56c6c, #f78989);
        }
        
        &.file-type-other {
          background: linear-gradient(135deg, #909399, #b1b3b8);
        }
        
        i {
          font-size: 20px;
          color: white;
        }
      }
      
      .file-info-mobile {
        flex: 1;
        
        .file-name-mobile {
          font-size: 14px;
          font-weight: 500;
          color: #303133;
          margin-bottom: 4px;
          word-break: break-all;
        }
        
        .file-meta-mobile {
          display: flex;
          gap: 8px;
          font-size: 12px;
          color: #909399;
          margin-bottom: 2px;
          
          .file-type {
            background: #f4f4f5;
            padding: 1px 4px;
            border-radius: 2px;
          }
        }
        
        .file-time-mobile {
          font-size: 11px;
          color: #c0c4cc;
        }
      }
    }
    
    .card-actions {
      display: flex;
      gap: 8px;
      justify-content: flex-end;
      border-top: 1px solid #f0f0f0;
      padding-top: 12px;
      
      .mobile-download-btn, .mobile-preview-btn {
        color: #409eff;
        
        &:hover {
          color: #67c23a;
        }
      }
    }
  }
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 40px 0;
}

/* 文件信息对话框 */
.file-info-dialog {
  .file-info-header {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-bottom: 16px;
    
    .file-icon-large {
      width: 60px;
      height: 60px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      
      &.file-type-document {
        background: linear-gradient(135deg, #409eff, #66b1ff);
      }
      
      &.file-type-image {
        background: linear-gradient(135deg, #67c23a, #85ce61);
      }
      
      &.file-type-video {
        background: linear-gradient(135deg, #e6a23c, #ebb563);
      }
      
      &.file-type-archive {
        background: linear-gradient(135deg, #f56c6c, #f78989);
      }
      
      &.file-type-other {
        background: linear-gradient(135deg, #909399, #b1b3b8);
      }
      
      i {
        font-size: 28px;
        color: white;
      }
    }
    
    .file-info-main {
      h3 {
        margin: 0 0 4px 0;
        color: #303133;
        font-size: 18px;
      }
      
      .file-type-text {
        margin: 0;
        color: #909399;
        font-size: 14px;
      }
    }
  }
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .resource-container {
    padding: 12px;
  }
  
  .page-header {
    .header-main {
      flex-direction: column;
      align-items: stretch;
      gap: 16px;
      
      .title-section {
        text-align: center;
      }
      
      .stats-section {
        justify-content: space-around;
      }
    }
  }
  
  .toolbar-content {
    flex-direction: column;
    align-items: stretch !important;
    
    .search-filter {
      justify-content: center;
      
      .search-input {
        width: 100% !important;
      }
    }
    
    .toolbar-actions {
      justify-content: center;
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
}
</style>
<template>
  <div class="my-course-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">我的课程</h1>
        <p class="page-subtitle">我所在班级下的课程</p>
      </div>
      
    </div>
    <el-alert v-if="errorMsg" :title="errorMsg" type="error" show-icon class="error-alert" />
    
    <!-- 移动端卡片布局 -->
    <div class="mobile-view" v-if="isMobile">
      <div class="course-cards">
        <div 
          v-for="course in courseList" 
          :key="course.courseId"
          class="course-card"
        >
          <div class="card-header">
            <div class="course-basic">
              <div class="course-name">{{ course.courseName }}</div>
              <div class="course-id">ID: {{ course.courseId }}</div>
            </div>
            <div class="dept-info">
              <i class="el-icon-school"></i>
              <span>{{ course.deptName }}</span>
            </div>
          </div>
          
          <div class="card-content">
            <div class="course-desc">
              {{ course.brief || '暂无课程描述' }}
            </div>
          </div>
          
          <div class="card-actions">
            <el-button 
              size="small" 
              type="primary" 
              icon="el-icon-folder-opened"
              @click="toggleResource(course)"
              class="resource-btn"
            >
              查看资源
            </el-button>
            <el-button
              size="small"
              type="success"
              icon="el-icon-edit-outline"
              @click="handleViewAssignments(course)"
              class="assignment-btn"
            >
              提交作业
            </el-button>
            <el-button
              size="small"
              type="warning"
              icon="el-icon-document"
              @click="handleQuestionnaire(course)"
              class="questionnaire-btn"
            >
              课程评价
            </el-button>
          </div>
          
          <!-- 资源展开区域 -->
          <div v-if="course.resources && course.resources.length > 0" class="resource-section">
            <div class="resource-header">
              <span class="resource-title">课程资源</span>
              <span class="resource-count">共 {{ course.resources.length }} 个文件</span>
            </div>
            <div class="resource-list">
              <div 
                v-for="resource in course.resources" 
                :key="resource.resourceId"
                class="resource-item"
              >
                <div class="resource-info">
                  <div class="file-icon">
                    <i :class="getFileIcon(resource.fileType)"></i>
                  </div>
                  <div class="file-details">
                    <div class="file-name">{{ resource.fileName }}</div>
                    <div class="file-meta">
                      <span class="file-type">{{ resource.fileType }}</span>
                      <span class="file-size">{{ formatFileSize(resource.fileSize) }}</span>
                    </div>
                  </div>
                </div>
                <div class="resource-actions">
                  <el-button 
                    size="mini" 
                    type="text" 
                    icon="el-icon-download"
                    @click="handleDownload(resource)"
                    class="download-btn"
                  ></el-button>
                  <el-button 
                    size="mini" 
                    type="text" 
                    icon="el-icon-view"
                    @click="handlePreview(resource)"
                    class="preview-btn"
                  ></el-button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 移动端空状态 -->
      <div v-if="courseList.length === 0 && !loading" class="empty-state-mobile">
        <div class="empty-content">
          <i class="el-icon-notebook-2 empty-icon"></i>
          <p class="empty-text">暂无课程数据</p>
          <el-button type="primary" @click="getList" size="small">刷新</el-button>
        </div>
      </div>
    </div>

    <!-- 网页版表格布局（保持不变） -->
    <div class="desktop-view" v-else>
      <el-table ref="courseTable" v-loading="loading" :data="courseList" row-key="courseId">
        <el-table-column label="课程ID" prop="courseId" width="80" />
         <!-- 创建时间 -->
          <!-- <el-table-column prop="createTime" label="创建时间" width="200">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
            </template>
          </el-table-column> -->
        <el-table-column label="课程名称" prop="courseName" width="150"/>
        <el-table-column label="课程描述" prop="brief" width="300" />
        <el-table-column label="所属部门" prop="deptName" width="300"/>
        <el-table-column label="操作" width="500">
          <template slot-scope="scope">
            <el-button size="mini" type="primary" icon="el-icon-view" @click="toggleResource(scope.row)" v-hasPermi="['system:myCourse:resource:view']">
              查看资源
            </el-button>
            <el-button
              size="mini"
              type="success"
              icon="el-icon-edit-outline"
              @click="handleViewAssignments(scope.row)" v-hasPermi="['system:myCourse:assignment:userSubmit']"
            >
              提交作业
            </el-button>
            <el-button
              size="mini"
              type="warning"
              icon="el-icon-document"
              @click="handleQuestionnaire(scope.row)"
            >
              填写评价
            </el-button>
          </template>
        </el-table-column>

        <!-- 展开行：当前课程的资源 -->
        <el-table-column type="expand">
          <template slot-scope="props">
            <div v-if="props.row.resources && props.row.resources.length > 0" class="resource-panel">
              <el-table :data="props.row.resources" size="mini" border>
                <el-table-column prop="resourceId" label="资源ID" width="80" />
                <el-table-column prop="fileName" label="文件名" />
                <el-table-column prop="fileType" label="类型" width="80" />
                <el-table-column label="大小" width="100">
                  <template slot-scope="r">
                    {{ formatFileSize(r.row.fileSize) }}
                  </template>
                </el-table-column>
                <el-table-column label="操作" width="200">
                  <template slot-scope="r">
                    <el-button size="mini" type="text" icon="el-icon-download"
                      @click="handleDownload(r.row)">下载</el-button>
                    <el-button size="mini" type="text" icon="el-icon-view" @click="handlePreview(r.row)">预览</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </div>
            <div v-else class="no-resource">暂无资源</div>
          </template>
        </el-table-column>
      </el-table>
    </div>
    
    <!-- 作业管理对话框 -->
    <el-dialog title="我的作业" :visible.sync="assignmentVisible" :width="isMobile ? '95%' : '80%'" append-to-body>
      <assignment-user 
        v-if="assignmentVisible" 
        :course-id="currentCourseId" 
        :course-name="currentCourseName"
        @close="assignmentVisible = false"
      />
    </el-dialog>
  </div>
</template>

<script>
import { listMyDeptCourse } from '@/api/system/deptCourse'
import { getCourseResource } from '@/api/system/courseResource'
import { parseTime } from '@/utils'
import AssignmentUser from './assignment.vue'

export default {
  name: 'MyCourse',
  components: { AssignmentUser },
  data() {
    return {
      loading: false,
      errorMsg: '',
      courseList: [],
      assignmentVisible: false,
      currentCourseId: null,
      currentCourseName: ''
    }
  },
  computed: {
    isMobile() {
      return window.innerWidth <= 768
    }
  },
  created() {
    this.getList()
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  },
  methods: {
    handleResize() {
      this.$forceUpdate()
    },
    
    parseTime,
    /** 格式化文件大小 */
    formatFileSize(bytes) {
      if (bytes === 0 || !bytes) return '0 B'
      const k = 1024
      const sizes = ['B', 'KB', 'MB', 'GB']
      const i = Math.floor(Math.log(bytes) / Math.log(k))
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
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
        'jpg': 'el-icon-picture',
        'png': 'el-icon-picture',
        'mp4': 'el-icon-video-play'
      }
      return iconMap[fileType?.toLowerCase()] || 'el-icon-document'
    },
    
    /** 获取课程列表 */
    getList() {
      this.loading = true
      this.errorMsg = ''
      listMyDeptCourse().then(res => {
        if (res.code !== 200) {
          this.errorMsg = '获取课程列表失败: ' + res.msg
          this.courseList = []
        } else {
          this.courseList = (res.rows || []).map(item => ({
            ...item,
            resources: [] // 预置空数组，后面点按钮再填充
          }))
          if (this.courseList.length === 0) {
            this.errorMsg = '暂无课程数据'
          }
        }
        this.loading = false
      }).catch(err => {
        console.error('获取课程列表失败:', err)
        this.errorMsg = '获取课程列表失败: ' + (err.message || err)
        this.loading = false
      })
    },
    /** 展开/收起资源 */
    toggleResource(row) {
      // 已展开且有数据 → 直接收起（移动端通过v-if控制显示）
      if (row.resources && row.resources.length > 0) {
        // 移动端：通过重新获取数据来切换显示
        this.$set(row, 'resources', [])
        return
      }
      // 无数据 → 调接口
      getCourseResource(row.courseId).then(res => {
        if (res.code === 200) {
          const resources = Array.isArray(res.data) ? res.data : (res.data ? [res.data] : [])
          this.$set(row, 'resources', resources)
        } else {
          this.$set(row, 'resources', [])
          this.$message.error('获取资源失败：' + res.msg)
        }
        // 网页版保持原来的展开逻辑
        if (!this.isMobile && this.$refs.courseTable) {
          this.$refs.courseTable.toggleRowExpansion(row, true)
        }
      }).catch(err => {
        console.error('获取资源异常:', err)
        this.$set(row, 'resources', [])
        this.$message.error('获取资源异常')
      })
    },
    /** 下载文件 */
    handleDownload(row) {
      const link = document.createElement('a')
      link.href = row.filePath
      link.download = row.fileName
      link.target = '_blank'
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
    },
    /** 预览文件 */
    handlePreview(row) {
      window.open(row.filePath, '_blank')
    },

    // 查看并提交作业
    handleViewAssignments(row) {
      this.currentCourseId = row.courseId
      this.currentCourseName = row.courseName
      this.assignmentVisible = true
    },
    
    // 填写评价
    handleQuestionnaire(row) {
      // 根据设备类型决定跳转路径
      const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
      const path = isMobile ? '/mobile/questionnaire/userList' : '/system/questionnaire/userList';
      
      // 跳转到评价列表页面，传递课程ID作为查询参数
      this.$router.push({
        path: path,
        query: {
          courseId: row.courseId
        }
      })
    }
  }
}
</script>

<style scoped>

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
    
    .page-subtitle {
      font-size: 16px;
      color: #909399;
      margin: 0;
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

.my-course-container {
  padding: 16px;
  min-height: calc(100vh - 84px);
}

.error-alert {
  margin-bottom: 16px;
  border-radius: 8px;
}

/* 网页版样式保持不变 */
.desktop-view {
  .resource-panel {
    padding: 10px;
    background: #fafafa;
    border: 1px solid #ebeef5;
    border-radius: 4px;
    margin-top: 10px;
  }

  .no-resource {
    text-align: center;
    padding: 20px;
    color: #909399;
  }
}

/* 移动端样式 */
.mobile-view {
  .course-cards {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }
  
  .course-card {
    background: white;
    border-radius: 12px;
    padding: 16px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    border: 1px solid #f0f0f0;
  }
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 12px;
    
    .course-basic {
      flex: 1;
      
      .course-name {
        font-size: 18px;
        font-weight: 600;
        color: #303133;
        margin-bottom: 4px;
        line-height: 1.3;
      }
      
      .course-id {
        font-size: 12px;
        color: #909399;
      }
    }
    
    .dept-info {
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 12px;
      color: #409eff;
      background: #ecf5ff;
      padding: 4px 8px;
      border-radius: 12px;
      white-space: nowrap;
    }
  }
  
  .card-content {
    margin-bottom: 16px;
    
    .course-desc {
      font-size: 14px;
      color: #606266;
      line-height: 1.5;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
  }
  
  .card-actions {
    display: flex;
    gap: 8px;
    
    .resource-btn, .assignment-btn, .questionnaire-btn {
      flex: 1;
      border-radius: 8px;
      font-weight: 500;
    }
  }
  
  .resource-section {
    margin-top: 16px;
    padding-top: 16px;
    border-top: 1px solid #f0f0f0;
    
    .resource-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
      
      .resource-title {
        font-size: 14px;
        font-weight: 600;
        color: #303133;
      }
      
      .resource-count {
        font-size: 12px;
        color: #909399;
      }
    }
    
    .resource-list {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    
    .resource-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px;
      background: #fafbfc;
      border-radius: 8px;
      border: 1px solid #f0f0f0;
      
      .resource-info {
        display: flex;
        align-items: center;
        gap: 8px;
        flex: 1;
        
        .file-icon {
          width: 32px;
          height: 32px;
          border-radius: 6px;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          display: flex;
          align-items: center;
          justify-content: center;
          
          i {
            font-size: 16px;
            color: white;
          }
        }
        
        .file-details {
          flex: 1;
          min-width: 0;
          
          .file-name {
            font-size: 14px;
            color: #303133;
            margin-bottom: 2px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
          }
          
          .file-meta {
            display: flex;
            gap: 8px;
            font-size: 11px;
            color: #909399;
            
            .file-type {
              background: #f4f4f5;
              padding: 1px 4px;
              border-radius: 2px;
            }
          }
        }
      }
      
      .resource-actions {
        display: flex;
        gap: 4px;
        
        .download-btn, .preview-btn {
          color: #409eff;
          padding: 6px;
          
          &:hover {
            color: #67c23a;
          }
        }
      }
    }
  }
  
  .empty-state-mobile {
    text-align: center;
    padding: 60px 20px;
    
    .empty-content {
      .empty-icon {
        font-size: 64px;
        color: #dcdfe6;
        margin-bottom: 16px;
      }
      
      .empty-text {
        font-size: 16px;
        color: #909399;
        margin-bottom: 16px;
      }
    }
  }
}

/* 响应式适配 */
@media screen and (max-width: 768px) {
  .desktop-view {
    display: none;
  }
}

@media screen and (min-width: 769px) {
  .mobile-view {
    display: none;
  }
  
  .my-course-container {
    padding: 20px;
  }
}

/* 加载状态优化 */
::v-deep .el-loading-mask {
  border-radius: 12px;
}
</style>

<style lang="scss" scoped>
::v-deep .el-dialog__wrapper {
  ::v-deep .el-dialog {
    min-width: 600px;
    
    @media screen and (max-width: 768px) {
      min-width: unset;
      width: 95% !important;
      margin: 20px auto !important;
    }
  }
}
</style>
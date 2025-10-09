<template>
  <div class="app-container">
    <el-alert v-if="errorMsg" :title="errorMsg" type="error" show-icon />
    <el-table ref="courseTable" v-loading="loading" :data="courseList" row-key="courseId">
      <el-table-column label="课程ID" prop="courseId" width="80" />
      <el-table-column label="课程名称" prop="courseName" />
      <el-table-column label="课程描述" prop="brief" />
      <el-table-column label="所属部门" prop="deptName" />
      <el-table-column label="操作" width="300">
        <template slot-scope="scope">
          <el-button size="mini" type="primary" icon="el-icon-view" @click="toggleResource(scope.row)">
            查看资源
          </el-button>
          <el-button
            size="mini"
            type="success"
            icon="el-icon-edit-outline"
            @click="handleViewAssignments(scope.row)"
          >
            提交作业
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
    
    <!-- 作业管理对话框 -->
    <el-dialog title="我的作业" :visible.sync="assignmentVisible" width="80%" append-to-body>
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
  created() {
    this.getList()
  },
  methods: {
    parseTime,
    /** 格式化文件大小 */
    formatFileSize(bytes) {
      if (bytes === 0 || !bytes) return '0 B'
      const k = 1024
      const sizes = ['B', 'KB', 'MB', 'GB']
      const i = Math.floor(Math.log(bytes) / Math.log(k))
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
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
      // 已展开且有数据 → 直接收起
      if (row.resources && row.resources.length > 0) {
        this.$refs.courseTable.toggleRowExpansion(row, false)
        return
      }
      // 无数据 → 调接口
      getCourseResource(row.courseId).then(res => {
        if (res.code === 200) {
          // 修改这里：直接使用 res.data，不再包装成数组
          const resources = Array.isArray(res.data) ? res.data : (res.data ? [res.data] : [])
          this.$set(row, 'resources', resources)

          // 调试：打印资源数据
          console.log('课程', row.courseId, '的资源数据:', resources)
        } else {
          this.$set(row, 'resources', [])
          this.$message.error('获取资源失败：' + res.msg)
        }
        this.$nextTick(() => {
          if (this.$refs.courseTable) {
            this.$refs.courseTable.toggleRowExpansion(row, true)
          }
        })
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
    }
  }
}
</script>

<style scoped>
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
</style>

<style lang="scss" scoped>
::v-deep .el-dialog__wrapper {
  ::v-deep .el-dialog {
    min-width: 600px;
  }
}
</style>
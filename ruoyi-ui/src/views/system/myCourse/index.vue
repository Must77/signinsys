<!-- <template>
  <div class="app-container">
    <el-alert v-if="errorMsg" :title="errorMsg" type="error" show-icon />
    <el-table v-loading="loading" :data="courseList">
      <el-table-column label="课程ID" prop="courseId" width="80" />
      <el-table-column label="课程名称" prop="courseName" />
      <el-table-column label="课程描述" prop="brief" />
      <el-table-column label="所属部门" prop="deptName" />
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            icon="el-icon-view"
            @click="handleViewResources(scope.row)"
          >
            查看资源
          </el-button>
          
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import { listMyDeptCourse } from '@/api/system/deptCourse'
import { getCourseResource } from '@/api/system/courseResource'

export default {
  name: "MyCourse",
  data() {
    return {
      loading: false,
      errorMsg: '',
      courseList: [],
      courseResources: {} // 存储各课程的资源信息
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      this.errorMsg = ''
      listMyDeptCourse().then(res => {
        console.log("API返回的课程数据:", res);
        if (res.code !== 200) {
          this.errorMsg = '获取课程列表失败: ' + res.msg
          this.courseList = []
        } else {
          this.courseList = res.rows || []
          if (this.courseList.length === 0) {
            this.errorMsg = '暂无课程数据'
          } else {
            // 获取每个课程的资源信息
            this.loadCourseResources()
          }



        }
        this.loading = false
      }).catch(error => {
        console.error("获取课程列表失败:", error)
        this.errorMsg = '获取课程列表失败: ' + (error.message || error)
        this.courseList = []
        this.loading = false
      })
    },
    
    // 加载课程资源信息
    loadCourseResources() {
      this.courseList.forEach(course => {
        getCourseResource(course.courseId).then(res => {
          if (res.code === 200) {
            this.$set(this.courseResources, course.courseId, res.data || [])
          }
        }).catch(error => {
          console.error(`获取课程${course.courseId}资源失败:`, error)
        })
      })
    },
    
    // 查看课程资源
    handleViewResources(row) {
      console.log('【跳转前】courseId=', row.courseId, 'courseName=', row.courseName)
      this.$router.push({
        name: 'MyCourseResource',
        params: {
          courseId: row.courseId
        },
        query: {
          courseName: row.courseName
        }
      })
    },
    
    
  }
}
</script> -->

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
              <!-- <el-table-column label="上传时间" width="150">
                <template slot-scope="r">
                  {{ parseTime(r.row.createTime) }}
                </template>
              </el-table-column> -->
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
</template>

<script>
import { listMyDeptCourse } from '@/api/system/deptCourse'
import { getCourseResource } from '@/api/system/courseResource'
import { parseTime } from '@/utils'
import AssignmentUser from './assignment.vue' // 新增：作业提交组件

export default {
  name: 'MyCourse',
  components: { AssignmentUser }, // 注册组件
  data() {
    return {
      loading: false,
      errorMsg: '',
      courseList: [],
      assignmentVisible: false,     // 控制作业对话框显示
      currentCourseId: null,        // 当前选中的课程ID
      currentCourseName: ''         // 当前课程名称
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
    /** 拉课程列表 */
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
```

```vue
<<<<<<< SEARCH
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

<!-- 新增：避免 dialog 被遮挡 -->
<style lang="scss" scoped>
::v-deep .el-dialog__wrapper {
  ::v-deep .el-dialog {
    min-width: 600px;
  }
}
</style>

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
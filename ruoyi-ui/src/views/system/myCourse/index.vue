<template>
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
          <!-- <el-button
            size="mini"
            type="success"
            icon="el-icon-download"
            @click="handleDownloadResources(scope.row)"
            :disabled="!hasResources(scope.row)"
          >
            下载资源
          </el-button> -->
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
    
    // 检查课程是否有资源
    hasResources(row) {
      const resources = this.courseResources[row.courseId]
      return resources && resources.length > 0
    },
    
    // 查看课程资源
    handleViewResources(row) {
      this.$router.push({
        name: 'CourseResource',
        params: { 
          courseId: row.courseId,
          courseName: row.courseName
        }
      })
    },
    
    // 下载课程资源
    // handleDownloadResources(row) {
    //   const resources = this.courseResources[row.courseId]
    //   if (resources && resources.length > 0) {
    //     // 如果只有一个资源，直接下载
    //     if (resources.length === 1) {
    //       const resource = resources[0]
    //       window.open(resource.filePath, '_blank')
    //     } else {
    //       // 如果有多个资源，跳转到资源页面
    //       this.handleViewResources(row)
    //       this.$message.info('该课程有多个资源，请在资源页面选择需要下载的文件')
    //     }
    //   } else {
    //     this.$message.warning('该课程暂无资源可下载')
    //   }
    // }
  }
}
</script>
<template>
  <div class="app-container">
    <el-alert v-if="errorMsg" :title="errorMsg" type="error" show-icon />
    <el-table v-loading="loading" :data="courseList">
      <el-table-column label="课程ID" prop="courseId" width="80" />
      <el-table-column label="课程名称" prop="courseName" />
      <el-table-column label="课程描述" prop="brief" />
      <el-table-column label="所属部门" prop="deptName" />
    </el-table>
  </div>
</template>

<script>
import { listMyDeptCourse } from '@/api/system/deptCourse'

export default {
  name: "MyCourse",
  data() {
    return {
      loading: false,
      errorMsg: '',
      courseList: []
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
          }
        }
        this.loading = false
      }).catch(error => {
        console.error("获取课程列表失败:", error)
        this.errorMsg = '获取课程列表失败: ' + (error.message || error)
        this.courseList = []
        this.loading = false
      })
    }
  }
}
</script>
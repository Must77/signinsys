<template>
  <div class="app-container">
    <h2>班级管理</h2>
    <el-table :data="tableData" style="width: 100%">
      <el-table-column prop="name" label="班级名称" width="180"></el-table-column>
      <el-table-column prop="teacher" label="班主任" width="180"></el-table-column>
      <el-table-column prop="studentCount" label="学员人数"></el-table-column>
      <el-table-column prop="address" label="教室地址"></el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'ClassManager',
  data() {
    return {
      tableData: [
        { name: '一班', teacher: '张老师', studentCount: 30, address: '教学楼A101' },
        { name: '二班', teacher: '李老师', studentCount: 28, address: '教学楼A102' },
        { name: '三班', teacher: '王老师', studentCount: 32, address: '教学楼A103' }
      ]
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 24px;
}
</style>

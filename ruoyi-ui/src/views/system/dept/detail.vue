<template>
  <el-dialog :title="'班级详情 - ' + dept.deptName" :visible.sync="visible" width="800px" append-to-body>
    <el-tabs v-model="activeTab">
      <el-tab-pane label="基本信息" name="info">
        <el-form ref="form" :model="dept" label-width="100px" size="small">
          <el-row>
            <el-col :span="12">
              <el-form-item label="班级名称:">{{ dept.deptName }}</el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="状态:">
                <el-tag v-if="dept.status === '0'" type="success">正常</el-tag>
                <el-tag v-else type="danger">停用</el-tag>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="创建时间:">{{ parseTime(dept.createTime) }}</el-form-item>
            </el-col>
            <!-- <el-col :span="12">
              <el-form-item label="修改时间:">{{ parseTime(dept.updateTime) }}</el-form-item>
            </el-col> -->
          </el-row>
          <!-- <el-row>
            <el-col :span="24">
              <el-form-item label="备注:">{{ dept.remark }}</el-form-item>
            </el-col>
          </el-row> -->
        </el-form>
      </el-tab-pane>
      
      <el-tab-pane label="班级课程" name="courses">
        <el-table :data="courses" style="width: 100%" size="small">
          <el-table-column prop="courseName" label="课程名称" />
          <el-table-column prop="brief" label="课程描述" />
          <el-table-column prop="createTime" label="创建时间" width="160">
            <template slot-scope="scope">
              {{ parseTime(scope.row.createTime) }}
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click="handleViewResources(scope.row)">查看资源</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
    
    <!-- 课程资源对话框 -->
    <el-dialog title="课程资源" :visible.sync="resourceVisible" width="600px" append-to-body>
      <el-table :data="resources" style="width: 100%" size="small">
        <el-table-column prop="fileName" label="资源名称" />
        <el-table-column prop="createTime" label="创建时间" width="160">
          <template slot-scope="scope">
            {{ parseTime(scope.row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" align="center">
          <template slot-scope="scope">
            <el-button size="mini" type="text" @click="handleDownload(scope.row)">下载</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>
  </el-dialog>
</template>

<script>
import { listDeptCourseByDeptId } from "@/api/system/deptCourse";
import { listCourseResource } from "@/api/system/courseResource";

export default {
  name: "DeptDetail",
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    dept: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      activeTab: "info",
      courses: [],
      resources: [],
      resourceVisible: false
    };
  },
  watch: {
    visible(newVal) {
      if (newVal) {
        this.loadCourses();
      }
    }
  },
  methods: {
    loadCourses() {
      listDeptCourseByDeptId(this.dept.deptId).then(response => {
        this.courses = response.rows || response.data || [];
      });
    },
    handleViewResources(row) {
      listCourseResource({ courseId: row.courseId }).then(response => {
        this.resources = response.rows || response.data || [];
        this.resourceVisible = true;
      });
    },
    handleDownload(row) {
      window.open(row.resourceUrl, "_blank");
    },
    close() {
      this.$emit("update:visible", false);
    }
  }
};
</script>

<style scoped>
.el-form-item {
  margin-bottom: 10px;
}
</style>
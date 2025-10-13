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
          <el-row>
            <el-col :span="24">
              <el-form-item label="简介:">{{ dept.brief }}</el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="开始时间:">{{ parseTime(dept.startTime) }}</el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="结束时间:">{{ parseTime(dept.endTime) }}</el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="班级容量:">{{ dept.cap }}</el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="当前人数:">{{ dept.size }}</el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="自动加入:">
                <el-tag v-if="dept.autoJoin === 1" type="success">是</el-tag>
                <el-tag v-else type="info">否</el-tag>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="24" style="text-align: center;">
              <el-button 
                type="primary" 
                @click="handleApply" 
                :disabled="isApplied"
                v-hasPermi="['system:deptApply:add']"
              >
                {{ isApplied ? '已报名' : '报名参加' }}
              </el-button>
            </el-col>
          </el-row>
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
          <el-table-column label="操作" width="200" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click="handleViewResources(scope.row)">查看资源</el-button>
              <el-button size="mini" type="text" @click="handleHomeworkManage(scope.row)">作业管理</el-button>
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
    
    <!-- 作业管理对话框 -->
    <el-dialog title="作业管理" :visible.sync="homeworkVisible" width="80%" append-to-body>
      <assignment-manage 
        v-if="homeworkVisible" 
        :course-id="currentCourseId" 
        :course-name="currentCourseName"
        @close="homeworkVisible = false"
      />
    </el-dialog>
  </el-dialog>
</template>

<script>
import { listDeptCourseByDeptId, getApplyStatus } from "@/api/system/dept";
import { listCourseResource } from "@/api/system/courseResource";
import { addDeptApply } from "@/api/system/deptApply";
import AssignmentManage from "./assignment.vue";

export default {
  name: "DeptDetail",
  components: { AssignmentManage },
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
      resourceVisible: false,
      homeworkVisible: false,
      currentCourseId: null,
      currentCourseName: '',
      isApplied: false
    };
  },
  watch: {
    visible(newVal) {
      if (newVal) {
        this.loadCourses();
        this.loadApplyStatus();
      }
    }
  },
  methods: {
    loadCourses() {
      if (this.dept.deptId) {
        listDeptCourseByDeptId(this.dept.deptId).then(response => {
          this.courses = response.data || [];
        });
      }
    },
    loadApplyStatus() {
      getApplyStatus(this.dept.deptId).then(response => {
        this.isApplied = response.data;
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
    handleHomeworkManage(row) {
      this.currentCourseId = row.courseId;
      this.currentCourseName = row.courseName;
      this.homeworkVisible = true;
    },
    close() {
      this.$emit("update:visible", false);
    },
    handleApply() {
      this.$modal.confirm('确认要报名参加"' + this.dept.deptName + '"吗？').then(() => {
        return addDeptApply({
          deptId: this.dept.deptId
        });
      }).then(() => {
        this.$modal.msgSuccess("报名申请已提交，请等待管理员审批");
        this.isApplied = true;
        this.close();
        this.$emit("applied");
      }).catch(() => {});
    }
  }
};
</script>

<style scoped>
.el-form-item {
  margin-bottom: 10px;
}
</style>
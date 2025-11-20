<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>班级内课程管理</span>
      </div>
      <!-- 添加班级筛选条件 -->
      <el-row :gutter="20" class="mb8">
        <el-col :span="6">
          <el-select v-model="queryDeptId" placeholder="请选择班级" clearable filterable @change="handleDeptChange">
            <el-option v-for="dept in deptOptions" :key="dept.id" :label="dept.label" :value="dept.id">
            </el-option>
          </el-select>
        </el-col>
        <el-col :span="2">
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery"
            v-hasPermi="['system:deptCourse:list']">查询</el-button>
        </el-col>
      </el-row>

      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button v-hasPermi="['system:deptCourse:add']" type="primary" icon="el-icon-plus" size="mini"
            @click="handleAdd">新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button v-hasPermi="['system:deptCourse:edit']" type="success" icon="el-icon-edit" size="mini"
            :disabled="single" @click="handleUpdate">修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button v-hasPermi="['system:deptCourse:remove']" type="danger" icon="el-icon-delete" size="mini"
            :disabled="multiple" @click="handleDelete">删除</el-button>
        </el-col>
      </el-row>

      <el-table :data="courseList" v-loading="loading" style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <!-- <el-table-column prop="courseId" label="课程ID" width="80" />
        <el-table-column prop="deptId" label="班级ID" width="120" /> -->
        <!-- 创建时间 -->
         <el-table-column label="创建时间" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}')  }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="deptName" label="班级名称" width="300" />
        <el-table-column prop="courseName" label="课程名称" />
        <el-table-column prop="brief" label="课程描述" />
        <el-table-column label="操作" width="280" v-hasPermi="['system:deptCourse:edit', 'system:deptCourse:remove']">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" v-hasPermi="['system:deptCourse:edit']"
              @click="handleEdit(scope.row)">编辑</el-button>

            <el-button size="mini" type="text" icon="el-icon-delete" v-hasPermi="['system:deptCourse:remove']"
              @click="handleDelete(scope.row)">删除</el-button>

            <el-button size="mini" type="text" icon="el-icon-folder" @click="handleResourceManage(scope.row)"
              v-hasPermi="['system:deptCourse:resource']">资源管理</el-button>

            <el-button size="mini" type="text" icon="el-icon-s-management" @click="handleAssignmentManage(scope.row)"
              v-hasPermi="['system:deptCourse:assignment']">作业管理</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :title="title" :visible.sync="dialogVisible" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="所属班级" prop="deptId">
          <treeselect v-model="form.deptId" :options="deptTreeOptions" :normalizer="normalizer" :show-count="true"
            placeholder="请选择所属班级" />
        </el-form-item>
        <el-form-item label="课程名称" prop="courseName">
          <el-input v-model="form.courseName" placeholder="请输入课程名称" />
        </el-form-item>
        <el-form-item label="课程描述" prop="brief">
          <el-input type="textarea" v-model="form.brief" placeholder="请输入课程描述" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 作业管理对话框 -->
    <el-dialog title="作业管理" :visible.sync="assignmentVisible" width="80%" append-to-body>
      <assignment-manage v-if="assignmentVisible" :course-id="currentCourseId" :course-name="currentCourseName"
        @close="assignmentVisible = false" />
    </el-dialog>
  </div>
</template>

<script>
import { listDeptCourse, listDeptCourseByDeptId, addDeptCourse, updateDeptCourse, delDeptCourse } from "@/api/system/deptCourse"
import { listDept } from "@/api/system/dept";
import Treeselect from "@riophae/vue-treeselect";
import "@riophae/vue-treeselect/dist/vue-treeselect.css";
import AssignmentManage from "@/views/system/dept/assignment.vue";

export default {
  name: "DeptCourse",
  components: { Treeselect, AssignmentManage },
  data() {
    return {
      loading: false,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      title: "",
      courseList: [],
      deptOptions: [],
      deptTreeOptions: [], // 用于treeselect的部门选项
      dialogVisible: false,
      assignmentVisible: false,
      queryDeptId: undefined, // 用于筛选的部门ID
      currentCourseId: null,
      currentCourseName: '',
      form: {
        courseId: undefined,
        deptId: undefined,
        courseName: "",
        brief: ""
      },
      rules: {
        deptId: [
          { required: true, message: "所属部门不能为空", trigger: "blur" }
        ],
        courseName: [
          { required: true, message: "课程名称不能为空", trigger: "blur" }
        ],
        brief: [
          { required: true, message: "课程描述不能为空", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.getList();
    this.getDeptTree(); // 确保在组件创建时获取部门树数据
  },
  methods: {
    /** 查询部门课程列表 */
    getList() {
      this.loading = true;
      // 如果选择了班级，则根据班级查询课程
      if (this.queryDeptId) {
        listDeptCourseByDeptId(this.queryDeptId).then(res => {
          // 统一处理返回数据，确保 data 字段存在
          const data = res.data || res.rows || [];
          this.courseList = Array.isArray(data) ? data : [];
          this.loading = false;
        }).catch(() => {
          this.loading = false;
          this.courseList = [];
        });
      } else {
        // 否则查询所有课程
        listDeptCourse().then(res => {
          // 统一处理返回数据，确保 data 字段存在
          const data = res.data || res.rows || [];
          this.courseList = Array.isArray(data) ? data : [];
          this.loading = false;
        }).catch(() => {
          this.loading = false;
          this.courseList = [];
        });
      }
    },
    /** 查询部门下拉树结构 */
    getDeptTree() {
      listDept().then(response => {
        if (response && response.data) {
          // 为筛选下拉框准备数据
          this.deptOptions = response.data.map(item => ({
            id: item.deptId,
            label: item.deptName,
            children: item.children || []
          }));

          // 为treeselect准备数据（使用原始数据结构）
          this.deptTreeOptions = response.data;
        } else {
          console.error('Failed to fetch department options:', response);
        }
      }).catch(error => {
        console.error('Error fetching department options:', error);
      });
    },
    // 树形结构转换
    normalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children;
      }
      return {
        id: node.deptId,
        label: node.deptName,
        children: node.children
      };
    },
    /** 班级选择变化 */
    handleDeptChange(value) {
      this.queryDeptId = value;
    },
    /** 查询按钮点击事件 */
    handleQuery() {
      this.getList();
    },
    // 取消按钮
    cancel() {
      this.dialogVisible = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        courseId: undefined,
        deptId: undefined,
        courseName: "",
        brief: ""
      };
      if (this.$refs.form) {
        this.$refs.form.resetFields();
      }
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.dialogVisible = true;
      this.title = "添加课程";
    },
    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.courseId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    /** 修改按钮操作 */
    handleEdit(row) {
      this.reset();
      const courseId = row.courseId || this.ids[0];
      this.form = Object.assign({}, row);
      this.dialogVisible = true;
      this.title = "修改课程";
    },
    /** 修改按钮操作 */
    handleUpdate() {
      this.reset();
      const courseId = this.ids[0];
      const row = this.courseList.find(item => item.courseId === courseId);
      this.form = Object.assign({}, row);
      this.dialogVisible = true;
      this.title = "修改课程";
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const courseIds = row.courseId || this.ids;
      this.$modal.confirm('是否确认删除课程编号为"' + courseIds + '"的数据项？').then(function () {
        return delDeptCourse(courseIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => { });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.courseId) {
            updateDeptCourse(this.form).then(() => {
              this.dialogVisible = false;
              this.getList();
              this.$modal.msgSuccess("修改成功");
            })
          } else {
            addDeptCourse(this.form).then(() => {
              this.dialogVisible = false;
              this.getList();
              this.$modal.msgSuccess("新增成功");
            })
          }
        }
      });
    },
    /** 课程资源管理 */
    handleResourceManage(row) {
      // 跳转到课程资源管理页面，传入课程ID
      this.$router.push({
        name: 'CourseResource',
        params: {
          courseId: row.courseId,
          courseName: row.courseName
        }
      });
    },
    /** 课程作业管理 */
    handleAssignmentManage(row) {
      // 正确的调试信息：显示课程信息
      console.log('打开作业管理，课程ID:', row.courseId);
      console.log('课程名称:', row.courseName);
      console.log('班级ID:', row.deptId);
      this.currentCourseId = row.courseId;
      this.currentCourseName = row.courseName;
      this.assignmentVisible = true;
    }
  }
}
</script>

<style scoped>
.mb8 {
  margin-bottom: 8px;
}
</style>
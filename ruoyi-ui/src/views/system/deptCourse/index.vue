<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>部门课程管理</span>
      </div>
      
      <el-row :gutter="10" class="mb8">
        <el-col :span="4">
          <el-input
            v-model="queryParams.name"
            placeholder="请输入课程名称"
            clearable
            size="small"
            @keyup.enter.native="handleQuery"
          />
        </el-col>
        <el-col :span="4">
          <treeselect
            v-model="queryParams.deptId"
            :options="deptOptions"
            :normalizer="normalizer"
            :show-count="true"
            placeholder="请选择所属部门"
            clearable
            size="small"
          />
        </el-col>
        <el-col :span="1.5">
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>
      
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button
            v-hasPermi="['system:deptCourse:add']"
            type="primary"
            icon="el-icon-plus"
            size="mini"
            @click="handleAdd"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            v-hasPermi="['system:deptCourse:edit']"
            type="success"
            icon="el-icon-edit"
            size="mini"
            :disabled="single"
            @click="handleUpdate"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            v-hasPermi="['system:deptCourse:remove']"
            type="danger"
            icon="el-icon-delete"
            size="mini"
            :disabled="multiple"
            @click="handleDelete"
          >删除</el-button>
        </el-col>
      </el-row>

      <el-table 
        :data="courseList" 
        v-loading="loading" 
        style="width: 100%"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="courseId" label="课程ID" width="80" />
                <el-table-column prop="name" label="课程名称" width="120"  />
        <el-table-column prop="deptId" label="部门ID" width="120" />
        <el-table-column prop="deptName" label="部门名称" />

        <el-table-column prop="brief" label="课程描述" />
        <el-table-column label="操作" width="150" v-hasPermi="['system:deptCourse:edit','system:deptCourse:remove']">
          <template slot-scope="scope">
            <el-button 
              size="mini" 
              type="text" 
              icon="el-icon-edit" 
              v-hasPermi="['system:deptCourse:edit']"
              @click="handleEdit(scope.row)"
            >编辑</el-button>
            <el-button 
              size="mini" 
              type="text" 
              icon="el-icon-delete" 
              v-hasPermi="['system:deptCourse:remove']"
              @click="handleDelete(scope.row)"
            >删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :title="title" :visible.sync="dialogVisible" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="所属部门" prop="deptId" v-if="!form.courseId">
          <treeselect
            v-model="form.deptId"
            :options="deptOptions"
            :normalizer="normalizer"
            :show-count="true"
            placeholder="请选择所属部门"
          />
        </el-form-item>
        <el-form-item label="课程名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入课程名称" />
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
  </div>
</template>

<script>
import { listDeptCourse, addDeptCourse, updateDeptCourse, delDeptCourse } from "@/api/system/deptCourse"
import { listDept } from "@/api/system/dept";
import Treeselect from "@riophae/vue-treeselect";
import "@riophae/vue-treeselect/dist/vue-treeselect.css";

export default {
  name: "DeptCourse",
  components: { Treeselect },
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
      dialogVisible: false,
      // 查询参数
      queryParams: {
        name: undefined,
        deptId: undefined
      },
      form: {
        courseId: undefined,
        deptId: undefined,
        name: "",
        brief: ""
      },
      rules: {
        deptId: [
          { required: true, message: "所属部门不能为空", trigger: "blur" }
        ],
        name: [
          { required: true, message: "课程名称不能为空", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.getList();
    this.getDeptTree();
  },
  methods: {
    /** 查询部门课程列表 */
    getList() {
      this.loading = true;
      listDeptCourse(this.queryParams).then(res => {
        this.courseList = res.rows;
        this.loading = false;
      })
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 查询部门下拉树结构 */
    getDeptTree() {
      listDept().then(res => {
        this.deptOptions = this.handleTree(res.data, "deptId");
      });
    },
    /** 转换部门数据结构 */
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
        courseDesc: ""
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
      const courseIds = row.courseId ? [row.courseId] : this.ids;
      this.$confirm('确认删除吗?').then(() => {
        delDeptCourse(courseIds).then(() => {
          this.getList();
          this.$modal.msgSuccess("删除成功");
        })
      }).catch(() => {});
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if(this.form.courseId) {
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
    }
  }
}
</script>

<style scoped>
.mb8 {
  margin-bottom: 8px;
}
</style>

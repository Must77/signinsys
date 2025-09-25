<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="签到标题" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="请输入签到标题"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="签到状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="签到状态" clearable>
          <el-option
            v-for="dict in dict.type.sys_normal_disable"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:signin:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:signin:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:signin:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['system:signin:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="signinList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="签到ID" align="center" prop="signinId" />
      <el-table-column label="签到标题" align="center" prop="title" />
      <el-table-column label="开始时间" align="center" prop="startTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.startTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="结束时间" align="center" prop="endTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.endTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="签到状态" align="center" prop="status">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleViewResult(scope.row)"
            v-hasPermi="['system:signin:query']"
          >查看结果</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:signin:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:signin:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改签到对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="课程名称" prop="courseName">
          <el-input v-model="form.courseName" placeholder="请输入课程名称" readonly />
        </el-form-item>
        <el-form-item label="签到标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入签到标题" />
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-date-picker clearable
            v-model="form.startTime"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择开始时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-date-picker clearable
            v-model="form.endTime"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择结束时间">
          </el-date-picker>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 签到结果对话框 -->
    <el-dialog title="签到结果" :visible.sync="resultOpen" width="800px" append-to-body>
      <el-tabs v-model="activeResultTab">
        <el-tab-pane label="已签到" name="signed">
          <el-table :data="signedUsers" style="width: 100%">
            <el-table-column label="学号" prop="studentId" />
            <el-table-column label="姓名" prop="studentName" />
            <el-table-column label="签到时间" prop="signinTime">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.signinTime) }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="未签到" name="unsigned">
          <el-table :data="unsignedUsers" style="width: 100%">
            <el-table-column label="学号" prop="studentId" />
            <el-table-column label="姓名" prop="studentName" />
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
  </div>
</template>

<script>
import { getToken } from "@/utils/auth";
import { listCourseSignin, getCourseSignin, addSignin, updateSignin, delSignin, exportSignin, getResult } from "@/api/system/signin";

export default {
  name: "CourseSignin",
  dicts: ['sys_normal_disable'],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 签到表格数据
      signinList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否显示结果弹出层
      resultOpen: false,
      // 活跃的结果标签页
      activeResultTab: 'signed',
      // 已签到用户
      signedUsers: [],
      // 未签到用户
      unsignedUsers: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        courseId: null,
        title: null,
        status: null
      },
      // 表单参数
      form: {
        signinId: null,
        courseId: null,
        deptId: null,
        courseName: null,
        title: null,
        startTime: null,
        endTime: null,
        status: "0"
      },
      // 表单校验
      rules: {
        title: [
          { required: true, message: "签到标题不能为空", trigger: "blur" }
        ],
        startTime: [
          { required: true, message: "开始时间不能为空", trigger: "change" }
        ],
        endTime: [
          { required: true, message: "结束时间不能为空", trigger: "change" }
        ]
      }
    };
  },
  created() {
    // 从路由参数中获取课程ID
    const courseId = this.$route.params.courseId || this.$route.query.courseId;
    if (courseId) {
      this.queryParams.courseId = courseId;
      this.form.courseId = courseId;
      
      // 如果有部门ID参数，也一并设置
      const deptId = this.$route.query.deptId;
      if (deptId) {
        this.form.deptId = deptId;
      }
      
      // 设置课程名称
      const courseName = this.$route.query.courseName;
      if (courseName) {
        this.form.courseName = courseName;
      }
      
      this.getList();
    } else {
      this.$modal.msgError("课程ID不能为空，请检查路由参数");
    }
  },
  methods: {
    /** 查询签到列表 */
    getList() {
      this.loading = true;
      
      // 检查课程ID是否存在
      if (!this.queryParams.courseId) {
        this.$modal.msgError("课程ID缺失，无法查询签到数据");
        this.loading = false;
        return;
      }
      
      listCourseSignin(this.queryParams).then(response => {
        this.signinList = response.rows;
        this.total = response.total;
        this.loading = false;
      }).catch(() => {
        this.loading = false;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;

      // 确保搜索时课程ID仍然存在
      if (!this.queryParams.courseId) {
        this.$modal.msgError('课程ID缺失，无法进行搜索');
        return;
      }

      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 返回按钮操作 */
    handleBack() {
      this.$router.go(-1);
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.signinId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加签到";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const signinId = row.signinId || this.ids[0];
      getCourseSignin(signinId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改签到";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["formRef"].validate(valid => {
        if (valid) {
          if (this.form.signinId != null) {
            updateCourseSignin(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addCourseSignin(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const signinIds = row.signinId || this.ids;
      this.$modal.confirm('是否确认删除签到编号为"' + signinIds + '"的数据项？').then(function() {
        return delCourseSignin(signinIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 查看结果按钮操作 */
    handleView(row) {
      // 获取已签到用户
      listSignedUsers(row.signinId).then(response => {
        this.signedUsers = response.data;
      });
      
      // 获取未签到用户
      listUnsignedUsers(row.signinId).then(response => {
        this.unsignedUsers = response.data;
      });
      
      this.resultOpen = true;
    },
    /** 导出签到结果 */
    handleExport(row) {
      this.$modal.confirm('是否确认导出"' + row.title + '"的签到数据？').then(() => {
        this.$download.name('/system/signin/export/' + row.signinId + '.xlsx', false);
      });
    },
    /** 导出全部签到结果 */
    handleExportAll() {
      this.$modal.confirm('是否确认导出所有签到数据？').then(() => {
        this.$download.name('/system/signin/export.xlsx', false);
      });
    },
    /** 表单重置 */
    reset() {
      this.form = {
        signinId: null,
        courseId: this.queryParams.courseId,
        deptId: this.form.deptId,
        title: null,
        startTime: null,
        endTime: null,
        status: "0"
      };
      this.resetForm("formRef");
    },
    /** 取消按钮 */
    cancel() {
      this.open = false;
      this.reset();
    },
    /** 日期格式化 */
    parseTime(time, pattern) {
      if (arguments.length === 0 || !time) {
        return null;
      }
      const format = pattern || '{y}-{m}-{d} {h}:{i}:{s}';
      let date;
      if (typeof time === 'object') {
        date = time;
      } else {
        if ((typeof time === 'string') && (/^[0-9]+$/.test(time))) {
          time = parseInt(time);
        } else if (typeof time === 'string') {
          time = time.replace(new RegExp(/-/gm), '/');
        }
        if ((typeof time === 'number') && (time.toString().length === 10)) {
          time = time * 1000;
        }
        date = new Date(time);
      }
      const formatObj = {
        y: date.getFullYear(),
        m: date.getMonth() + 1,
        d: date.getDate(),
        h: date.getHours(),
        i: date.getMinutes(),
        s: date.getSeconds(),
        a: date.getDay()
      };
      const time_str = format.replace(/{(y|m|d|h|i|s|a)+}/g, (result, key) => {
        let value = formatObj[key];
        // Note: getDay() returns 0 on Sunday
        if (key === 'a') { return ['日', '一', '二', '三', '四', '五', '六'][value]; }
        if (result.length > 0 && value < 10) {
          value = '0' + value;
        }
        return value || 0;
      });
      return time_str;
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.mb8 {
  margin-bottom: 8px;
}
</style>
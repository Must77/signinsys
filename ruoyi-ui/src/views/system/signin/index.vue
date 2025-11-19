<template>
  <div class="app-container">
    <!-- 顶部查询 -->
    <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="80px">
      <el-form-item label="签到标题">
                <el-input v-model="queryParams.title" placeholder="请输入签到标题" clearable style="width: 200px;" />
              </el-form-item>
              <el-form-item label="课程名称">
                <el-select 
                  v-model="queryParams.courseId" 
                  placeholder="请选择课程" 
                  clearable 
                  filterable
                  style="width: 200px;"
                  @change="handleQuery"
                >
                  <el-option
                    v-for="course in courseOptions"
                    :key="course.courseId"
                    :label="course.courseName"
                    :value="course.courseId"
                  />
                </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleQuery"  v-hasPermi="['system:signin:list']">搜索</el-button>
        <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 工具栏 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          v-hasPermi="['system:signin:add']"
          type="primary"
          plain
          icon="el-icon-plus"
          @click="handleAdd"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          v-hasPermi="['system:signin:edit']"
          type="success"
          plain
          icon="el-icon-edit"
          :disabled="single"
          @click="handleUpdate"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          v-hasPermi="['system:signin:remove']"
          type="danger"
          plain
          icon="el-icon-delete"
          :disabled="multiple"
          @click="handleDelete"
        >删除</el-button>
      </el-col>
    </el-row>

    <!-- 按状态分类展示 -->
    <el-tabs v-model="activeTab" @tab-click="handleTabClick">
      <el-tab-pane label="全部" name="all">
        <el-table v-loading="loading" :data="signinList" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="55" />
          <el-table-column prop="signinId" label="ID" width="80" />
          <el-table-column prop="title" label="签到标题" />
          <el-table-column prop="courseName" label="课程名称" />
          <el-table-column prop="deptName" label="班级名称" />
          <el-table-column prop="startTime" label="开始时间" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.startTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="endTime" label="结束时间" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.endTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="100">
            <template slot-scope="scope">
              <el-tag v-if="calculateStatus(scope.row) === '0'">未开始</el-tag>
              <el-tag type="success" v-else-if="calculateStatus(scope.row) === '1'">进行中</el-tag>
              <el-tag type="danger" v-else-if="calculateStatus(scope.row) === '2'">已结束</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="220">
            <template slot-scope="scope">
              <!-- 签到按钮已删除 -->
              <el-button
                v-hasPermi="['system:signin:result']"
                size="mini"
                type="text"
                @click="handleResult(scope.row)"
              >查看结果</el-button>
              <el-button
                v-hasPermi="['system:signin:export']"
                size="mini"
                type="text"
                @click="handleExport(scope.row)"
              >导出签到表</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      
      <el-tab-pane label="未开始" name="0">
        <el-table v-loading="loading" :data="getStatusFilteredData('0')" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="55" />
          <el-table-column prop="signinId" label="ID" width="80" />
          <el-table-column prop="title" label="签到标题" />
          <el-table-column prop="courseName" label="课程名称" />
          <el-table-column prop="deptName" label="班级名称" />
          <el-table-column prop="startTime" label="开始时间" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.startTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="endTime" label="结束时间" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.endTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="100">
            <template slot-scope="scope">
              <el-tag v-if="calculateStatus(scope.row) === '0'">未开始</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="220">
            <template slot-scope="scope">
              <el-button
                v-hasPermi="['system:signin:result']"
                size="mini"
                type="text"
                @click="handleResult(scope.row)"
              >查看结果</el-button>
              <el-button
                v-hasPermi="['system:signin:export']"
                size="mini"
                type="text"
                @click="handleExport(scope.row)"
              >导出签到表</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      
      <el-tab-pane label="进行中" name="1">
        <el-table v-loading="loading" :data="getStatusFilteredData('1')" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="55" />
          <el-table-column prop="signinId" label="ID" width="80" />
          <el-table-column prop="title" label="签到标题" />
          <el-table-column prop="courseName" label="课程名称" />
          <el-table-column prop="deptName" label="班级名称" />
          <el-table-column prop="startTime" label="开始时间" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.startTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="endTime" label="结束时间" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.endTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="100">
            <template slot-scope="scope">
              <el-tag type="success" v-if="calculateStatus(scope.row) === '1'">进行中</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="220">
            <template slot-scope="scope">
              <el-button
                v-hasPermi="['system:signin:result']"
                size="mini"
                type="text"
                @click="handleResult(scope.row)"
              >查看结果</el-button>
              <el-button
                v-hasPermi="['system:signin:export']"
                size="mini"
                type="text"
                @click="handleExport(scope.row)"
              >导出签到表</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      
      <el-tab-pane label="已结束" name="2">
        <el-table v-loading="loading" :data="getStatusFilteredData('2')" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="55" />
          <el-table-column prop="signinId" label="ID" width="80" />
          <el-table-column prop="title" label="签到标题" />
          <el-table-column prop="courseName" label="课程名称" />
          <el-table-column prop="deptName" label="班级名称" />
          <el-table-column prop="startTime" label="开始时间" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.startTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="endTime" label="结束时间" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.endTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="100">
            <template slot-scope="scope">
              <el-tag type="danger" v-if="calculateStatus(scope.row) === '2'">已结束</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="220">
            <template slot-scope="scope">
              <el-button
                v-hasPermi="['system:signin:result']"
                size="mini"
                type="text"
                @click="handleResult(scope.row)"
              >查看结果</el-button>
              <el-button
                v-hasPermi="['system:signin:export']"
                size="mini"
                type="text"
                @click="handleExport(scope.row)"
              >导出签到表</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
    
    <!-- 新增/修改弹窗 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="签到标题" prop="title">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="课程" prop="courseId">
          <el-select v-model="form.courseId" placeholder="请选择课程" @change="handleCourseChange">
            <el-option
              v-for="course in courseOptions"
              :key="course.courseId"
              :label="course.courseName"
              :value="course.courseId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="部门" prop="deptId">
          <el-select v-model="form.deptId" placeholder="请选择部门" :disabled="!form.courseId">
            <el-option
              v-for="course in courseOptions"
              v-if="course.courseId == form.courseId"
              :key="course.courseId"
              :label="course.deptName"
              :value="course.deptId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-date-picker
            v-model="form.startTime"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择开始时间"
          />
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-date-picker
            v-model="form.endTime"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择结束时间"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="open = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </div>
    </el-dialog>

    <!-- 查看结果 - 表格预览 -->
    <el-dialog
      :title="resultTitle"
      :visible.sync="resultDialog"
      width="800px"
      append-to-body
      :close-on-click-modal="false"
    >
      <el-tabs v-model="resultActiveName">
        <el-tab-pane label="已签到" name="signed">
          <el-table :data="pagedTable(signedList, resultPage.signed)" border>
            
            <el-table-column prop="userId" label="用户ID" />
            <el-table-column prop="userName" label="姓名" />
            
            <el-table-column prop="signinTime" label="签到时间" />
          </el-table>
          <pagination
            small
            layout="prev, pager, next"
            :total="resultTotal.signed"
            :page.sync="resultPage.signed"
            :limit="resultPageSize"
            @pagination="() => {}"
          />
        </el-tab-pane>
        <el-tab-pane label="未签到" name="unsigned">
          <el-table :data="pagedTable(unsignedList, resultPage.unsigned)" border>
            <el-table-column prop="userId" label="用户ID" />
            <el-table-column prop="userName" label="姓名" />
            
          </el-table>
          <pagination
            small
            layout="prev, pager, next"
            :total="resultTotal.unsigned"
            :page.sync="resultPage.unsigned"
            :limit="resultPageSize"
            @pagination="() => {}"
          />
        </el-tab-pane>
      </el-tabs>
      <div slot="footer">
        <el-button @click="resultDialog = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { 
  listSignin, 
  getSignin, 
  delSignin, 
  addSignin, 
  updateSignin, 
  getResult,
  exportSigninRecord
} from "@/api/system/signin";
import { listDeptCourse } from "@/api/system/deptCourse";

export default {
  name: "Signin",
  data() {
    return {
      // 遮罩层
      loading: false,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 总条数
      total: 0,
      // 签到表格数据
      signinList: [],
      // 课程选项
      courseOptions: [],
      // 当前激活的tab
      activeTab: 'all',
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        title: undefined
      },
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 表单参数
      form: {
        signinId: undefined,
        title: "",
        courseId: "",
        deptId: "",
        startTime: "",
        endTime: ""
      },
      // 表单校验
      rules: {
        title: [{ required: true, message: "签到标题不能为空", trigger: "blur" }],
        courseId: [{ required: true, message: "课程ID不能为空", trigger: "blur" }],
        deptId: [{ required: true, message: "班级ID不能为空", trigger: "blur" }],
        startTime: [{ required: true, message: "开始时间不能为空", trigger: "blur" }],
        endTime: [{ required: true, message: "结束时间不能为空", trigger: "blur" }]
      },
      // 查看结果 - 表格预览
      resultDialog: false,
      resultTitle: "",
      resultActiveName: "signed",
      signedList: [],
      unsignedList: [],
      resultTotal: { signed: 0, unsigned: 0 },
      resultPage: { signed: 1, unsigned: 1 },
      resultPageSize: 10
    };
  },
  computed: {
    // 根据状态过滤的签到列表
    filteredSigninList() {
      if (this.activeTab === 'all') {
        return this.signinList;
      }
      return this.signinList.filter(item => item.status === this.activeTab);
    }
  },
  watch: {
  },
  created() {
    this.getList();
    this.getCourseList();
  },
  methods: {
    // 根据状态获取过滤后的数据
    getStatusFilteredData(status) {
      return this.signinList.filter(item => this.calculateStatus(item) === status);
    },
    // 实时计算签到状态
    calculateStatus(row) {
      const now = new Date();
      const startTime = new Date(row.startTime);
      const endTime = new Date(row.endTime);
      
      if (now < startTime) {
        return '0'; // 未开始
      } else if (now > endTime) {
        return '2'; // 已结束
      } else {
        return '1'; // 进行中
      }
    },
    // tab切换处理
    handleTabClick(tab) {
      // 刷新当前tab的数据
      this.getList();
    },
    // 表格分页计算
    pagedTable(list, page) {
      const start = (page - 1) * this.resultPageSize;
      return list.slice(start, start + this.resultPageSize);
    },
    // 查询列表
    getList() {
      this.loading = true;
      listSignin(this.queryParams).then(res => {
        this.signinList = res.rows || [];
        this.total = res.total || 0;
        this.loading = false;
      }).catch(() => { this.loading = false; });
    },
    // 获取课程列表
    getCourseList() {
      listDeptCourse().then(res => {
        this.courseOptions = res.rows || [];
      });
    },
    // 课程选择变化处理
    handleCourseChange(courseId) {
      this.form.deptId = "";
      if (courseId) {
        const selectedCourse = this.courseOptions.find(course => course.courseId == courseId);
        if (selectedCourse) {
          this.form.deptId = selectedCourse.deptId;
        }
      }
    },
    // 搜索
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    // 重置
    resetQuery() {
      this.queryParams.title = "";
      this.handleQuery();
    },
    // 多选
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.signinId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    // 新增
    handleAdd() {
      this.form = {
        signinId: undefined,
        title: "",
        courseId: "",
        deptId: "",
        startTime: "",
        endTime: ""
      };
      this.open = true;
      this.title = "新增签到";
    },
    // 修改
    handleUpdate(row) {
      const signinId = (row && row.signinId) || this.ids[0];
      if (!signinId) return;
      getSignin(signinId).then(res => {
        this.form = Object.assign({}, res.data || {});
        this.open = true;
        this.title = "修改签到";
      });
    },
    // 提交
    submitForm() {
      this.$refs["formRef"].validate(valid => {
        if (valid) {
          if (this.form.signinId) {
            updateSignin(this.form).then(() => {
              this.$message.success("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addSignin(this.form).then(() => {
              this.$message.success("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    // 删除
    handleDelete(row) {
      const ids = row && row.signinId ? [row.signinId] : this.ids;
      if (!ids.length) return;
      this.$confirm("确认删除选中的签到记录吗？", "提示", { type: "warning" })
        .then(() => delSignin(ids.toString()))
        .then(() => {
          this.$message.success("删除成功");
          this.getList();
        })
        .catch(() => {});
    },
    // 查看结果 - 表格预览
    handleResult(row) {
      if (!row?.signinId) return;
      getResult(row.signinId).then(res => {
        const data = res.data || {};
        this.resultTitle = `「${row.title}」签到结果`;
        this.signedList = data.signed || [];
        this.unsignedList = data.unsigned || [];
        this.resultTotal = {
          signed: this.signedList.length,
          unsigned: this.unsignedList.length
        };
        this.resultPage = { signed: 1, unsigned: 1 };
        this.resultDialog = true;
      });
    },
    // 导出签到表
    handleExport(row) {
      const signinId = row.signinId;
      this.$modal.confirm('确认导出"' + row.title + '"的签到表吗？').then(() => {
        return exportSigninRecord(signinId);
      }).then(response => {
        const fileName = "签到表_" + row.title + "_" + this.parseTime(new Date(), '{y}{m}{d}') + ".xlsx";
        const blob = new Blob([response]);
        const link = document.createElement("a");
        link.href = window.URL.createObjectURL(blob);
        link.download = fileName;
        link.click();
        window.URL.revokeObjectURL(link.href);
      }).catch(() => {});
    }
  }
};
</script>

<style scoped>
.mb8 { margin-bottom: 8px; }
.result-dialog { white-space: pre-wrap; word-break: break-all; }
</style>
<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>课程作业管理 - {{ courseName }}</span>
      </div>

      <!-- 作业操作 -->
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAdd" 
                  v-hasPermi="['system:deptCourse:assignment:publish']">发布作业</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" icon="el-icon-delete" size="mini" :disabled="multiple"
            @click="handleDelete" v-hasPermi="['system:deptCourse:assignment:remove']">删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="info" icon="el-icon-back" size="mini" @click="goBack">返回</el-button>
        </el-col>
      </el-row>

      <!-- 作业列表 -->
      <el-table :data="assignmentList" v-loading="loading" style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="assignmentId" label="作业ID" width="80" />
        <el-table-column prop="assignmentTitle" label="作业标题" />
        <el-table-column prop="assignmentDescribe" label="作业描述" />
        <el-table-column prop="startTime" label="开始时间" width="160">
          <template slot-scope="scope">
            <span>{{ scope.row.startTime }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="endTime" label="结束时间" width="160">
          <template slot-scope="scope">
            <span>{{ scope.row.endTime }}</span>
          </template>
        </el-table-column>
        <!-- <el-table-column prop="deadline" label="截止时间" width="160">
          <template slot-scope="scope">
          <span>{{ scope.row.deadline }}</span>
          </template>
        </el-table-column> -->
        <el-table-column prop="createTime" label="创建时间" width="160">
          <template slot-scope="scope">
            <span>{{ scope.row.createTime }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleViewSubmissions(scope.row)" v-hasPermi="['system:deptCourse:assignment:check']">查看提交</el-button>
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:deptCourse:assignment:edit']">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['system:deptCourse:assignment:remove']">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
        @pagination="getList" />

    </el-card>

    <!-- 添加或修改作业对话框 -->
    <el-dialog :title="assignmentForm.title" :visible.sync="assignmentForm.open" width="600px" append-to-body>
      <el-form ref="assignmentForm" :model="assignmentForm.form" :rules="assignmentForm.rules" label-width="100px">
        <el-form-item label="作业标题" prop="assignmentTitle">
          <el-input v-model="assignmentForm.form.assignmentTitle" placeholder="请输入作业标题" />
        </el-form-item>
        <el-form-item label="作业描述" prop="assignmentDescribe">
          <el-input v-model="assignmentForm.form.assignmentDescribe" type="textarea" placeholder="请输入作业描述" />
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-date-picker
            v-model="assignmentForm.form.startTime"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择开始时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-date-picker
            v-model="assignmentForm.form.endTime"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择结束时间">
          </el-date-picker>
        </el-form-item>
        <!-- <el-form-item label="截止时间" prop="deadline">
          <el-date-picker
            v-model="assignmentForm.form.deadline"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            placeholder="请选择截止时间">
          </el-date-picker>
        </el-form-item> -->
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitAssignmentForm">确 定</el-button>
        <el-button @click="cancelAssignmentForm">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 作业提交情况对话框 -->
    <el-dialog title="作业提交情况" :visible.sync="submission.open" width="800px" append-to-body>
      <el-tabs v-model="submission.activeTab">
        <el-tab-pane label="已提交" name="submitted">
          <el-table :data="submission.submittedList" v-loading="submission.loading" style="width: 100%">
            <el-table-column prop="userName" label="学生姓名" width="120" />
            <!-- <el-table-column prop="submitTime" label="提交时间" width="160">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.submitTime) }}</span>
              </template>
            </el-table-column> -->
            <el-table-column prop="fileName" label="提交文件名" />
            <!-- <el-table-column prop="fileType" label="文件类型" width="100" />
            <el-table-column prop="fileSize" label="文件大小" width="120">
              <template slot-scope="scope">
                <span>{{ scope.row.fileSize }} 字节</span>
              </template>
            </el-table-column> -->
            <el-table-column label="操作" width="100">
              <template slot-scope="scope">
                <el-button size="mini" type="text" @click="handleDownloadSubmission(scope.row)">下载</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="未提交" name="unsubmitted">
          <el-table :data="submission.unsubmittedList" v-loading="submission.loading" style="width: 100%">
            
            <el-table-column prop="userId" label="学生ID" width="120" />
            <el-table-column prop="userName" label="学生姓名" width="120" />
            <!-- <el-table-column prop="createTime" label="加入时间" width="160">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.createTime) }}</span>
              </template>
            </el-table-column> -->
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
  </div>
</template>

<script>
import { listCourseAssignment, getCourseAssignment, addCourseAssignment, updateCourseAssignment, delCourseAssignment, getCourseAssignmentSubmissions } from "@/api/system/courseAssignment";
import { getDeptCourse } from "@/api/system/deptCourse"; // 导入获取课程详情的接口
import { parseTime } from "@/utils";

export default {
  name: "AssignmentManage",
  props: {
    courseId: {
      type: Number,
      required: true
    },
    courseName: {
      type: String,
      default: ''
    }
    // 移除了 deptId prop
  },
  data() {
    return {
      loading: false,
      assignmentList: [],
      total: 0,
      ids: [],
      single: true,
      multiple: true,
      courseDeptId: null, // 存储从课程信息中获取的部门ID
      assignmentForm: {
        title: "",
        open: false,
        form: {
          assignmentId: undefined,
          courseId: undefined,
          deptId: undefined,
          assignmentTitle: "",
          assignmentDescribe: "",
          startTime: "",
          endTime: "",
          deadline: ""
        },
        rules: {
          assignmentTitle: [
            { required: true, message: "作业标题不能为空", trigger: "blur" }
          ],
          assignmentDescribe: [
            { required: true, message: "作业描述不能为空", trigger: "blur" }
          ],
          startTime: [
            { required: true, message: "开始时间不能为空", trigger: "blur" }
          ],
          endTime: [
            { required: true, message: "结束时间不能为空", trigger: "blur" }
          ]
          // deadline: [
          //   { required: true, message: "截止时间不能为空", trigger: "blur" }
          // ]
        }
      },
      submission: {
        open: false,
        loading: false,
        activeTab: "submitted",
        submittedList: [],
        unsubmittedList: [],
        assignmentId: null
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        courseId: null
      }
    };
  },

  created() {
    // 设置查询参数中的课程ID
    this.queryParams.courseId = this.courseId;
    // 获取课程信息以获取部门ID
    this.getCourseInfo();
    // 根据课程ID查询作业列表
    this.getList();
  },
  
  methods: {
    parseTime,
    
    /** 获取课程信息 */
    getCourseInfo() {
      // 如果有获取课程详情的接口
      if (typeof getCourse === 'function') {
        getCourse(this.courseId).then(res => {
          if (res.data && res.data.deptId) {
            this.courseDeptId = res.data.deptId;
          } else {
            console.warn('课程信息中未找到部门ID，将尝试其他方法');
            this.tryAlternativeDeptId();
          }
        }).catch(() => {
          console.warn('获取课程信息失败，将尝试其他方法获取部门ID');
          this.tryAlternativeDeptId();
        });
      } else {
        console.warn('没有获取课程信息的接口，将尝试其他方法获取部门ID');
        this.tryAlternativeDeptId();
      }
    },
    
    /** 尝试其他方法获取部门ID */
    tryAlternativeDeptId() {
      // 方法1: 从用户信息中获取（如果适用）
      if (this.$store.getters && this.$store.getters.deptId) {
        this.courseDeptId = this.$store.getters.deptId;
        console.log('从用户信息中获取部门ID:', this.courseDeptId);
        return;
      }
      
      // 方法2: 如果已有作业列表，从第一个作业中获取部门ID
      if (this.assignmentList.length > 0 && this.assignmentList[0].deptId) {
        this.courseDeptId = this.assignmentList[0].deptId;
        console.log('从作业列表中获取部门ID:', this.courseDeptId);
        return;
      }
      
      // 方法3: 使用默认值
      // 注意：这个值需要根据你的数据库实际情况来定，确保这个部门ID在数据库中存在
      this.courseDeptId = 100; // 设置为一个合理的默认部门ID
      console.warn('使用默认部门ID:', this.courseDeptId);
    },
    
    goBack() {
      this.$emit('close');
    },

    /** 查询作业列表 */
    getList() {
      this.loading = true;
      // 确保传递课程ID参数，只获取指定课程的作业
      if (this.courseId) {
        this.queryParams.courseId = this.courseId;
      }

      listCourseAssignment(this.queryParams).then(res => {
        this.assignmentList = res.rows || [];
        this.total = res.total || 0;
        this.loading = false;
        
        // 调试：检查作业数据中的时间字段
    if (this.assignmentList.length > 0) {
      console.log('作业列表数据:', this.assignmentList);
      console.log('第一条作业的时间字段:', {
        startTime: this.assignmentList[0].startTime,
        endTime: this.assignmentList[0].endTime,
        deadline: this.assignmentList[0].deadline,
        createTime: this.assignmentList[0].createTime
      });
    }
        // 如果还没有获取到部门ID，尝试从作业列表中获取
        if (!this.courseDeptId && this.assignmentList.length > 0 && this.assignmentList[0].deptId) {
          this.courseDeptId = this.assignmentList[0].deptId;
          console.log('从作业列表中获取部门ID:', this.courseDeptId);
        }
        
        // 如果仍然没有部门ID，尝试其他方法
        if (!this.courseDeptId) {
          this.tryAlternativeDeptId();
        }
      }).catch(() => { 
        this.loading = false; 
        this.$message.error('获取作业列表失败');
      });
    },
    
    /** 发布作业 */
    handleAdd() {
      // 检查是否已获取到部门ID
      if (!this.courseDeptId) {
        this.$message.error('无法确定所属部门，请稍后重试或联系管理员');
        return;
      }
      
      this.assignmentForm.open = true;
      this.assignmentForm.title = "发布作业";
      this.assignmentForm.form = {
        assignmentId: undefined,
        courseId: this.courseId,
        deptId: this.courseDeptId,
        assignmentTitle: "",
        assignmentDescribe: "",
        startTime: "",
        endTime: "",
        deadline: ""
      };
    },

    /** 修改作业 */
    handleUpdate(row) {
      // 检查是否已获取到部门ID
      if (!this.courseDeptId) {
        this.$message.error('无法确定所属部门，请稍后重试或联系管理员');
        return;
      }
      
      this.assignmentForm.open = true;
      this.assignmentForm.title = "修改作业";
      this.assignmentForm.form = {
        assignmentId: row.assignmentId,
        courseId: this.courseId,
        deptId: this.courseDeptId,
        assignmentTitle: row.assignmentTitle,
        assignmentDescribe: row.assignmentDescribe,
        startTime: row.startTime,
        endTime: row.endTime,
        deadline: row.deadline
      };
    },
    
    /** 提交发布/修改表单 */
    submitAssignmentForm() {
      this.$refs.assignmentForm.validate(valid => {
        if (valid) {
          // 检查部门ID
          if (!this.assignmentForm.form.deptId) {
            this.$message.error('缺少部门ID，无法提交作业');
            return;
          }
          
          // 如果是新增作业
          if (!this.assignmentForm.form.assignmentId) {
            // 检查课程ID是否存在
            if (!this.courseId) {
              this.$message.error("缺少课程ID");
              return;
            }
            
            // 调用新增接口
            addCourseAssignment(this.assignmentForm.form).then(response => {
              this.$message.success("发布成功");
              this.assignmentForm.open = false;
              this.getList();
            }).catch(err => {
              this.$message.error("发布失败: " + (err.message || '未知错误'));
              console.error('发布作业失败:', err);
            });
          } else {
            // 修改作业信息
            updateCourseAssignment(this.assignmentForm.form).then(response => {
              this.$message.success("修改成功");
              this.assignmentForm.open = false;
              this.getList();
            }).catch(err => {
              this.$message.error("修改失败: " + (err.message || '未知错误'));
              console.error('修改作业失败:', err);
            });
          }
        }
      });
    },
    
    /** 取消发布/修改表单 */
    cancelAssignmentForm() {
      this.assignmentForm.open = false;
      this.resetAssignmentForm();
    },
    
    /** 重置发布/修改表单 */
    resetAssignmentForm() {
      this.assignmentForm.form = {
        assignmentId: undefined,
        courseId: this.courseId,
        deptId: this.courseDeptId,
        assignmentTitle: "",
        assignmentDescribe: "",
        startTime: "",
        endTime: "",
        deadline: ""
      };
      if (this.$refs.assignmentForm) {
        this.$refs.assignmentForm.resetFields();
      }
    },
    
    /** 删除作业 */
    handleDelete(row) {
      const assignmentIds = row.assignmentId || this.ids;
      this.$confirm('是否确认删除作业编号为"' + assignmentIds + '"的数据项？', '提示', {
        type: 'warning'
      }).then(() => {
        return delCourseAssignment(assignmentIds);
      }).then(() => {
        this.getList();
        this.$message.success("删除成功");
      }).catch(() => {});
    },
    
    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.assignmentId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    
    /** 查看作业提交情况 */
    handleViewSubmissions(row) {
      this.submission.open = true;
      this.submission.assignmentId = row.assignmentId;
      this.getSubmissionList(row.assignmentId);
    },
    
    /** 获取作业提交列表 */
    getSubmissionList(assignmentId) {
      this.submission.loading = true;
      getCourseAssignmentSubmissions(assignmentId).then(response => {
        this.submission.submittedList = response.data.submitted || [];
        this.submission.unsubmittedList = response.data.unsubmitted || [];
        this.submission.loading = false;
      }).catch(() => {
        this.submission.loading = false;
        this.$message.error('获取作业提交情况失败');
      });
    },
    
    /** 下载作业提交文件 */
    handleDownloadSubmission(row) {
      // 直接创建一个a标签来下载文件，避免使用POST方法
      const link = document.createElement('a');
      link.href = row.filePath;
      link.download = row.fileName || 'download';
      link.style.display = 'none';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
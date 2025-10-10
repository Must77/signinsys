<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>课程资源管理 - {{ courseName }}</span>
      </div>

      <!-- 上传资源 -->
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button type="primary" icon="el-icon-upload" size="mini" @click="handleUpload" v-hasPermi="['system:deptCourse:resource:upload']">上传资源</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" icon="el-icon-delete" size="mini" :disabled="multiple"
            @click="handleDelete" v-hasPermi="['system:deptCourse:resource:remove']">删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="info" icon="el-icon-back" size="mini" @click="goBack">返回</el-button>
        </el-col>
      </el-row>

      <!-- 资源列表 -->
      <el-table :data="resourceList" v-loading="loading" style="width: 100%" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="resourceId" label="资源主键ID" width="80" />
        <el-table-column prop="courseId" label="课程ID" width="80" />
        <el-table-column prop="fileName" label="原始文件名" />
        <el-table-column prop="filePath" label="文件路径">
          <template slot-scope="scope">
            <el-link :href="scope.row.filePath" target="_blank">{{ scope.row.fileName }}</el-link>
          </template>
        </el-table-column>
        <el-table-column prop="fileType" label="文件类型" width="100" />
        <el-table-column prop="fileSize" label="文件大小(字节)" width="120" />
        <el-table-column prop="createTime" label="创建时间" width="160">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
        @pagination="getList" />

    </el-card>

    <!-- 上传/修改资源对话框 -->
    <el-dialog :title="upload.title" :visible.sync="upload.open" width="500px" append-to-body>
      <el-form ref="uploadForm" :model="upload.form" :rules="upload.rules" label-width="80px">
        <el-form-item label="资源文件">
          <el-upload class="upload-demo" drag :action="uploadUrl" :headers="upload.headers"
            :on-success="handleUploadSuccess" :on-error="handleUploadError" :before-upload="beforeUpload"
            :on-change="handleFileChange" :auto-upload="false" :file-list="fileList" ref="upload">
            <i class="el-icon-upload"></i>
            <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
            <div class="el-upload__tip" slot="tip">只能上传jpg/png/pdf/doc/docx/xls/xlsx/ppt/pptx/mp4等文件，且不超过100MB</div>
          </el-upload>
        </el-form-item>
        <el-form-item label="原始文件名" prop="fileName">
          <el-input v-model="upload.form.fileName" placeholder="请输入原始文件名" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="upload.open = false">取消</el-button>
        <el-button type="primary" @click="submitUploadForm">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listCourseResource, addCourseResource, delCourseResource } from "@/api/system/courseResource";
import { uploadFile } from "@/api/system/upload"; // 引入上传文件的API
import { getToken } from "@/utils/auth";

export default {
  name: "CourseResource",
  data() {
    return {
      loading: false,
      resourceList: [],
      total: 0,
      ids: [],
      courseId: null,
      courseName: '',
      single: true,
      multiple: true,
      fileList: [],
      upload: {
        title: "",
        open: false,
        form: {
          resourceId: undefined,
          courseId: undefined,
          fileName: "",
          filePath: "",
          fileType: "",
          fileSize: 0,
          resourceFile: null
        },
        rules: {
          fileName: [
            { required: true, message: "原始文件名不能为空", trigger: "blur" }
          ]
        }
      },
      uploadUrl: "http://117.72.126.104.8080" + "/common/upload",
      headers: { Authorization: "Bearer " + getToken() },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        courseId: null
      }
    };
  },

  created() {
    // 获取路由参数中的课程ID和课程名称
    this.courseId = this.$route.params.courseId;
    this.courseName = this.$route.params.courseName || '';

    // 设置查询参数中的课程ID
    this.queryParams.courseId = this.courseId;

    // 根据课程ID查询资源列表
    this.getList();
  },
  methods: {
    goBack() {
      this.$router.go(-1);
    },

    handleFileChange(file, fileList) {
      // 只保留最新文件
      if (fileList.length > 1) fileList.splice(0, 1);
      // 存文件对象
      this.upload.form.resourceFile = file.raw;
      // 自动填充文件名
      if (!this.upload.form.fileName || this.upload.form.fileName.trim() === '') {
        this.upload.form.fileName = file.name;
      }
    },   /** 查询资源列表 */
    getList() {
      this.loading = true;
      // 确保传递课程ID参数，只获取指定课程的资源
      if (this.courseId) {
        this.queryParams.courseId = this.courseId;
      }

      listCourseResource(this.queryParams).then(res => {
        this.resourceList = res.rows || [];
        this.total = res.total || 0;
        this.loading = false;
      }).catch(() => {
        this.loading = false;
        this.$message.error('获取资源列表失败');
      });
    },
    /** 上传资源 */
    handleUpload() {
      this.upload.open = true;
      this.upload.title = "上传资源";
      this.upload.form = {
        resourceId: undefined,
        courseId: this.courseId,
        fileName: "",
        filePath: "",
        fileType: "",
        fileSize: 0,
        resourceFile: null
      };
    },

    /** 提交上传/修改表单 */
    submitUploadForm() {
      this.$refs["uploadForm"].validate(valid => {
        if (valid) {
          // 检查是否选择了文件
          if (!this.upload.form.resourceFile) {
            this.$modal.msgError("请先选择要上传的文件");
            return;
          }

          // 如果文件名为空，则使用文件的原始名称
          if (!this.upload.form.fileName || this.upload.form.fileName.trim() === '') {
            this.upload.form.fileName = this.upload.form.resourceFile.name;
          }

          // 验证文件大小（最大100MB）
          if (this.upload.form.resourceFile.size > 100 * 1024 * 1024) {
            this.$modal.msgError("文件大小超过限制，请上传小于100MB的文件");
            return;
          }

          // 检查课程ID是否存在
          if (!this.courseId) {
            this.$modal.msgError("课程ID不存在，无法关联资源");
            return;
          }

          // 先上传文件
          const formData = new FormData();
          formData.append("file", this.upload.form.resourceFile);

          uploadFile(formData).then(response => {
            // 后端把字段平铺在根对象，不再包 data
            const fileUrl = response.url || response.fileName || response.fullPath || ''
            const originalName = response.originalFilename || response.newFileName || ''
            if (!fileUrl) {
              throw new Error('上传接口未返回有效文件路径')
            }
            const courseResource = {
              courseId: this.courseId,
              fileName: this.upload.form.fileName || originalName,
              filePath: fileUrl,
              fileType: originalName.substring(originalName.lastIndexOf('.') + 1).toLowerCase(),
              fileSize: this.upload.form.resourceFile.size
            }
            return addCourseResource(courseResource)
          }).then(() => {
            this.$modal.msgSuccess('资源上传成功')
            this.upload.open = false
            this.getList()
          }).catch(err => {
            this.$modal.msgError('上传失败：' + (err.message || err))
          })
        }
      });
    },


    // 文件上传失败处理
    handleUploadError(err, file, fileList) {
      this.$modal.msgError("上传失败");
    },

    // 上传前的处理
    beforeUpload(file) {
      // 可以在这里添加文件类型和大小的验证
      return true;
    },

    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.resourceId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },

    /** 删除按钮操作 */
    handleDelete(row) {
      const resourceIds = row.resourceId || this.ids;
      this.$modal.confirm('是否确认删除资源编号为"' + resourceIds + '"的数据项？').then(function () {
        return delCourseResource(resourceIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => { });
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>课程资源 - {{ courseName }}</span>
        <el-button style="float: right;" type="info" icon="el-icon-back" size="mini" @click="goBack">返回</el-button>
      </div>

      <!-- 资源列表 -->
      <el-table :data="resourceList" v-loading="loading" style="width: 100%">
        <el-table-column prop="resourceId" label="资源ID" width="80" />
        <el-table-column prop="fileName" label="文件名" />
        <el-table-column prop="fileType" label="类型" width="100" />
        <el-table-column prop="fileSize" label="大小(字节)" width="120" />
        <el-table-column prop="createTime" label="创建时间" width="160">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template slot-scope="scope">
            <el-button size="mini" type="primary" @click="handleDownload(scope.row)" v-hasPermi="['system:myCourse:resource:download']">下载</el-button>
            <el-button size="mini" type="success" @click="handlePreview(scope.row)" v-hasPermi="['system:myCourse:resource:preview']">预览</el-button>
          </template>
        </el-table-column>
      </el-table>

    </el-card>
  </div>
</template>

<script>
import { getCourseResource } from "@/api/system/courseResource";
import { parseTime } from "@/utils";

export default {
  name: "MyCourseResource",
  data() {
    return {
      loading: false,
      resourceList: [],
      courseId: null,
      courseName: ''
    };
  },

  created() {
    // 获取路由参数中的课程ID和课程名称
    this.courseId = this.$route.params.courseId || this.$route.query.courseId;
    this.courseName = this.$route.query.courseName || '';

    // 参数验证
    if (!this.courseId) {
      this.$message.error('缺少课程ID，即将返回')
      this.$router.go(-1)
      return
    }

    // 正常拉数据
    this.getList()
  },

  methods: {
    parseTime,

    goBack() {
      this.$router.go(-1);
    },

    /** 查询资源列表 */
    /** 查询资源列表（普通用户专用） */
    getList() {
      this.loading = true
      console.log('【调试】准备调接口，courseId=', this.courseId)
      getCourseResource(this.courseId).then(res => {
        console.log('【调试】接口原始返回', res)
        if (res.code === 200) {
          this.resourceList = res.data ? [res.data] : []
          console.log('【调试】resourceList', this.resourceList)
        } else {
          this.$message.error('获取资源失败：' + res.msg)
          this.resourceList = []
        }
        this.loading = false
      }).catch(err => {
        console.error('【调试】接口异常', err)
        this.$message.error('获取资源异常')
        this.loading = false
      })
    },

    /** 下载资源 */
    handleDownload(row) {
      // 创建一个隐藏的a标签来触发下载
      const link = document.createElement('a');
      link.href = row.filePath;
      link.download = row.fileName;
      link.target = '_blank';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    },

    /** 预览资源 */
    handlePreview(row) {
      // 在新窗口中打开文件进行预览
      window.open(row.filePath, '_blank');
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
<template>
  <div class="app-container home-container">
    <el-row :gutter="20">
      <el-col :span="16">
        <el-card class="welcome-card">
          <div slot="header" class="clearfix">
            <span>系统首页</span>
          </div>
          <div class="welcome">
            <div class="welcome-icon">
              <i class="el-icon-school"></i>
            </div>
            <h2>欢迎使用 中国地质调查局干部培训中心签到系统</h2>
            <p>请选择左侧菜单进行操作</p>
            <!-- <div class="quick-links">
              <el-button type="primary" icon="el-icon-user" @click="$router.push('/system/user')">用户管理</el-button>
              <el-button type="success" icon="el-icon-document" @click="$router.push('/system/dept')">班级管理</el-button>
              <el-button type="warning" icon="el-icon-location-outline" @click="$router.push('/system/signin')">签到管理</el-button>
              <el-button type="danger" icon="el-icon-bell" @click="$router.push('/system/notice')">通知公告</el-button>
            </div> -->
          </div>
        </el-card>
        
        <!-- <el-card class="stats-card" style="margin-top: 20px;">
          <div slot="header" class="clearfix">
            <span>系统统计</span>
          </div>
          <div class="stats-content">
            <el-row :gutter="20">
              <el-col :span="8">
                <div class="stat-item">
                  <div class="stat-icon bg-primary">
                    <i class="el-icon-user"></i>
                  </div>
                  <div class="stat-info">
                    <div class="stat-number">128</div>
                    <div class="stat-label">用户总数</div>
                  </div>
                </div>
              </el-col>
              <el-col :span="8">
                <div class="stat-item">
                  <div class="stat-icon bg-success">
                    <i class="el-icon-school"></i>
                  </div>
                  <div class="stat-info">
                    <div class="stat-number">24</div>
                    <div class="stat-label">班级总数</div>
                  </div>
                </div>
              </el-col>
              <el-col :span="8">
                <div class="stat-item">
                  <div class="stat-icon bg-warning">
                    <i class="el-icon-location-outline"></i>
                  </div>
                  <div class="stat-info">
                    <div class="stat-number">86</div>
                    <div class="stat-label">今日签到</div>
                  </div>
                </div>
              </el-col>
            </el-row>
          </div>
        </el-card> -->
      </el-col>
      
      <el-col :span="8">
        <el-card class="notice-card">
          <div slot="header" class="clearfix">
            <span>通知公告</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="handleMoreNotice">更多</el-button>
          </div>
          <div class="notice-list">
            <el-table 
              :data="noticeList" 
              style="width: 100%" 
              :show-header="false"
              max-height="500"
              v-loading="loading">
              <el-table-column prop="noticeTitle" label="标题">
                <template slot-scope="scope">
                  <el-link type="primary" @click="handleNoticeDetail(scope.row)">{{ scope.row.noticeTitle }}</el-link>
                  <span class="notice-date">{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-card>
        
        <el-card class="system-info-card" style="margin-top: 20px;">
          <div slot="header" class="clearfix">
            <span>系统信息</span>
          </div>
          <div class="system-info">
            <el-descriptions :column="1" size="small">
              <el-descriptions-item label="系统名称">签到系统</el-descriptions-item>
              <el-descriptions-item label="版本号">v3.1.0</el-descriptions-item>
              <el-descriptions-item label="更新时间">2025-11-21</el-descriptions-item>
              <el-descriptions-item label="技术支持">中国地质大学（北京）</el-descriptions-item>
            </el-descriptions>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 公告详情对话框 -->
    <el-dialog :title="noticeDetail.noticeTitle" :visible.sync="openNotice" width="700px" append-to-body>
      <el-form label-width="80px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="公告类型:">
              <dict-tag :options="dict.type.sys_notice_type" :value="noticeDetail.noticeType"/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="创建时间:">
              {{ parseTime(noticeDetail.createTime) }}
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <div class="notice-content" v-html="noticeDetail.noticeContent"></div>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="openNotice = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listNotice } from "@/api/system/notice";
import { parseTime } from "@/utils/ruoyi";

export default {
  name: "Index",
  dicts: ['sys_notice_type'],
  data() {
    return {
      loading: false,
      noticeList: [],
      openNotice: false,
      noticeDetail: {}
    };
  },
  created() {
    this.getNoticeList();
  },
  methods: {
    /** 获取通知公告列表 */
    getNoticeList() {
      this.loading = true;
      listNotice({ pageSize: 5, status: "0" }).then(response => {
        this.noticeList = response.rows;
        this.loading = false;
      }).catch(() => {
        this.loading = false;
      });
    },
    /** 通知公告详情 */
    handleNoticeDetail(row) {
      this.noticeDetail = row;
      this.openNotice = true;
    },
    /** 查看更多通知公告 */
    handleMoreNotice() {
      this.$router.push("/system/notice");
    },
    parseTime(time, pattern) {
      return parseTime(time, pattern);
    }
  }
};
</script>

<style scoped>
.home-container {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 84px);
}

.welcome-card,
.notice-card,
.stats-card,
.system-info-card {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.welcome {
  text-align: center;
  padding: 30px 20px;
}

.welcome-icon {
  font-size: 64px;
  color: #409EFF;
  margin-bottom: 20px;
}

.welcome h2 {
  color: #303133;
  margin-bottom: 15px;
  font-size: 24px;
}

.welcome p {
  color: #606266;
  font-size: 16px;
  margin-bottom: 30px;
}

.quick-links .el-button {
  margin: 0 10px 10px 0;
}

.quick-links .el-button:last-child {
  margin-right: 0;
}

.stats-content {
  padding: 20px 0;
}

.stat-item {
  display: flex;
  align-items: center;
  padding: 15px;
  border-radius: 8px;
  background-color: #fafafa;
  transition: all 0.3s ease;
}

.stat-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
  margin-right: 15px;
}

.stat-icon.bg-primary {
  background: linear-gradient(135deg, #409EFF 0%, #1a73e8 100%);
}

.stat-icon.bg-success {
  background: linear-gradient(135deg, #67C23A 0%, #40981d 100%);
}

.stat-icon.bg-warning {
  background: linear-gradient(135deg, #E6A23C 0%, #c67a1d 100%);
}

.stat-info {
  flex: 1;
}

.stat-number {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

.notice-list {
  padding: 10px 0;
}

.notice-date {
  float: right;
  color: #999;
  font-size: 12px;
}

.notice-content {
  min-height: 200px;
}

.system-info {
  padding: 15px 0;
}

.system-info ::v-deep .el-descriptions__label {
  width: 80px;
}

::v-deep .el-card__header {
  padding: 15px 20px;
  border-bottom: 1px solid #ebeef5;
  font-weight: bold;
  color: #303133;
}

::v-deep .el-card__body {
  padding: 20px;
}
</style>
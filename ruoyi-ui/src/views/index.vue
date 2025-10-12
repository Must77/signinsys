<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="16">
        <el-card>
          <div slot="header" class="clearfix">
            <span>系统首页</span>
          </div>
          <div class="welcome">
            <h2>欢迎使用课程签到管理系统</h2>
            <p>请选择左侧菜单进行操作</p>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="8">
        <el-card>
          <div slot="header" class="clearfix">
            <span>通知公告</span>
          </div>
          <div class="notice-list">
            <el-table 
              :data="noticeList" 
              style="width: 100%" 
              :show-header="false"
              max-height="400"
              v-loading="loading">
              <el-table-column prop="noticeTitle" label="标题">
                <template slot-scope="scope">
                  <el-link type="primary" @click="handleNoticeDetail(scope.row)">{{ scope.row.noticeTitle }}</el-link>
                  <span class="notice-date">{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
                </template>
              </el-table-column>
            </el-table>
            <!-- <div class="notice-more" v-if="noticeList.length > 0">
              <el-link type="primary" @click="handleMoreNotice">查看更多</el-link>
            </div> -->
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
.welcome {
  text-align: center;
  padding: 50px 0;
}

.welcome h2 {
  color: #409EFF;
  margin-bottom: 20px;
}

.welcome p {
  color: #666;
  font-size: 16px;
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

.notice-more {
  text-align: center;
  margin-top: 15px;
  padding-top: 10px;
  border-top: 1px solid #eee;
}
</style>
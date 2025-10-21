<template>
  <div class="mobile-notice">
    <div class="header">
      <el-page-header @back="goBack" content="通知公告">
      </el-page-header>
    </div>
    
    <el-card class="notice-list" v-loading="loading">
      <div v-if="noticeList.length === 0" class="no-data">
        <i class="el-icon-message"></i>
        <p>暂无通知公告</p>
      </div>
      
      <div 
        v-else 
        v-for="notice in noticeList" 
        :key="notice.noticeId" 
        class="notice-item"
        @click="viewNotice(notice)"
      >
        <div class="notice-title">
          <span class="title-text">{{ notice.noticeTitle }}</span>
          <el-tag 
            :type="notice.noticeType === '1' ? 'danger' : 'warning'" 
            size="mini"
            class="notice-type"
          >
            {{ notice.noticeType === '1' ? '紧急' : '一般' }}
          </el-tag>
        </div>
        <div class="notice-info">
          <span class="create-by">{{ notice.createBy }}</span>
          <span class="create-time">{{ parseTime(notice.createTime) }}</span>
        </div>
      </div>
    </el-card>
    
    <!-- 通知详情对话框 -->
    <el-dialog 
      :visible.sync="detailVisible" 
      :title="detailData.noticeTitle"
      width="90%"
      class="notice-detail-dialog"
    >
      <div class="notice-detail">
        <div class="notice-meta">
          <span class="create-by">发布人：{{ detailData.createBy }}</span>
          <span class="create-time">发布时间：{{ parseTime(detailData.createTime) }}</span>
        </div>
        <div class="notice-content" v-html="detailData.noticeContent"></div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { listNotice, getNotice } from "@/api/system/notice";

export default {
  name: "MobileNotice",
  data() {
    return {
      loading: false,
      noticeList: [],
      detailVisible: false,
      detailData: {}
    };
  },
  created() {
    this.getNoticeList();
  },
  methods: {
    /** 查询通知公告列表 */
    getNoticeList() {
      this.loading = true;
      listNotice({ status: "0" }).then(response => {
        this.noticeList = response.rows;
        this.loading = false;
      });
    },
    
    /** 查看详情 */
    viewNotice(row) {
      getNotice(row.noticeId).then(response => {
        this.detailData = response.data;
        this.detailVisible = true;
      });
    },
    
    /** 返回上一页 */
    goBack() {
      this.$router.go(-1);
    }
  }
};
</script>

<style lang="scss" scoped>
.mobile-notice {
  padding: 10px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

.header {
  margin-bottom: 15px;
  
  ::v-deep .el-page-header {
    background: white;
    padding: 10px 15px;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  }
  
  ::v-deep .el-page-header__content {
    font-weight: bold;
    font-size: 16px;
  }
}

.notice-list {
  ::v-deep .el-card__body {
    padding: 0;
  }
}

.no-data {
  text-align: center;
  padding: 40px 20px;
  color: #909399;
  
  i {
    font-size: 48px;
    margin-bottom: 15px;
  }
  
  p {
    font-size: 14px;
  }
}

.notice-item {
  padding: 15px;
  border-bottom: 1px solid #ebeef5;
  cursor: pointer;
  transition: background-color 0.3s;
  
  &:last-child {
    border-bottom: none;
  }
  
  &:active {
    background-color: #f2f6fc;
  }
  
  .notice-title {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
    
    .title-text {
      font-size: 16px;
      font-weight: 500;
      color: #303133;
      flex: 1;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      margin-right: 10px;
    }
    
    .notice-type {
      flex-shrink: 0;
    }
  }
  
  .notice-info {
    display: flex;
    justify-content: space-between;
    font-size: 12px;
    color: #909399;
  }
}

.notice-detail {
  .notice-meta {
    display: flex;
    justify-content: space-between;
    padding: 10px 0;
    border-bottom: 1px solid #ebeef5;
    font-size: 12px;
    color: #909399;
    margin-bottom: 15px;
  }
  
  .notice-content {
    line-height: 1.6;
    font-size: 14px;
    color: #606266;
  }
}

.notice-detail-dialog {
  ::v-deep .el-dialog {
    margin-top: 30px !important;
    max-height: calc(100% - 60px);
    display: flex;
    flex-direction: column;
    
    .el-dialog__body {
      flex: 1;
      overflow-y: auto;
    }
  }
}

@media screen and (max-width: 768px) {
  .mobile-notice {
    padding: 8px;
  }
  
  .notice-item {
    padding: 12px;
  }
  
  .notice-title .title-text {
    font-size: 14px;
  }
}
</style>
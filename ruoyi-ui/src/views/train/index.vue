<template>
  <div class="app-container">
    <h2>培训期管理</h2>
    
    <!-- 标签页 -->
    <el-tabs v-model="activeTab" @tab-click="handleTabClick">
      <el-tab-pane label="课程动态发布" name="coursePublish"></el-tab-pane>
      <el-tab-pane label="签到管理" name="signinManage"></el-tab-pane>
      <el-tab-pane label="进度统计管理" name="progressStats"></el-tab-pane>
      <el-tab-pane label="请假管理" name="leaveManage"></el-tab-pane>
    </el-tabs>

    <!-- 课程动态发布内容 -->
    <div v-show="activeTab === 'coursePublish'">
      <el-card>
        <div slot="header" class="clearfix">
          <span>课程动态发布</span>
        </div>
        <p>这里是课程动态发布的内容区域。</p>
        <p>可以在此处添加课程发布相关的功能，如：</p>
        <ul>
          <li>发布新课程</li>
          <li>编辑已发布课程</li>
          <li>查看课程发布状态</li>
        </ul>
      </el-card>
    </div>

    <!-- 签到管理内容 -->
    <div v-show="activeTab === 'signinManage'">
      <el-card>
        <div slot="header" class="clearfix">
          <span>签到管理</span>
        </div>
        <p>这里是签到管理的内容区域。</p>
        <p>可以在此处添加签到相关的功能，如：</p>
        <ul>
          <li>创建签到任务</li>
          <li>查看签到记录</li>
          <li>导出签到数据</li>
        </ul>
      </el-card>
    </div>

    <!-- 进度统计管理内容 -->
    <div v-show="activeTab === 'progressStats'">
      <el-card>
        <div slot="header" class="clearfix">
          <span>进度统计管理</span>
        </div>
        <p>这里是进度统计管理的内容区域。</p>
        <p>可以在此处添加学习进度统计相关的功能，如：</p>
        <ul>
          <li>查看学员学习进度</li>
          <li>生成学习报告</li>
          <li>导出统计数据</li>
        </ul>
      </el-card>
    </div>

    <!-- 请假管理内容 -->
    <div v-show="activeTab === 'leaveManage'">
      <el-card>
        <div slot="header" class="clearfix">
          <span>请假管理</span>
        </div>
        <p>这里是请假管理的内容区域。</p>
        <p>可以在此处添加请假相关的功能，如：</p>
        <ul>
          <li>查看请假申请</li>
          <li>审批请假请求</li>
          <li>请假记录查询</li>
        </ul>
      </el-card>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TrainManager',
  data() {
    return {
      activeTab: 'coursePublish' // 默认激活第一个标签页
    }
  },
  methods: {
    handleTabClick(tab) {
      // 标签页切换时的处理逻辑
      console.log('切换到标签页:', tab.name);
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 24px;
}

.clearfix {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
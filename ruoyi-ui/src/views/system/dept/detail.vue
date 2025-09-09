<template>
  <div class="app-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>部门详情</span>
        <el-button style="float: right;" type="primary" @click="goBack">返回</el-button>
      </div>
      
      <el-descriptions :column="1" border>
        <el-descriptions-item label="部门ID">{{ deptInfo.deptId }}</el-descriptions-item>
        <el-descriptions-item label="部门名称">{{ deptInfo.deptName }}</el-descriptions-item>
        <el-descriptions-item label="上级部门">{{ deptInfo.parentName }}</el-descriptions-item>
        <el-descriptions-item label="部门简介">{{ deptInfo.brief }}</el-descriptions-item>
        <el-descriptions-item label="负责人">{{ deptInfo.leader }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ deptInfo.phone }}</el-descriptions-item>
        <el-descriptions-item label="邮箱">{{ deptInfo.email }}</el-descriptions-item>
        <el-descriptions-item label="排序">{{ deptInfo.orderNum }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="deptInfo.status === '0' ? 'success' : 'danger'">
            {{ deptInfo.status === '0' ? '正常' : '停用' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="开始时间">{{ deptInfo.startTime }}</el-descriptions-item>
        <el-descriptions-item label="结束时间">{{ deptInfo.endTime }}</el-descriptions-item>
        <el-descriptions-item label="当前人数">{{ deptInfo.size }}</el-descriptions-item>
        <el-descriptions-item label="容量">{{ deptInfo.cap }}</el-descriptions-item>
        <el-descriptions-item label="自动加入">
          <el-tag :type="deptInfo.autoJoin === '1' ? 'success' : 'info'">
            {{ deptInfo.autoJoin === '1' ? '是' : '否' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="封面图片">
          <el-image 
            v-if="deptInfo.coverURL" 
            :src="deptInfo.coverURL" 
            style="width: 200px; height: 150px"
            fit="cover"
            :preview-src-list="[deptInfo.coverURL]"
          ></el-image>
          <span v-else>暂无图片</span>
        </el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'DeptDetail',
  data() {
    return {
      deptInfo: {
        deptId: null,
        parentId: null,
        ancestors: '',
        deptName: '',
        brief: '',
        coverURL: '',
        orderNum: null,
        leader: '',
        phone: '',
        email: '',
        status: '0',
        parentName: '',
        children: [],
        startTime: '',
        endTime: '',
        size: 0,
        cap: 0,
        autoJoin: '0'
      }
    }
  },
  created() {
    // 模拟从路由参数或API获取数据
    this.loadDeptInfo()
  },
  methods: {
    loadDeptInfo() {
      // 模拟数据，实际项目中应该从API获取或通过路由参数传递
      this.deptInfo = {
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null,
        remark: null,
        deptId: 112,
        parentId: 100,
        ancestors: "0,100",
        deptName: "测试部门001",
        brief: "这是一个用于接口测试的部门",
        coverURL: "http://example.com/cover.png",
        orderNum: 100,
        leader: "张三",
        phone: "13800000000",
        email: "zhangsan@example.com",
        status: "0",
        delFlag: null,
        parentName: "若依科技",
        children: [],
        startTime: "2025-09-01 09:00:00",
        endTime: "2025-12-31 18:00:00",
        size: 30,
        cap: 50,
        autoJoin: "1"
      }
    },
    goBack() {
      // 返回上一页
      this.$router.go(-1)
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.clearfix {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
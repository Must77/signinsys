<template>
  <div class="app-container">
    <!-- 查询条件 -->
    <el-form :model="queryParams" ref="queryForm" :inline="true" label-width="100px">
      <el-form-item label="签到活动名称" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="请输入签到活动名称"
          clearable
          size="small"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="签到状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择签到状态" clearable size="small">
          <el-option label="未开始" value="0"></el-option>
          <el-option label="进行中" value="1"></el-option>
          <el-option label="已结束" value="2"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 数据表格 -->
    <el-table v-loading="loading" :data="signinList" border>
      <el-table-column label="ID" prop="signinId" width="80" />
      <el-table-column label="签到活动名称" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="课程ID" prop="courseId" width="100" />
      <el-table-column label="部门ID" prop="deptId" width="100" />
      <el-table-column label="开始时间" prop="startTime" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.startTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="结束时间" prop="endTime" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.endTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === '0'">未开始</el-tag>
          <el-tag type="success" v-else-if="scope.row.status === '1'">进行中</el-tag>
          <el-tag type="danger" v-else-if="scope.row.status === '2'">已结束</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="签到状态" width="120">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.signed" type="success">已签到</el-tag>
          <el-tag v-else type="warning">未签到</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" align="center">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleSignin(scope.row)"
            :disabled="scope.row.signed || scope.row.status !== '1'"
          >签到</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script>
import { listMySignin, doSigninRecord } from "@/api/system/signin";
import { parseTime } from "@/utils/ruoyi";

export default {
  name: "MySignin",
  components: {
    parseTime
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 总条数
      total: 0,
      // 签到表格数据
      signinList: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        title: undefined,
        status: undefined
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询签到列表 */
    getList() {
      this.loading = true;
      listMySignin(this.queryParams).then(response => {
        this.signinList = response.rows || [];
        this.total = response.total || 0;
        this.loading = false;
      }).catch(() => {
        this.loading = false;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 签到按钮操作 */
    handleSignin(row) {
      const signinId = row.signinId;
      this.$confirm('是否确认进行签到操作?', "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        return doSigninRecord(signinId);
      }).then(() => {
        this.$message.success("签到成功");
        // 更新签到状态
        row.signed = true;
      }).catch(function() {});
    },
    /** 表单重置 */
    resetForm(formName) {
      if (this.$refs[formName]) {
        this.$refs[formName].resetFields();
      }
      this.queryParams = {
        pageNum: 1,
        pageSize: 10,
        title: undefined,
        status: undefined
      };
    },
    // 时间格式化方法
    parseTime(time, pattern) {
      return parseTime(time, pattern);
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
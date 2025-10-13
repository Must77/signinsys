<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="问卷标题" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="请输入问卷标题"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['system:questionna:userList:list']">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="questionnaireList" @selection-change="handleSelectionChange">
      <el-table-column label="问卷ID" align="center" prop="metaId" />
      <el-table-column label="问卷标题" align="center" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="描述" align="center" prop="description" :show-overflow-tooltip="true" />
      <el-table-column label="开始时间" align="center" prop="startTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.startTime) }}</span>
          </template>
      </el-table-column>
      <el-table-column label="结束时间" align="center" prop="endTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.endTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag v-if="isExpired(scope.row)" type="danger">已过期</el-tag>
          <el-tag v-else-if="isNotStarted(scope.row)" type="warning">未开始</el-tag>
          <el-tag v-else type="success">进行中</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            icon="el-icon-edit-outline"
            @click="handleFill(scope.row)"
            :disabled="isExpired(scope.row) || isNotStarted(scope.row)" v-hasPermi="['system:questionna:userList:fill']"
          >填写问卷</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script>
import { listQuestionnaire } from '@/api/system/questionnaire'

export default {
  name: 'UserQuestionnaireList',
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 问卷表格数据
      questionnaireList: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        title: undefined,
        status: undefined
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** 查询问卷列表 */
    getList() {
      this.loading = true
      listQuestionnaire(this.queryParams).then(response => {
        this.questionnaireList = response.data
        this.total = response.total
        this.loading = false
      })
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.metaId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 填写问卷按钮操作 */
    handleFill(row) {
      const metaId = row.metaId
      this.$router.push({
        name: 'UserQuestionnaireSubmit',
        params: { questionnaireMetaId: metaId }
      })
    },
    /** 判断问卷是否已过期 */
    isExpired(row) {
      if (!row.endTime) return false
      const now = new Date()
      const end = new Date(row.endTime)
      return now > end
    },
    /** 判断问卷是否未开始 */
    isNotStarted(row) {
      if (!row.startTime) return false
      const now = new Date()
      const start = new Date(row.startTime)
      return now < start
    }
  }
}
</script>
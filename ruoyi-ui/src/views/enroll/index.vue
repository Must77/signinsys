<template>
  <div class="app-container">
    <!-- 标题 -->
    <h2>报名审核管理</h2>

    <!-- 顶部筛选区域 -->
    <el-card style="margin-bottom: 20px;">
      <div class="filter-container">
        <el-form :inline="true" size="small">
          <el-form-item label="选择课程:">
            <el-select v-model="courseId" placeholder="请选择课程" style="width: 300px;">
              <el-option v-for="course in courses" :key="course.id" :label="course.name" :value="course.id"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadData">加载数据</el-button>
          </el-form-item>
        </el-form>
        <div class="total-count">
          总数: {{ totalCount }} 个申请
        </div>
      </div>
    </el-card>

    <!-- 状态标签页 -->
    <el-tabs v-model="activeTab" @tab-click="handleTabClick">
      <el-tab-pane label="待审核(4)" name="pending"></el-tab-pane>
      <el-tab-pane label="未通过(2)" name="rejected"></el-tab-pane>
      <el-tab-pane label="已通过(80)" name="approved"></el-tab-pane>
    </el-tabs>

    <!-- 表格区域 -->
    <el-card>
      <template #header>
        <span>{{ activeTab === 'pending' ? '待审核申请' : activeTab === 'rejected' ? '未通过申请' : '已通过申请' }}</span>
      </template>

      <el-table :data="tableData" border style="width: 100%">
        <el-table-column label="用户" width="150">
          <template #default="{ row }">
            <div class="user-info">
              <img :src="row.avatar || 'https://via.placeholder.com/40'" alt="头像" class="avatar" />
              <div class="name">{{ row.name }}</div>
              <div class="gender">{{ row.gender }}</div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="联系方式" prop="phone" width="180"></el-table-column>
        <el-table-column label="职位" prop="position" width="180"></el-table-column>
        <el-table-column label="申请时间" prop="applyTime" width="180"></el-table-column>
        <el-table-column label="操作" fixed="right" width="180">
          <template #default="{ row }">
            <el-button 
              size="mini" 
              type="success" 
              @click="handlePass(row)"
              v-if="activeTab === 'pending'"
            >
              通过
            </el-button>
            <el-button 
              size="mini" 
              type="danger" 
              @click="handleReject(row)"
              v-if="activeTab === 'pending'"
            >
              拒绝
            </el-button>
            <el-button
              size="mini"
              type="info"
              @click="handleView(row)"
              v-else
            >
              查看
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 批量操作按钮 -->
      <div class="batch-actions">
        <el-button type="primary" @click="batchPass" v-if="activeTab === 'pending'">
          <i class="el-icon-check"></i> 批量通过
        </el-button>
      </div>
    </el-card>

    <!-- 查看详情对话框 -->
    <el-dialog title="申请详情" :visible.sync="dialogVisible" width="40%" append-to-body>
      <el-form ref="form" :model="detailForm" label-width="80px" v-if="detailForm">
        <el-form-item label="姓名">
          <span>{{ detailForm.name }}</span>
        </el-form-item>
        <el-form-item label="性别">
          <span>{{ detailForm.gender }}</span>
        </el-form-item>
        <el-form-item label="联系方式">
          <span>{{ detailForm.phone }}</span>
        </el-form-item>
        <el-form-item label="职位">
          <span>{{ detailForm.position }}</span>
        </el-form-item>
        <el-form-item label="申请时间">
          <span>{{ detailForm.applyTime }}</span>
        </el-form-item>
        <el-form-item label="状态">
          <span>{{ getStatusCode(detailForm.status) }}</span>
        </el-form-item>
        <el-form-item label="备注" v-if="detailForm.remark">
          <span>{{ detailForm.remark }}</span>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">关 闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'EnrollManager',
  data() {
    return {
      courseId: '',
      activeTab: 'pending',
      totalCount: 0,
      tableData: [],
      courses: [], // 课程列表
      dialogVisible: false,
      detailForm: null
    }
  },
  async mounted() {
    await this.loadCourses() // 加载课程列表
  },
  methods: {
    // 获取课程列表
    async loadCourses() {
      try {
        const res = await axios.get('/api/course/list') // 使用代理自动转发到后端
        this.courses = res.data.data || []
      } catch (error) {
        console.error('获取课程失败:', error)
        this.$message.error('获取课程列表失败')
      }
    },

    // 加载报名数据
    async loadData() {
      if (!this.courseId) {
        this.$message.warning('请先选择课程')
        return
      }

      try {
        const params = {
          courseId: this.courseId,
          status: this.activeTab
        }
        const res = await axios.get('/api/enroll/list', { params })
        const data = res.data.data || []

        this.tableData = data.map(item => ({
          ...item,
          applyTime: new Date(item.applyTime).toLocaleDateString()
        }))
        this.totalCount = res.data.total || 0
      } catch (error) {
        console.error('加载数据失败:', error)
        this.$message.error('加载失败，请检查网络或联系管理员')
      }
    },

    // 切换标签页
    handleTabClick(tab) {
      this.loadData()
    },

    // 通过申请
    async handlePass(row) {
      try {
        await axios.post('/api/enroll/approve', {
          id: row.id,
          status: 'approved'
        })
        this.$message.success('审核通过成功')
        this.loadData() // 刷新数据
      } catch (error) {
        this.$message.error('审核失败')
      }
    },

    // 拒绝申请
    async handleReject(row) {
      try {
        await axios.post('/api/enroll/reject', {
          id: row.id,
          status: 'rejected'
        })
        this.$message.success('拒绝成功')
        this.loadData()
      } catch (error) {
        this.$message.error('拒绝失败')
      }
    },

    // 查看详情
    handleView(row) {
      this.detailForm = row;
      this.dialogVisible = true;
    },

    // 获取状态码对应的文字
    getStatusCode(status) {
      const statusMap = {
        'pending': '待审核',
        'rejected': '未通过',
        'approved': '已通过'
      };
      return statusMap[status] || status;
    },

    // 批量通过
    async batchPass() {
      if (this.tableData.length === 0) {
        this.$message.warning('当前没有可操作的数据');
        return;
      }

      const ids = this.tableData.map(item => item.id)
      try {
        await axios.post('/api/enroll/batchApprove', { ids })
        this.$message.success('批量通过成功')
        this.loadData()
      } catch (error) {
        this.$message.error('批量操作失败')
      }
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 24px;
}

.filter-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.total-count {
  font-size: 12px;
  color: #999;
}

.user-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-bottom: 5px;
}

.name {
  font-weight: bold;
}

.gender {
  font-size: 12px;
  color: #999;
}

.batch-actions {
  margin-top: 20px;
  text-align: right;
}
</style>
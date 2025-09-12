<template>
  <div class="app-container">
    <!-- 班级列表 -->
    <el-table v-loading="loading" :data="classList" row-key="deptId">
      <el-table-column prop="deptName" label="班级名称" />
      <el-table-column prop="leader" label="负责人" />
      <el-table-column prop="phone" label="联系电话" />
      <el-table-column prop="size" label="当前人数" />
      <el-table-column prop="cap" label="班级容量" />
      <el-table-column prop="status" label="状态">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'">
            {{ scope.row.status === '0' ? '正常' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center">
        <template slot-scope="scope">
          <el-button size="mini" type="text" @click="handleView(scope.row)">查看详情</el-button>
          <el-button 
            size="mini" 
            type="text" 
            :disabled="scope.row.status !== '0' || scope.row.size >= scope.row.cap"
            @click="handleApply(scope.row)"
          >
            报名
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 班级详情对话框 -->
    <el-dialog :title="detailTitle" :visible.sync="detailOpen" width="700px" append-to-body>
      <el-card>
        <el-descriptions :column="1" border>
          <el-descriptions-item label="班级ID">{{ detailInfo.deptId }}</el-descriptions-item>
          <el-descriptions-item label="班级名称">{{ detailInfo.deptName }}</el-descriptions-item>
          <el-descriptions-item label="上级部门">{{ detailInfo.parentName }}</el-descriptions-item>
          <el-descriptions-item label="班级简介">{{ detailInfo.brief }}</el-descriptions-item>
          <el-descriptions-item label="负责人">{{ detailInfo.leader }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ detailInfo.phone }}</el-descriptions-item>
          <el-descriptions-item label="邮箱">{{ detailInfo.email }}</el-descriptions-item>
          <el-descriptions-item label="排序">{{ detailInfo.orderNum }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="detailInfo.status === '0' ? 'success' : 'danger'">
              {{ detailInfo.status === '0' ? '正常' : '停用' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="开始时间">{{ detailInfo.startTime }}</el-descriptions-item>
          <el-descriptions-item label="结束时间">{{ detailInfo.endTime }}</el-descriptions-item>
          <el-descriptions-item label="当前人数">{{ detailInfo.size }}</el-descriptions-item>
          <el-descriptions-item label="容量">{{ detailInfo.cap }}</el-descriptions-item>
          <el-descriptions-item label="自动加入">
            <el-tag :type="detailInfo.autoJoin === '1' ? 'success' : 'info'">
              {{ detailInfo.autoJoin === '1' ? '是' : '否' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="封面图片">
            <el-image 
              v-if="detailInfo.coverURL" 
              :src="detailInfo.coverURL" 
              style="width: 200px; height: 150px"
              fit="cover"
              :preview-src-list="[detailInfo.coverURL]"
            ></el-image>
            <span v-else>暂无图片</span>
          </el-descriptions-item>
        </el-descriptions>
      </el-card>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailOpen = false">关闭</el-button>
        <el-button 
          type="primary" 
          :disabled="detailInfo.status !== '0' || detailInfo.size >= detailInfo.cap"
          @click="handleApply(detailInfo)"
        >
          报名该班级
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listDept, getDept } from '@/api/system/dept'
import { addDeptApply } from '@/api/system/deptApply'

export default {
  name: 'ClassDisplay',
  data() {
    return {
      loading: false,
      classList: [],
      detailOpen: false,
      detailTitle: '',
      detailInfo: {
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
    this.getList()
  },
  methods: {
    /** 查询班级列表 */
    getList() {
      this.loading = true
      listDept({ status: '0' }).then(response => {
        // 只显示班级（部门类型）
        this.classList = response.data.filter(item => item.deptId !== 100 && item.deptId !== 101)
        this.loading = false
      })
    },
    
    /** 查看详情 */
    handleView(row) {
      getDept(row.deptId).then(response => {
        this.detailInfo = response.data
        this.detailTitle = '班级详情'
        this.detailOpen = true
      })
    },
    
    /** 报名班级 */
    handleApply(row) {
      this.$confirm(`确认要报名"${row.deptName}"班级吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        const applyData = {
          deptId: row.deptId,
          userId: this.$store.getters.userId
        }
        return addDeptApply(applyData)
      }).then(() => {
        this.$message.success('报名成功，请等待审核')
        this.detailOpen = false
        this.getList()
      }).catch(error => {
        if (error !== 'cancel') {
          this.$message.error('报名失败，请稍后重试')
        }
      })
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
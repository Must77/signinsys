<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="8">
        <el-card>
          <div slot="header">班级列表</div>
          <el-tree
            :data="deptTree"
            :props="defaultProps"
            node-key="id"
            @node-click="handleNodeClick"
            highlight-current
            default-expand-all
          />
        </el-card>
      </el-col>
      <el-col :span="16">
        <el-card>
          <div slot="header">申请报名进入该班级</div>
          <div v-if="currentDept">
            <p>目标班级：<b>{{ currentDept.label }}</b></p>
            <el-input
              type="textarea"
              v-model="remark"
              placeholder="申请备注（可选）"
              :rows="3"
            />
            <div style="margin-top: 12px;">
              <el-button
                type="primary"
                @click="submitApply"
                v-hasPermi="['system:deptApply:add']"
              >
                提交申请
              </el-button>
            </div>
          </div>
          <div v-else>请选择左侧的一个班级。</div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import request from '@/utils/request'
import { addDeptApply } from '@/api/system/deptApply'

// 封装一个 treeselectAll 接口
function treeselectAll() {
  return request({
    url: '/system/dept/treeselectAll',
    method: 'get'
  })
}

export default {
  name: 'DeptApplyUser',
  data() {
    return {
      deptTree: [],
      defaultProps: { children: 'children', label: 'label' },
      currentDept: null,
      remark: ''
    }
  },
  created() {
    this.loadTree()
  },
  methods: {
    loadTree() {
      treeselectAll().then(res => {
        this.deptTree = res.data || []
      })
    },
    handleNodeClick(node) {
      this.currentDept = node
    },
    submitApply() {
      if (!this.currentDept) {
        return this.$modal.msgWarning('请先选择部门')
      }
      addDeptApply({
        deptId: this.currentDept.id,
        remark: this.remark
      }).then(() => {
        this.$modal.msgSuccess('已提交申请，等待管理员审批')
        this.remark = ''
      })
    }
  }
}
</script>

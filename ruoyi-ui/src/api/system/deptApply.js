import request from '@/utils/request'

// 列表
export function listDeptApply(query) {
  return request({
    url: '/system/deptApply/list',
    method: 'get',
    params: query
  })
}


// 用户提交申请
export function addDeptApply(data) {
  return request({
    url: '/system/deptApply',
    method: 'post',
    data: data
  })
}

// 审批通过
export function approveDeptApply(applyId) {
  return request({
    url: `/system/deptApply/${applyId}/approve`,
    method: 'put'
  })
}

// 审批拒绝
export function rejectDeptApply(applyId) {
  return request({
    url: `/system/deptApply/${applyId}/reject`,
    method: 'put'
  })
}

// 删除
export function delDeptApply(applyIds) {
  return request({
    url: `/system/deptApply/${applyIds}`,
    method: 'delete'
  })
}

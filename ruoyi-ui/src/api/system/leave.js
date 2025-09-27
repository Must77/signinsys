import request from '@/utils/request'

// 查询请假列表
export function listLeave(query) {
  return request({
    url: '/system/leave/list',
    method: 'get',
    params: query
  })
}

// 查询请假详细
export function getLeave(leaveId) {
  return request({
    url: '/system/leave/' + leaveId,
    method: 'get'
  })
}

// 新增请假
export function addLeave(data) {
  return request({
    url: '/system/leave',
    method: 'post',
    data: data
  })
}

// 修改请假
export function updateLeave(data) {
  return request({
    url: '/system/leave/' + data.leaveId,
    method: 'put',
    data: data
  })
}

// 删除请假
export function delLeave(leaveId) {
  return request({
    url: '/system/leave/' + leaveId,
    method: 'delete'
  })
}

// 通过请假申请
export function approveLeave(leaveId) {
  return request({
    url: '/system/leave/approve/' + leaveId,
    method: 'put'
  })
}

// 拒绝请假申请
export function rejectLeave(leaveId) {
  return request({
    url: '/system/leave/reject/' + leaveId,
    method: 'put'
  })
}

// 我的请假列表
export function myLeave() {
  return request({
    url: '/system/leave/myleave',
    method: 'get'
  })
}
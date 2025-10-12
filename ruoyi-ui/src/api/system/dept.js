import request from '@/utils/request'

// 查询部门列表
export function listDept(query) {
  return request({
    url: '/system/dept/list',
    method: 'get',
    params: query
  })
}

// 查询部门列表（排除节点）
export function listDeptExcludeChild(deptId) {
  return request({
    url: '/system/dept/list/exclude/' + deptId,
    method: 'get'
  })
}

// 查询部门详细
export function getDept(deptId) {
  return request({
    url: '/system/dept/' + deptId,
    method: 'get'
  })
}

// 新增部门
export function addDept(data) {
  return request({
    url: '/system/dept',
    method: 'post',
    data: data
  })
}

// 修改部门
export function updateDept(data) {
  return request({
    url: '/system/dept',
    method: 'put',
    data: data
  })
}

// 删除部门
export function delDept(deptId) {
  return request({
    url: '/system/dept/' + deptId,
    method: 'delete'
  })
}

// 根据部门ID查询课程列表
export function listDeptCourseByDeptId(deptId) {
  return request({
    url: '/system/deptCourse/list/' + deptId,
    method: 'get'
  })
}

// 用户申请时获取所有部门（忽略数据权限）
export function treeselectAll() {
  return request({
    url: '/system/dept/treeselectAll',
    method: 'get'
  })
}

// 导出部门申请表
export function exportDeptApply(deptId) {
  return request({
    url: '/system/deptApply/export',
    method: 'post',
    data: { deptId },
    responseType: 'blob'
  })
}

// 获取用户申请状态
export function getApplyStatus(deptId) {
  return request({
    url: '/system/dept/applied/' + deptId,
    method: 'get'
  })
}
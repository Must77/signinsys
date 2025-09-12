import request from '@/utils/request'

// 查询部门课程列表
export function listDeptCourse(query) {
  return request({
    url: '/system/deptCourse/list',
    method: 'get',
    params: query
  })
}

// 根据部门ID查询课程列表
export function listDeptCourseByDeptId(deptId) {
  return request({
    url: '/system/deptCourse/list/' + deptId,
    method: 'get'
  })
}

// 查询我的课程（仅本部门）
export function listMyDeptCourse(query) {
  return request({
    url: '/system/deptCourse/myCourse',
    method: 'get',
    params: query
  })
}


// 查询部门课程详细
export function getDeptCourse(courseId) {
  return request({
    url: '/system/deptCourse/' + courseId,
    method: 'get'
  })
}

// 新增部门课程
export function addDeptCourse(data) {
  return request({
    url: '/system/deptCourse',
    method: 'post',
    data: data
  })
}

// 修改部门课程
export function updateDeptCourse(data) {
  return request({
    url: '/system/deptCourse',
    method: 'put',
    data: data
  })
}

// 删除部门课程
export function delDeptCourse(courseId) {
  return request({
    url: '/system/deptCourse/' + courseId,
    method: 'delete'
  })
}
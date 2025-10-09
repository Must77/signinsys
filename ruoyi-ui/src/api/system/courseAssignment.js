import request from '@/utils/request'

// 查询课程作业列表
export function listCourseAssignment(query) {
  return request({
    url: '/system/deptCourse/assignment/list',
    method: 'get',
    params: query
  })
}

// 查询课程作业详细
export function getCourseAssignment(assignmentId) {
  return request({
    url: '/system/deptCourse/assignment/' + assignmentId,
    method: 'get'
  })
}

// 新增课程作业
export function addCourseAssignment(data) {
  return request({
    url: '/system/deptCourse/assignment',
    method: 'post',
    data: data
  })
}

// 修改课程作业
export function updateCourseAssignment(data) {
  return request({
    url: '/system/deptCourse/assignment',
    method: 'put',
    data: data
  })
}

// 删除课程作业
export function delCourseAssignment(assignmentId) {
  return request({
    url: '/system/deptCourse/assignment/' + assignmentId,
    method: 'delete'
  })
}

// 查询课程作业提交情况
export function getCourseAssignmentSubmissions(assignmentId) {
  return request({
    url: '/system/deptCourse/assignment/' + assignmentId + '/submissions',
    method: 'get'
  })
}
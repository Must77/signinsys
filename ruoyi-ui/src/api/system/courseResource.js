import request from '@/utils/request'

// 查询课程资源列表
export function listCourseResource(query) {
  return request({
    url: '/system/deptCourse/resource/list',
    method: 'get',
    data: query
  })
}

// 查询课程资源详细
export function getCourseResource(courseId) {
  return request({
    url: '/system/deptCourse/resource/course/' + courseId,
    method: 'get'
  })
}

// 新增课程资源
export function addCourseResource(data) {
  return request({
    url: '/system/deptCourse/resource',
    method: 'post',
    data: data
  })
}

// 修改课程资源
export function updateCourseResource(data) {
  return request({
    url: '/system/deptCourse/resource',
    method: 'put',
    data: data
  })
}

// 删除课程资源
export function delCourseResource(resourceIds) {
  return request({
    url: '/system/deptCourse/resource/' + resourceIds,
    method: 'delete'
  })
}
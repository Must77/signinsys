import request from '@/utils/request'

// 查询班级列表
export function listClass(query) {
  return request({
    url: '/system/class/list',
    method: 'get',
    params: query
  })
}

// 查询进行中的班级
export function listOngoingClass(query) {
  return request({
    url: '/system/class/ongoing',
    method: 'get',
    params: query
  }).catch(error => {
    console.error('获取进行中的班级失败:', error)
    throw error
  })
}

// 查询已完结的班级
export function listFinishedClass(query) {
  return request({
    url: '/system/class/finished',
    method: 'get',
    params: query
  }).catch(error => {
    console.error('获取已完结的班级失败:', error)
    throw error
  })
}

// 查询待发布的班级
export function listUnpublishedClass(query) {
  return request({
    url: '/system/class/unpublished',
    method: 'get',
    params: query
  }).catch(error => {
    console.error('获取待发布的班级失败:', error)
    throw error
  })
}
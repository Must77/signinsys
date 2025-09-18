import request from '@/utils/request'

// 用户签到
export function doSignin(recordId) {
  return request({
    url: '/system/signinRecord/doSignin/' + recordId,
    method: 'put'
  })
}

// 查看我的所有未签到
export function listMyPendingSignin() {
  return request({
    url: '/system/signinRecord/myPending',
    method: 'get'
  })
}

// 条件查询某个签到记录
export function listSigninRecord(query) {
  return request({
    url: '/system/signinRecord/list',
    method: 'get',
    params: query
  })
}
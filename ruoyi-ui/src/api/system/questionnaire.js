import request from '@/utils/request'

// 新建问卷
export function addQuestionnaire(data) {
  return request({
    url: '/system/questionnaire',
    method: 'post',
    data: data
  })
}

// 通过id查看问卷
export function getQuestionnaire(metaId) {
  return request({
    url: '/system/questionnaire/' + metaId,
    method: 'get'
  })
}

// 条件筛选查看问卷
export function listQuestionnaire(query) {
  return request({
    url: '/system/questionnaire/list',
    method: 'get',
    params: query
  })
}

// 修改问卷
export function updateQuestionnaire(data) {
  return request({
    url: '/system/questionnaire',
    method: 'put',
    data: data
  })
}

// 删除问卷
export function delQuestionnaire(metaId) {
  return request({
    url: '/system/questionnaire/' + metaId,
    method: 'delete'
  })
}

// 查看问卷提交记录
export function listSubmissions(metaId) {
  return request({
    url: '/system/questionnaire/' + metaId + '/submissions',
    method: 'get'
  })
}

// 查看提交的回答
export function getSubmissionAnswers(submissionId) {
  return request({
    url: '/system/questionnaire/answers/' + submissionId,
    method: 'get'
  })
}

// 条件筛选查看提交
export function listSubmission(query) {
  return request({
    url: '/system/questionnaire/submission/list',
    method: 'get',
    params: query
  })
}

// 提交问卷
export function submitQuestionnaire(metaId, data) {
  return request({
    url: '/system/questionnaire/' + metaId + '/submit',
    method: 'post',
    data: answers
  })
}

// 查看指定问卷的题目信息
export function getQuestionnaireItems(metaId) {
  return request({
    url: '/system/questionnaire/' + metaId + '/items',
    method: 'get'
  })
}


// 根据题目ID获取选项（字符串数组）
export function getItemOptions(itemId) {
  return request({
    url: `/system/questionnaire/item/${itemId}/options`,
    method: 'get'
  })
}
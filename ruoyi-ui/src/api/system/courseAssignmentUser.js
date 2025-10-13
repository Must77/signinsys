import request from '@/utils/request'

// 查询待提交的作业
export function listPendingAssignments(courseId) {
  return request({
    url: '/system/deptCourse/assignment/pending',
    method: 'get',
    params: { courseId: courseId }
  })
}

// 查询已提交的作业
export function listMySubmissions(assignmentId) {
  return request({
    url: '/system/deptCourse/assignment/' + assignmentId + '/mySubmission',
    method: 'get'
  })
}

// 提交作业
export function submitAssignment(data) {
  return request({
    url: '/system/deptCourse/assignment/submit',
    method: 'post',
    data: data
  })
}

// 上传作业文件
export function uploadAssignmentFile(data) {
  return request({
    url: '/common/upload',
    method: 'post',
    data: data
  })
}
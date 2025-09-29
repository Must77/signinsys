package com.ruoyi.system.mapper;

import java.util.List;

import com.ruoyi.system.domain.SysCourseAssignmentSubmission;

public interface SysCourseAssignmentSubmissionMapper {
    /** 根据Id查询 **/
    SysCourseAssignmentSubmission selectAssignmentSubmissionById(Long submissionId);
    /** 条件查询 **/
    List<SysCourseAssignmentSubmission> selectAssignmentSubmissionList(SysCourseAssignmentSubmission query);
    /** 查看已提交用户列表 **/
    List<SysCourseAssignmentSubmission> selectSubmittedUsers(Long assignmentId);
    /** 查询未提交用户列表 **/
    List<SysCourseAssignmentSubmission> selectUnsubmittedUsers(Long assignmentId);
    /** 更新作业记录 **/
    int updateAssignmentSubmission(SysCourseAssignmentSubmission submission);
    /** 查询某个用户的待提交作业 **/
    List<SysCourseAssignmentSubmission> selectAssignmentSubmissionPending(Long userId);
    /** 批量插入作业记录 **/
    int batchInsertAssignmentSubmissions(List<SysCourseAssignmentSubmission> submissions);
}

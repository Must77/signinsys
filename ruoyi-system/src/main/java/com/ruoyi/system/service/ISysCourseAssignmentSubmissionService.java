package com.ruoyi.system.service;

import java.util.List;

import com.ruoyi.system.domain.SysCourseAssignmentSubmission;

public interface ISysCourseAssignmentSubmissionService {
    /** 根据Id查询 **/
    public SysCourseAssignmentSubmission selectAssignmentSubmissionById(Long submissionId);

    /** 条件查询 **/
    public List<SysCourseAssignmentSubmission> selectAssignmentSubmissionList(SysCourseAssignmentSubmission query);

    /** 查看某个用户的待提交作业 **/
    public List<SysCourseAssignmentSubmission> selectAssignmentSubmissionPending(Long userId);

    /** 预生成待提交记录 **/
    public void generateAssignmentSubmissions(SysCourseAssignment assignment);

    /** 提交作业 **/
    public int updateAssignmentSubmission(SysCourseAssignmentSubmission submission);

    /** 查询已提交用户列表 **/
    public List<SysCourseAssignmentSubmission> selectSubmittedUsers(Long assignmentId);

    /** 查询未提交用户列表 **/
    public List<SysCourseAssignmentSubmission> selectUnsubmittedUsers(Long assignmentId);
}

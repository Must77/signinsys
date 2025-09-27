package com.ruoyi.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.domain.SysCourseAssignmentSubmission;
import com.ruoyi.system.mapper.SysCourseAssignmentSubmissionMapper;
import com.ruoyi.system.service.ISysCourseAssignmentSubmissionService;

public class SysCourseAssignmentSubmissionServiceImpl implements ISysCourseAssignmentSubmissionService {
    @Autowired
    private SysCourseAssignmentSubmissionMapper submissionMapper;

    /** 根据Id查询 **/
    @Override
    public SysCourseAssignmentSubmission selectAssignmentSubmissionById(Long submissionId) {
        return submissionMapper.selectAssignmentSubmissionById(submissionId);
    }

    /** 条件查询 **/
    @Override
    public List<SysCourseAssignmentSubmission> selectAssignmentSubmissionList(SysCourseAssignmentSubmission query) {
        return submissionMapper.selectAssignmentSubmissionList(query);
    }

    /** 查看某个用户的待提交作业 **/
    @Override
    public List<SysCourseAssignmentSubmission> selectAssignmentSubmissionPending(Long userId){
        return submissionMapper.selectAssignmentSubmissionPending(userId);
    }

    /** 预生成待提交记录 **/
    @Override
    public void generateSubmissionRecords(SysCourseAssignmentSubmission submission){
        // 查询该课程下的所有学生，由于一个班级下是写死的课程，所以使用班级ID
        SysUser query = new SysUser();
        query.setDeptId(submission.getDeptId());
    }

    /** 批量新增待提交记录 **/
    @Override
    public void batchInsertSubmissionRecords(List<SysCourseAssignmentSubmission> submissions){

    }

    /** 提交作业 **/
    @Override
    public int updateAssignmentSubmission(SysCourseAssignmentSubmission submission){
        return submissionMapper.updateAssignmentSubmission(submission);
    }

    /** 查询已提交用户列表 **/
    @Override
    public List<SysCourseAssignmentSubmission> selectSubmittedUsers(Long assignmentId){
        return submissionMapper.selectSubmittedUsers(assignmentId);
    }

    /** 查询未提交用户列表 **/
    @Override
    public List<SysCourseAssignmentSubmission> selectUnsubmittedUsers(Long assignmentId){
        return submissionMapper.selectUnsubmittedUsers(assignmentId);
    }

}

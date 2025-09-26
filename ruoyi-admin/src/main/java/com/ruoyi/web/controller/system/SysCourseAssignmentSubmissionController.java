package com.ruoyi.web.controller.system;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.system.domain.SysCourseAssignmentSubmission;
import com.ruoyi.system.service.ISysCourseAssignmentSubmission;

public class SysCourseAssignmentSubmissionController extends BaseController {
    @Autowired
    private ISysCourseAssignmentSubmission submissionService;

    /**
     * 提交课程作业
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:submit')")
    @PostMapping("/submit")
    public AjaxResult submit(@RequestBody SysCourseAssignmentSubmission submission) {
        return toAjax(submissionService.submitAssignment(submission));
    }

    /**
     * 查看自己待提交的作业
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:pending')")
    @GetMapping("/pending")
    public TableDataInfo myPendingAssignments() {
        startPage();
        List<SysCourseAssignmentSubmission> list = submissionService.getPending(getUserId());
        return getDataTable(list);
    }


    /**
     * 查看自己某个作业活动的提交过的作业
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:pending')")
    @GetMapping("/{assignmentId}/submissions")
    public AjaxResult mySubmittedFileNames(@PathVariable Long assignmentId) {
        List<String> fileNames = submissionService.getSubmitted(getUserId(), assignmentId);
        return AjaxResult.success(fileNames);
    }
    
}

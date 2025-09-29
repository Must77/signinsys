package com.ruoyi.web.controller.system;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.system.domain.SysCourseAssignmentSubmission;
import com.ruoyi.system.domain.SysQuestionnaireSubmission;
import com.ruoyi.system.service.ISysCourseAssignmentSubmissionService;

@RestController
@RequestMapping("/system/deptCourse/assignment")
public class SysCourseAssignmentSubmissionController extends BaseController {
    @Autowired
    private ISysCourseAssignmentSubmissionService submissionService;

    /**
     * 提交课程作业
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:submit')")
    @PostMapping("/submit")
    public AjaxResult submit(@RequestBody SysCourseAssignmentSubmission submission) {
        int rows = submissionService.updateAssignmentSubmission(submission);
        return rows > 0 ? AjaxResult.success("提交成功") : AjaxResult.error("提交失败");
    }

    /**
     * 查看自己待提交的作业
     */
    //@PreAuthorize("@ss.hasPermi('system:assignment:pending')")
    @GetMapping("/pending")
    public TableDataInfo myPendingAssignments() {
        startPage();
        List<SysCourseAssignmentSubmission> list = submissionService.selectAssignmentSubmissionPending(getUserId());
        return getDataTable(list);
    }

    /**
     * 查看自己某个作业活动的提交过的作业
     */
    //@PreAuthorize("@ss.hasPermi('system:assignment:pending')")
    @GetMapping("/{assignmentId}/mySubmission")
    public AjaxResult mySubmittedFileNames(@PathVariable Long assignmentId) {
        SysCourseAssignmentSubmission query = new SysCourseAssignmentSubmission();
        query.setAssignmentId(assignmentId);
        query.setUserId(getUserId());

        List<SysCourseAssignmentSubmission> files = submissionService.selectAssignmentSubmissionList(query);
        return AjaxResult.success(files);
    }
}

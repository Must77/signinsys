package com.ruoyi.web.controller.system;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.system.domain.SysCourseAssignment;
import com.ruoyi.system.domain.SysCourseAssignmentSubmission;
import com.ruoyi.system.service.ISysCourseAssignmentService;
import com.ruoyi.system.service.ISysCourseAssignmentSubmissionService;

@RestController
@RequestMapping("/system/deptCourse/assignment")
public class SysCourseAssignmentController extends BaseController {
    @Autowired
    private ISysCourseAssignmentService assignmentService;

    @Autowired
    private ISysCourseAssignmentSubmissionService submissionService;

    /**
     * 创建作业活动, 同样是对班级中的每个人都预生成一条待提交记录
     * @param assignment
     * @return
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:add')")
    @PostMapping
    public AjaxResult add(@RequestBody SysCourseAssignment assignment) {
        // 创建作业活动
        int row = assignmentService.insertSysCourseAssignment(assignment);
        if (assignment.getAssignmentId() == null) {
            return error("未获取到主键ID，请检查 Mapper 的 useGeneratedKeys 配置");
        }
        // 预生成待提交记录
        submissionService.generateAssignmentSubmissions(assignment);

        return toAjax(row);
    }

    /**
     * 删除作业活动
     * @param assignmentId
     * @return
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:remove')")
    @DeleteMapping("/{assignmentId}")
    public AjaxResult remove(@PathVariable Long assignmentId) {
        return toAjax(assignmentService.deleteSysCourseAssignmentById(assignmentId));
    }

    /**
     * 修改作业活动
     * @param assignment
     * @return
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:edit')")
    @PutMapping
    public AjaxResult edit(@RequestBody SysCourseAssignment assignment) {
        return toAjax(assignmentService.updateSysCourseAssignment(assignment));
    }

    /**
     * 条件筛选查看作业活动
     * @param query 查询条件 
     * @return
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysCourseAssignment query) {
        startPage();
        List<SysCourseAssignment> list = assignmentService.selectSysCourseAssignmentList(query);
        return getDataTable(list);
    }

    /**
     * 根据作业ID获取详细信息
     * @param assignmentId 作业ID
     * @return
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:query')")
    @GetMapping("/{assignmentId}")
    public AjaxResult getInfo(@PathVariable Long assignmentId) {
        return AjaxResult.success(assignmentService.selectSysCourseAssignmentById(assignmentId));
    }

    /**
     * 查看作业的提交情况
     */
    @PreAuthorize("@ss.hasPermi('system:assignment:query')")
    @GetMapping("/{assignmentId}/submissions")
    public AjaxResult getSubmissions(@PathVariable Long assignmentId) 
    {
        List<SysCourseAssignmentSubmission> submitted = submissionService.selectSubmittedUsers(assignmentId);
        List<SysCourseAssignmentSubmission> unsubmitted = submissionService.selectUnsubmittedUsers(assignmentId);

        Map<String, Object> result = new HashMap<>();
        result.put("submitted", submitted);
        result.put("unsubmitted", unsubmitted);
        
        return AjaxResult.success(result);
    }
}

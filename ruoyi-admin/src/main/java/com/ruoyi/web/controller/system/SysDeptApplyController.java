package com.ruoyi.web.controller.system;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.SysDeptApply;
import com.ruoyi.system.service.ISysDeptApplyService;

@RestController
@RequestMapping("/system/deptApply")
public class SysDeptApplyController extends BaseController {

    @Resource
    private ISysDeptApplyService deptApplyService;

    /** 列表（管理员查看全部） */
    @PreAuthorize("@ss.hasPermi('system:deptApply:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysDeptApply query) {
        startPage();
        List<SysDeptApply> list = deptApplyService.selectDeptApplyList(query);
        return getDataTable(list);
    }

    /** 普通用户提交申请 */
    @Log(title = "部门申请", businessType = BusinessType.INSERT)
    @PreAuthorize("@ss.hasPermi('system:deptApply:add') or hasAnyRole('common','admin')")
    @PostMapping
    public AjaxResult add(@RequestBody SysDeptApply apply) {
        apply.setUserId(SecurityUtils.getUserId()); // 用当前登录人
        return toAjax(deptApplyService.insertDeptApply(apply));
    }

    /** 审批通过 */
    @Log(title = "部门申请-通过", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('system:deptApply:approve')")
    @PutMapping("/{applyId}/approve")
    public AjaxResult approve(@PathVariable Long applyId) {
        return toAjax(deptApplyService.approve(applyId));
    }

    /** 审批拒绝 */
    @Log(title = "部门申请-拒绝", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('system:deptApply:reject')")
    @PutMapping("/{applyId}/reject")
    public AjaxResult reject(@PathVariable Long applyId) {
        return toAjax(deptApplyService.reject(applyId));
    }

    /** 删除（可选） */
    @Log(title = "部门申请-删除", businessType = BusinessType.DELETE)
    @PreAuthorize("@ss.hasPermi('system:deptApply:remove')")
    @DeleteMapping("/{applyIds}")
    public AjaxResult remove(@PathVariable Long[] applyIds) {
        return toAjax(deptApplyService.deleteDeptApplyByIds(applyIds));
    }

    /**
     * 导出部门申请
     * @param response 响应流
     * @param query 查询条件
     * @throws UnsupportedEncodingException 
     */
    @Log(title = "导出报名(部门申请)表单", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('system:deptApply:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, @RequestBody SysDeptApply query) throws UnsupportedEncodingException {
        List<SysDeptApply> list = deptApplyService.selectDeptApplyList(query);
        ExcelUtil<SysDeptApply> util = new ExcelUtil<>(SysDeptApply.class);
        // 在文件名中添加人类可读的时间戳
        String fileName = DateUtils.dateTimeNow("yyyyMMdd_HHmmss") + "_班级申请表.xlsx";
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
        util.exportExcel(response, list, "班级申请表");
    }

}

package com.ruoyi.web.controller.system;

import java.util.Date;
import java.util.List;
import javax.annotation.Resource;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SysLeaveRequest;
import com.ruoyi.system.service.ISysLeaveRequestService;

import io.swagger.annotations.Authorization;

/**
 * 请假申请 Controller
 */
@RestController
@RequestMapping("/system/leave")
public class SysLeaveRequestController extends BaseController
{
    @Resource
    private ISysLeaveRequestService leaveService;

    /**
     * 列表
     * - 管理员 (拥有 system:leave:list 权限) 可查询全部（可在前端传 filter）
     * - 普通用户只能查询自己的（在 controller 中强制）
     */
    @PreAuthorize("@ss.hasPermi('system:leave:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysLeaveRequest query)
    {
        String username = SecurityUtils.getUsername();
        // 非管理员强制查看自己申请
        if (!"admin".equals(username)) {
            query.setUserId(SecurityUtils.getUserId());
        }
        startPage();
        List<SysLeaveRequest> list = leaveService.selectLeaveRequestList(query);
        return getDataTable(list);
    }

    /**
     * 获取详细
     */
    @PreAuthorize("@ss.hasPermi('system:leave:query')")
    @GetMapping("/{leaveId}")
    public AjaxResult getInfo(@PathVariable Long leaveId)
    {
        return AjaxResult.success(leaveService.selectLeaveRequestById(leaveId));
    }

    /**
     * 提交请假（普通用户）
     */
    //@PreAuthorize("@ss.hasPermi('system:leave:add')")
    @Log(title = "请假申请", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysLeaveRequest leave)
    {
        // 填充申请人、部门、默认状态
        leave.setUserId(SecurityUtils.getUserId());
        leave.setDeptId(SecurityUtils.getLoginUser().getUser().getDeptId());
        leave.setStatus("0"); // 待审批
        leave.setCreateBy(SecurityUtils.getUsername());
        leave.setCreateTime(new Date());
        return toAjax(leaveService.insertLeaveRequest(leave));
    }

    /**
     * 审批通过 — 仅有权限的人（admin）
     */
    @PreAuthorize("@ss.hasPermi('system:leave:approve')")
    @Log(title = "请假审批", businessType = BusinessType.UPDATE)
    @PutMapping("/approve/{leaveId}")
    public AjaxResult approve(@PathVariable Long leaveId)
    {
        SysLeaveRequest leave = leaveService.selectLeaveRequestById(leaveId);
        if (leave == null) {
            return AjaxResult.error("记录不存在");
        }
        // TODO: 可在这里添加通知逻辑（发送站内消息 / 邮件）告知申请人审批结果
        return toAjax(leaveService.approve(leaveId));
    }
    
    /**
     * 审批拒绝 — 仅有权限的人（admin）
     */
    @PreAuthorize("@ss.hasPermi('system:leave:approve')")
    @Log(title = "请假审批", businessType = BusinessType.UPDATE)
    @PutMapping("/reject/{leaveId}")
    public AjaxResult reject(@PathVariable Long leaveId)
    {
        SysLeaveRequest leave = leaveService.selectLeaveRequestById(leaveId);
        if (leave == null) {
            return AjaxResult.error("记录不存在");
        }

        // TODO: 可在这里添加通知逻辑（发送站内消息 / 邮件）告知申请人审批结果
        return toAjax(leaveService.reject(leaveId));
    }

    /**
     * 删除（仅 admin 或拥有权限）
     */
    @PreAuthorize("@ss.hasPermi('system:leave:remove')")
    @Log(title = "请假申请-删除", businessType = BusinessType.DELETE)
    @DeleteMapping("/{leaveIds}")
    public AjaxResult remove(@PathVariable Long[] leaveIds)
    {
        return toAjax(leaveService.deleteLeaveRequestByIds(leaveIds));
    }

    /**
     * 我的请假
     */
    //@PreAuthorize("@ss.hasPermi('system:leave:myleave')")
    @GetMapping("/myleave")
    public AjaxResult myleave()
    {
        SysLeaveRequest query = new SysLeaveRequest();
        query.setUserId(getUserId());
        return AjaxResult.success(leaveService.selectLeaveRequestList(query));
    }

    /**
     * 更新请假
     */
    @Authorization("@ss.hasPermi('system:leave:update')")
    @PutMapping("/{leaveId}")
    public AjaxResult update(SysLeaveRequest leave)
    {
        Long leaveId = leave.getLeaveId();
        //leaveService.checkDeptDataScope(leaveId); 
        leave.setUpdateBy(getUsername());
        return toAjax(leaveService.updateLeaveRequest(leave));
    }

}

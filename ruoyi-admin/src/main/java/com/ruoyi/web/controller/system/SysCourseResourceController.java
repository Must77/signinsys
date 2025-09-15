package com.ruoyi.web.controller.system;

import java.util.List;
import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SysCourseResource;
import com.ruoyi.system.service.ISysCourseResourceService;

/**
 * 课程资源管理（PPT/PDF/IMG）
 */
@RestController
@RequestMapping("/system/deptCourse/resource")
public class SysCourseResourceController extends BaseController {

    @Autowired
    private ISysCourseResourceService resourceService;

    /**
     * 管理端分页列表（需要权限）
     */
    @PreAuthorize("@ss.hasPermi('system:deptCourse:resource:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysCourseResource query) {
        startPage();
        List<SysCourseResource> list = resourceService.selectCourseResourceList(query);
        return getDataTable(list);
    }

    /**
     * 管理端/前端按 resourceId 获取详情
     */
    @PreAuthorize("@ss.hasPermi('system:deptCourse:resource:query')")
    @GetMapping("/{resourceId}")
    public AjaxResult getInfo(@PathVariable Long resourceId) {
        return AjaxResult.success(resourceService.selectCourseResourceById(resourceId));
    }

    /**
     * 按 courseId 查询所有资源（供普通用户“我的课程/课程详情”使用） —— 不分页
     */
    @GetMapping("/course/{courseId}")
    public AjaxResult getByCourse(@PathVariable Long courseId) {
        List<SysCourseResource> list = resourceService.selectResourcesByCourseId(courseId);
        return AjaxResult.success(list);
    }

    /**
     * 新增资源（仅 admin）—— 前端先用 /common/upload 上传文件得到 url，再调用此接口保存元数据
     */
    @PreAuthorize("@ss.hasPermi('system:deptCourse:resource:add')")
    @Log(title = "课程资源", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysCourseResource resource) {
        // 只有 admin 能写资源（也可通过权限表控制）
        String username = SecurityUtils.getUsername();
        if (!"admin".equals(username)) {
            return error("只有管理员可以新增课程资源");
        }
        resource.setCreateBy(getUsername());
        return toAjax(resourceService.insertCourseResource(resource));
    }

    /**
     * 删除资源（逻辑删除，可批量）—— 仅 admin
     */
    @PreAuthorize("@ss.hasPermi('system:deptCourse:resource:remove')")
    @Log(title = "课程资源", businessType = BusinessType.DELETE)
    @DeleteMapping("/{resourceIds}")
    public AjaxResult remove(@PathVariable Long[] resourceIds) {
        String username = SecurityUtils.getUsername();
        if (!"admin".equals(username)) {
            return error("只有管理员可以删除课程资源");
        }
        return toAjax(resourceService.deleteCourseResourceByIds(resourceIds));
    }
}

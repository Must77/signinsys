package com.ruoyi.web.controller.system;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SysDeptCourse;
import com.ruoyi.system.service.ISysDeptCourseService;

/**
 * 部门课程管理
 *
 * 权限说明：
 * 1) 普通用户：
 *    - 只能查询自己部门的课程
 *    - 不允许新增 / 修改 / 删除
 * 2) admin用户：
 *    - 可以查看任意部门课程
 *    - 可以新增 / 修改 / 删除
 */
@RestController
@RequestMapping("/system/deptCourse")
public class SysDeptCourseController extends BaseController
{
    @Autowired
    private ISysDeptCourseService deptCourseService;

    /**
     * 查询课程列表
     * - admin：可传 deptId 指定部门；未传则查询全部
     */
    @PreAuthorize("@ss.hasPermi('system:deptCourse:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysDeptCourse query)
    {
        /* 通过数据库来权限控制， 因此controller中删除判断逻辑 */
        // String username = SecurityUtils.getUsername();

        // // 如果不是 admin，则强制限定在自己部门
        // if (!"admin".equals(username)) {
        //     Long myDeptId = SecurityUtils.getLoginUser().getUser().getDeptId();
        //     query.setDeptId(myDeptId);
        // }

        startPage();
        List<SysDeptCourse> list = deptCourseService.selectDeptCourseList(query);
        return getDataTable(list);
    }

    /**
     * 查询当前用户所在部门的课程
     */
    @PreAuthorize("@ss.hasPermi('system:myCourse:list')")
    @GetMapping("/myCourse")
    public TableDataInfo listMyDeptCourse()
    {
        startPage();
        Long deptId = getLoginUser().getUser().getDeptId();
        SysDeptCourse deptCourse = new SysDeptCourse();
        deptCourse.setDeptId(deptId);
        List<SysDeptCourse> list = deptCourseService.selectDeptCourseList(deptCourse);
        return getDataTable(list);
    }

    
    
    /**
     * 按部门ID查看课程（仅 admin 可以使用）
     */
    @PreAuthorize("@ss.hasPermi('system:deptCourse:query')")
    @GetMapping("/list/{deptId}")
    public AjaxResult listByDept(@PathVariable Long deptId)
    {
        String username = SecurityUtils.getUsername();
        // if (!"admin".equals(username)) {
        //     return error("仅管理员可以按部门查看课程");
        // }
        SysDeptCourse query = new SysDeptCourse();
        query.setDeptId(deptId);
        List<SysDeptCourse> list = deptCourseService.selectDeptCourseList(query);
        return success(list);
    }

    /**
     * 新增课程（仅 admin）
     */
    @PreAuthorize("@ss.hasPermi('system:deptCourse:add')")
    @Log(title = "部门课程", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysDeptCourse course)
    {
        String username = SecurityUtils.getUsername();
        // if (!"admin".equals(username)) {
        //     return error("只有管理员可以添加课程");
        // }
        if (course.getDeptId() == null) {
            return error("新增课程必须指定部门");
        }
        return toAjax(deptCourseService.insertDeptCourse(course));
    }

    /**
     * 修改课程（仅 admin）
     */
    @PreAuthorize("@ss.hasPermi('system:deptCourse:edit')")
    @Log(title = "部门课程", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysDeptCourse course)
    {
        String username = SecurityUtils.getUsername();
        // if (!"admin".equals(username)) {
        //     return error("只有管理员可以修改课程");
        // }
        return toAjax(deptCourseService.updateDeptCourse(course));
    }

    /**
     * 删除课程（仅 admin，可批量）
     */
    @PreAuthorize("@ss.hasPermi('system:deptCourse:remove')")
    @Log(title = "部门课程", businessType = BusinessType.DELETE)
    @DeleteMapping("/{courseIds}")
    public AjaxResult remove(@PathVariable Long[] courseIds)
    {
        String username = SecurityUtils.getUsername();
        // if (!"admin".equals(username)) {
        //     return error("只有管理员可以删除课程");
        // }
        return toAjax(deptCourseService.deleteDeptCourseByIds(courseIds));
    }
}
	
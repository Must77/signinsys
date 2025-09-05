package com.ruoyi.web.controller.system;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.SysCourseSignin;
import com.ruoyi.system.service.ISysCourseSigninService;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 课程签到 Controller
 * 
 * @author 
 */
@RestController
@RequestMapping("/system/signin")
public class SysCourseSigninController extends BaseController
{
    @Autowired
    private ISysCourseSigninService signinService;

    /**
     * 查询课程签到列表（admin）
     */
    @GetMapping("/list/{signinId}")
    public TableDataInfo list(SysCourseSignin query)
    {
        startPage();
        List<SysCourseSignin> list = signinService.selectCourseSigninList(query);
        return getDataTable(list);
    }

    /**
     * 获取课程签到详细信息（admin）
     */
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return AjaxResult.success(signinService.selectCourseSigninById(id));
    }

    /**
     * 新增课程签到（admin发布签到）
     */
    @Log(title = "课程签到", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysCourseSignin signin)
    {
        return toAjax(signinService.insertCourseSignin(signin));
    }

    /**
     * 修改课程签到（admin）
     */
    @Log(title = "课程签到", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysCourseSignin signin)
    {
        return toAjax(signinService.updateCourseSignin(signin));
    }

    /**
     * 删除课程签到（admin）
     */
    @Log(title = "课程签到", businessType = BusinessType.DELETE)
    @DeleteMapping("/{signinIds}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(signinService.deleteCourseSigninByIds(ids));
    }

    /**
     * 用户进行签到（普通用户）
     * 这里需要在数据库中保存一条签到记录（签到表 + 签到记录表）
     */
    @PostMapping("/doSignin/{signinId}")
    public AjaxResult doSignin(@PathVariable Long signinId)
    {
        // TODO: 这里建议在 SysCourseSigninRecordService 中实现签到逻辑
        // 1. 判断是否在有效时间段内
        // 2. 判断该用户是否已经签过到
        // 3. 插入一条签到记录（signinId, userId, deptId, signTime）
        return AjaxResult.success("签到成功");
    }

    /**
     * 查看某个签到的签到结果（admin）
     * 已签到人员 / 未签到人员
     */
    @GetMapping("/result/{signinId}")
    public AjaxResult result(@PathVariable Long signinId)
    {
        // TODO: 需要实现 SysCourseSigninRecordService
        // List<SysUser> signedUsers = recordService.selectSignedUsers(signinId);
        // List<SysUser> unsignedUsers = recordService.selectUnsignedUsers(signinId);
        // return AjaxResult.success(Map.of("signed", signedUsers, "unsigned", unsignedUsers));
        return AjaxResult.success("签到结果查询接口（待实现）");
    }
}

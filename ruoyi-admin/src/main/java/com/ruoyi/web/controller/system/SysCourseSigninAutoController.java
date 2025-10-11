package com.ruoyi.web.controller.system;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.SysCourseSignin;
import com.ruoyi.system.domain.SysCourseSigninAuto;
import com.ruoyi.system.domain.SysDeptCourse;
import com.ruoyi.system.service.ISysCourseSigninAutoService;
import com.ruoyi.system.service.ISysCourseSigninRecordService;
import com.ruoyi.system.service.ISysCourseSigninService;
import com.ruoyi.system.service.ISysDeptCourseService;

@RestController
@RequestMapping("/system/deptCourse")
@Component("courseSigninAutoUtil")
public class SysCourseSigninAutoController 
{   
    @Autowired
    private ISysCourseSigninService signinService;

    @Autowired
    private ISysCourseSigninRecordService recordService;

    @Autowired
    private ISysCourseSigninAutoService autoService;

    @Autowired
    private ISysDeptCourseService courseService;

    /** 启用 课程自动发布签到活动 **/
    @PreAuthorize("@ss.hasPermi('system:deptCourse:edit')")
    @GetMapping("/{courseId}/turnonAuto")
    public AjaxResult turnonCourseSigninAuto(@PathVariable Long courseId) {
        SysCourseSigninAuto autoConfig = autoService.selectCourseSigninAutoByCourseId(courseId);
        // 查询是否存在过自动任务
        if(autoConfig == null){
            // 如果不存在自动任务就创建自动任务
            SysCourseSigninAuto newAuto = new SysCourseSigninAuto();
            newAuto.setCourseId(courseId);
            newAuto.setCronExpression("0 0 7 * * ?"); // 默认为早7点
            newAuto.setStatus("0");
        }else{
            // 如果存在自动任务就更改status字段为启用状态
            autoConfig.setStatus("0");
            autoService.updateCourseSigninAuto(autoConfig);
        }
        return AjaxResult.success("课程自动发布签到活动已开启");
    }

    /** 禁止 课程自动发布签到活动**/
    @PreAuthorize("@ss.hasPermi('system:deptCourse:edit')")
    @GetMapping("/{courseId}/turnoffAuto")
    public AjaxResult turnoffCourseSigninAuto(@PathVariable Long courseId) {
        SysCourseSigninAuto autoConfig = autoService.selectCourseSigninAutoByCourseId(courseId);
        // 查询是否存在过自动任务
        if(autoConfig == null){
            // 如果不存在自动任务就创建自动任务
            SysCourseSigninAuto newAuto = new SysCourseSigninAuto();
            newAuto.setCourseId(courseId);
            newAuto.setCronExpression("0 0 7 * * ?"); // 默认为早7点
            newAuto.setStatus("1");
        }else{
            // 如果存在自动任务就更改status字段为禁用状态
            autoConfig.setStatus("1");
            autoService.updateCourseSigninAuto(autoConfig);
        }
        return AjaxResult.success("课程自动发布签到活动已关闭");
    }

    /**
     * 扫描函数
     * 一天只会运行一次
     * 由sys_job中存储的信息触发, 目的是遍历整个sys_course_signin_auto表, 在该表中, 每遇到一条信息就触发一次执行函数
     */
    public void scan(){

    }

    /**
     * 执行函数
     * 一天会运行n次, n为设置了活跃的自动发布签到的课程
     * 执行sys_course_signin_auto中配置的自动任务, 创建signin, 并为课程中(班级中)的所有用户都预生成签到记录record
     */
    public void executeAutoSignin(Long autoId) {
        SysCourseSigninAuto autoConfig = autoService.selectCourseSigninAuto(autoId);

        /** 配置当天的签到活动**/
        SysCourseSignin signin = new SysCourseSignin();
        // 设置课程ID
        signin.setCourseId(autoConfig.getCourseId());
        // 设置部门ID
        SysDeptCourse query = new SysDeptCourse();
        query.setCourseId(autoConfig.getCourseId());
        SysDeptCourse course = courseService.selectDeptCourseList(query).get(0);
        signin.setDeptId(course.getDeptId());
        // 设置签到起止时间, 暂定为当天早晨6点到晚上22点
        Date now = new Date();
        Date startTime = new Date(now.getYear(), now.getMonth(), now.getDate(), 6, 0, 0);
        Date endTime = new Date(now.getYear(), now.getMonth(), now.getDate(), 22, 0, 0);
        signin.setStartTime(startTime);
        signin.setEndTime(endTime);
        // 设置签到标题
        signin.setTitle("签到任务-" + (now.getMonth()+1) + "-" + now.getDate());
        
        /** 生成签到活动 **/
        signinService.insertCourseSignin(signin);
        /** 生成预签到记录 **/
        recordService.generateSigninRecords(signin);
        
    }
}

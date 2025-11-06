package com.ruoyi.system.service.impl;

import org.springframework.stereotype.Service;

import com.ruoyi.system.domain.SysCourseSigninAuto;
import com.ruoyi.system.service.ISysCourseSigninAutoService;

@Service
public class SysCourseSigninAutoImpl implements ISysCourseSigninAutoService {
    /** 根据ID查询自动签到活动任务**/
    public SysCourseSigninAuto selectCourseSigninAuto(Long autoId){
        System.out.println("未实现selectCourseSigninAuto");
        return null;
    }
    /** 根据课程ID查询自动签到活动任务 **/
    public SysCourseSigninAuto selectCourseSigninAutoByCourseId(Long courseId){
        System.out.println("未实现selectCourseSigninAutoByCourseId");
        return null;
    }
    /** 创建自动签到活动任务 **/
    public int insertCourseSigninAuto(SysCourseSigninAuto task){
        System.out.println("未实现insertCourseSigninAuto");
        return 0;
    }
    /** 修改自动签到活动任务 **/
    public int updateCourseSigninAuto(SysCourseSigninAuto task){
        System.out.println("未实现updateCourseSigninAuto");
        return 0;
    }
    /** 删除自动签到活动任务 **/
    public int deleteCourseSigninAuto(Long autoId){
        System.out.println("未实现deleteCourseSigninAuto");
        return 0;
    }
}

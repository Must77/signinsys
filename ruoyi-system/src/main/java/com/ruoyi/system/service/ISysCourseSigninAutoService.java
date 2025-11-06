package com.ruoyi.system.service;

import com.ruoyi.system.domain.SysCourseSigninAuto;

/**
 * 课程自动签到活动 服务层
 * 
 * @author Must77
 */
public interface ISysCourseSigninAutoService {
    /** 根据ID查询自动签到活动任务**/
    public SysCourseSigninAuto selectCourseSigninAuto(Long autoId);
    /** 根据课程ID查询自动签到活动任务 **/
    public SysCourseSigninAuto selectCourseSigninAutoByCourseId(Long courseId);
    /** 创建自动签到活动任务 **/
    public int insertCourseSigninAuto(SysCourseSigninAuto task);
    /** 修改自动签到活动任务 **/
    public int updateCourseSigninAuto(SysCourseSigninAuto task);
    /** 删除自动签到活动任务 **/
    public int deleteCourseSigninAuto(Long autoId);
}

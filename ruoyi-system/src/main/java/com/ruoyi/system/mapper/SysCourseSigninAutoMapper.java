package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysCourseSigninAuto;

/**
 * 课程自动签到任务 数据层
 * 
 * @author Must77
 */
public interface SysCourseSigninAutoMapper {
    /** 根据ID查询自动签到活动任务 **/
    SysCourseSigninAuto selectCourseSigninAutoById(Long autoId);
    /** 根据课程ID查询自动签到活动任务 **/
    SysCourseSigninAuto selectCourseSigninAutoByCourseId(Long courseId);
    /** 新增自动签到活动任务 **/
    int insertCourseSigninAuto(SysCourseSigninAuto task);
    /** 修改自动签到活动任务 **/
    int updateCourseSigninAuto(SysCourseSigninAuto task);
    /** 删除自动签到活动任务 **/
    int deleteCourseSigninAutoByCourseId(Long courseId);
}

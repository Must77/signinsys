package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysCourseResource;

/**
 * 课程资源 数据层
 */
public interface SysCourseResourceMapper
{
    /**
     * 根据ID查询课程资源
     * @param resourceId 课程资源ID
     * @return 课程资源
     */
    SysCourseResource selectCourseResourceById(Long resourceId);

    /**
     * 条件查询课程资源
     * @param query 条件查询
     * @return 课程资源列表
     */
    List<SysCourseResource> selectCourseResourceList(SysCourseResource query);

    /**
     * 用户根据课程来查询课程资源
     * @param courseId
     * @return
     */
    List<SysCourseResource> selectResourcesByCourseId(Long courseId);

    /**
     * 新增课程资源
     * @param resource
     * @return
     */
    int insertCourseResource(SysCourseResource resource);

    /**
     * 修改课程资源
     * @param resource
     * @return
     */
    int updateCourseResource(SysCourseResource resource);

    /**
     * 删除课程资源
     * @param resourceId
     * @return
     */
    int deleteCourseResourceById(Long resourceId);

    /**
     * 删除多个课程资源
     * @param resourceId
     * @return
     */
    int deleteCourseResourceByIds(Long[] resourceIds);
}

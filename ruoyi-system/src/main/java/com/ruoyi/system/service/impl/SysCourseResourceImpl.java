package com.ruoyi.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.ruoyi.system.domain.SysCourseResource;
import com.ruoyi.system.mapper.SysCourseResourceMapper;
import com.ruoyi.system.service.ISysCourseResourceService;

public class SysCourseResourceImpl implements ISysCourseResourceService{
    @Autowired
    private SysCourseResourceMapper resourceMapper;


    /**
     * 根据ID查询课程资源
     * @param resourceId
     * @return 课程资源
     */
    @Override
    public SysCourseResource selectCourseResourceById(Long resourceId){
        return resourceMapper.selectCourseResourceById(resourceId);
    }

    /**
     * 条件查询课程资源
     * @param query
     * @return 课程资源列表
     */
    @Override
    public List<SysCourseResource> selectCourseResourceList(SysCourseResource query){
        return resourceMapper.selectCourseResourceList(query);
    }

    /**
     * 用户根据课程来查看课程资源
     * @param courseId
     * @return 课程资源列表
     */
    @Override
    public List<SysCourseResource> selectResourcesByCourseId(Long courseId){
        return resourceMapper.selectResourcesByCourseId(courseId);
    }

    /**
     * 新增课程资源
     * @param resource
     * @return 影响的行数
     */
    @Override
    public int insertCourseResource(SysCourseResource resource){
        return resourceMapper.insertCourseResource(resource);
    }

    /**
     * 修改课程资源
     * @param resource
     * @return 影响的行数
     */
    @Override
    public int updateCourseResource(SysCourseResource resource){
        return resourceMapper.updateCourseResource(resource);
    }

    /**
     * 删除课程资源
     * @param resourceId
     * @return 影响的行数
     */
    @Override
    public int deleteCourseResourceById(Long resourceId){
        return resourceMapper.deleteCourseResourceById(resourceId);
    }

    /**
     * 批量删除课程资源
     * @param resourceIds
     * @return 影响的行数
     */
    @Override
    public int deleteCourseResourceByIds(Long[] resourceIds){
        return resourceMapper.deleteCourseResourceByIds(resourceIds);
    }
}

package com.ruoyi.system.service;

import java.util.List;

import com.ruoyi.system.domain.SysCourseAssignment;

public interface ISysCourseAssignmentService {
    // 增删改查

    /**
     * 创建作业活动
     * @param assignment
     * @return
     */
    public int insertSysCourseAssignment(SysCourseAssignment assignment);

    /**
     * 删除作业活动
     * @param id
     * @return
     */
    public int deleteSysCourseAssignmentById(Long id);

    /**
     * 修改作业活动
     * @param assignment
     * @return
     */
    public int updateSysCourseAssignment(SysCourseAssignment assignment);

    /**
     * 根据ID查询作业活动
     * @param id
     * @return
     */
    public SysCourseAssignment selectSysCourseAssignmentById(Long id);

    /**
     * 条件筛选查询作业活动
     * @param query
     * @return
     */
    public List<SysCourseAssignment> selectSysCourseAssignmentList(SysCourseAssignment query);
}

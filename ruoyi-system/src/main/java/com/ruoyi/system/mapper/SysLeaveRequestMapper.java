package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysLeaveRequest;

/**
 * 请假申请 数据层
 * @author Must77
 */
public interface SysLeaveRequestMapper
{
    /**
     * 查询请假申请
     */
    SysLeaveRequest selectLeaveRequestById(Long leaveId);

    /**
     * 查询请假申请列表
     */
    List<SysLeaveRequest> selectLeaveRequestList(SysLeaveRequest query);

    /**
     * 新增请假申请
     */
    int insertLeaveRequest(SysLeaveRequest leave);

    /**
     * 修改请假申请
     */
    int updateLeaveRequest(SysLeaveRequest leave);

    /**
     * 删除请假申请（单条）
     */
    int deleteLeaveRequestById(Long leaveId);

    /**
     * 批量删除请假申请
     */
    int deleteLeaveRequestByIds(Long[] leaveIds);
}

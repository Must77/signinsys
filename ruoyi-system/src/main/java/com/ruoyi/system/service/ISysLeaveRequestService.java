package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysLeaveRequest;

/**
 * 请假管理 服务层
 * @author Nust77
 */
public interface ISysLeaveRequestService
{
    /**
     * 根据ID查看请假
     * @param leaveId 请假申请ID
     * @return
     */
    SysLeaveRequest selectLeaveRequestById(Long leaveId);

    /**
     * 条件查询请假申请
     * @param query 查询条件
     * @return
     */
    List<SysLeaveRequest> selectLeaveRequestList(SysLeaveRequest query);

    /**
     * 新增请假申请
     * @param leave 请假申请
     * @return
     */
    int insertLeaveRequest(SysLeaveRequest leave);

    /**
     * 更新请假申请
     * @param leave 请假申请
     * @return
     */
    int updateLeaveRequest(SysLeaveRequest leave);

    /**
     * 删除多条请假申请
     * @param ids
     * @return
     */
    int deleteLeaveRequestByIds(Long[] ids);

    /**
     * 删除单条请假申请
     * @param id
     * @return
     */
    int deleteLeaveRequestById(Long id);

    /**
     * 通过请假
     */
    int approve(Long applyId);

    /**
     * 拒绝请假
     */
    int reject(Long applyId);
}

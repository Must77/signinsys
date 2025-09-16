package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.SysLeaveRequestMapper;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SysLeaveRequest;
import com.ruoyi.system.service.ISysLeaveRequestService;

@Service
public class SysLeaveRequestServiceImpl implements ISysLeaveRequestService
{
    @Autowired
    private SysLeaveRequestMapper leaveMapper;

    @Override
    public SysLeaveRequest selectLeaveRequestById(Long leaveId)
    {
        return leaveMapper.selectLeaveRequestById(leaveId);
    }

    @Override
    public List<SysLeaveRequest> selectLeaveRequestList(SysLeaveRequest query)
    {
        return leaveMapper.selectLeaveRequestList(query);
    }

    @Override
    public int insertLeaveRequest(SysLeaveRequest leave)
    {
        return leaveMapper.insertLeaveRequest(leave);
    }

    @Override
    public int updateLeaveRequest(SysLeaveRequest leave)
    {
        return leaveMapper.updateLeaveRequest(leave);
    }

    @Override
    public int deleteLeaveRequestByIds(Long[] ids)
    {
        return leaveMapper.deleteLeaveRequestByIds(ids);
    }

    @Override
    public int deleteLeaveRequestById(Long id)
    {
        return leaveMapper.deleteLeaveRequestById(id);
    }

    @Override
    public int approve(Long id)
    {
        SysLeaveRequest leave = leaveMapper.selectLeaveRequestById(id);
        if(leave == null)return 0;

        // 通过
        leave.setStatus("1");
        // 谁通过的
        leave.setApproverId(SecurityUtils.getUserId());
        leave.setApproveTime(new Date());
        leave.setUpdateBy(SecurityUtils.getUsername());
        leave.setUpdateTime(new Date());

        return leaveMapper.updateLeaveRequest(leave);
    }

    @Override
    public int reject(Long id)
    {
        SysLeaveRequest leave = leaveMapper.selectLeaveRequestById(id);
        if(leave == null)return 0;

        // 拒绝
        leave.setStatus("2");
        // 谁拒绝的
        leave.setApproverId(SecurityUtils.getUserId());
        leave.setApproveTime(new Date());
        leave.setUpdateBy(SecurityUtils.getUsername());
        leave.setUpdateTime(new Date());

        return leaveMapper.updateLeaveRequest(leave);
    }

}

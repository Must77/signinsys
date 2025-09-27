package com.ruoyi.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ruoyi.system.domain.SysCourseAssignment;
import com.ruoyi.system.mapper.SysCourseAssignmentMapper;
import com.ruoyi.system.service.ISysCourseAssignmentService;

@Service
public class SysCourseAssignmentServiceImpl implements ISysCourseAssignmentService {
    @Autowired
    private SysCourseAssignmentMapper assignmentMapper;


    @Override
    public int insertSysCourseAssignment(SysCourseAssignment assignment) {
        return assignmentMapper.insertSysCourseAssignment(assignment);
    }

    @Override
    public int deleteSysCourseAssignmentById(Long id) {
        return assignmentMapper.deleteSysCourseAssignmentById(id);
    }

    @Override
    public int updateSysCourseAssignment(SysCourseAssignment assignment) {
        return assignmentMapper.updateSysCourseAssignment(assignment);
    }

    @Override
    public SysCourseAssignment selectSysCourseAssignmentById(Long id) {
        return assignmentMapper.selectSysCourseAssignmentById(id);
    }

    @Override
    public List<SysCourseAssignment> selectSysCourseAssignmentList(SysCourseAssignment query) {
        return assignmentMapper.selectSysCourseAssignmentList(query);
    }
}

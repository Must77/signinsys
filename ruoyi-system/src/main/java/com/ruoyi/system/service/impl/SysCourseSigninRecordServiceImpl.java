package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.domain.SysCourseSignin;
import com.ruoyi.system.domain.SysCourseSigninRecord;
import com.ruoyi.system.mapper.SysCourseSigninRecordMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.service.ISysCourseSigninRecordService;

@Service
public class SysCourseSigninRecordServiceImpl implements ISysCourseSigninRecordService {

    @Autowired
    private SysCourseSigninRecordMapper recordMapper;

    @Autowired
    private SysUserMapper userMapper; // 需要根据 deptId 查出学生用户

    /**
     * 根据ID查询课程签到记录
     * @param recordId
     * @return
     */
    @Override
    public SysCourseSigninRecord selectSigninRecordById(Long recordId) {
        return recordMapper.selectSigninRecordById(recordId);
    }

    /**
     * 条件查询签到记录列表
     * @param record 条件
     * @return
     */
    @Override
    public List<SysCourseSigninRecord> selectSigninRecordList(SysCourseSigninRecord record) {
        return recordMapper.selectSigninRecordList(record);
    }

    /**
     * 查看某个用户的待签到记录
     * @param userId 用户id
     */
    @Override
    public List<SysCourseSigninRecord> selectSigninRecordPending(Long userId)
    {
       return recordMapper.selectSigninRecordPending(userId); 
    }

    /**
     * 新增课程签到记录
     * @param record
     * @return
     */
    @Override
    public int insertCourseSigninRecord(SysCourseSigninRecord record) {
        return recordMapper.insertCourseSigninRecord(record);
    }

    /**
     * 批量新增签到记录列表
     * @param records
     * @return
     */
    @Override
    public int batchInsertSigninRecords(List<SysCourseSigninRecord> records) {
        return recordMapper.batchInsertSigninRecords(records);
    }

    /**
     * 修改签到记录状态
     * @param record
     * @return
     */
    @Override
    public int updateSigninRecordStatus(SysCourseSigninRecord record) {
        return recordMapper.updateSigninRecordStatus(record);
    }

    /**
     * 根据签到元数据为该班级下所有学生预生成签到记录
     * @param signin
     */
    @Override
    public void generateSigninRecords(SysCourseSignin signin) {
        // 查询该班级所有学生
        //List<SysUser> students = userMapper.selectUsersByDeptId(signin.getDeptId());
        SysUser query = new SysUser();
        query.setDeptId(signin.getDeptId());
        List<SysUser> students = userMapper.selectUserList(query);

        List<SysCourseSigninRecord> records = new ArrayList<>();
        for (SysUser stu : students) {
            SysCourseSigninRecord r = new SysCourseSigninRecord();
            r.setSigninId(signin.getSigninId());
            r.setUserId(stu.getUserId());
            r.setCourseId(signin.getCourseId());
            r.setStatus("0"); // 未签到
            r.setCreateBy(signin.getCreateBy());
            records.add(r);
        }
        if (!records.isEmpty()) {
            recordMapper.batchInsertSigninRecords(records);
        }
    }

    /**
     * 查询已签到用户列表
     * @param signinId
     * @return
     */
    @Override
    public List<SysCourseSigninRecord> selectSignedUsers(Long signinId) {
        SysCourseSigninRecord query = new SysCourseSigninRecord();
        query.setSigninId(signinId);
        query.setStatus("1"); // 已签到
        return recordMapper.selectSigninRecordList(query);
    }

    /**
     * 查询未签到用户列表
     * @param signinId
     * @return
     */
    @Override
    public List<SysCourseSigninRecord> selectUnsignedUsers(Long signinId) {
        SysCourseSigninRecord query = new SysCourseSigninRecord();
        query.setSigninId(signinId);
        query.setStatus("0"); // 未签到
        return recordMapper.selectSigninRecordList(query);
    }


}

package com.ruoyi.system.service;

import com.ruoyi.system.domain.SysCourseSignin;
import com.ruoyi.system.domain.SysCourseSigninRecord;
import java.util.List;

/**
 * 课程签到记录 服务层
 * 
 * @author Must77
 */
public interface ISysCourseSigninRecordService {
    /**
     * 通过ID查询课程签到记录
     * @param recordId 签到记录ID
     * @return 课程签到记录
     */
    SysCourseSigninRecord selectSigninRecordById(Long recordId);

    /**
     * 条件查询签到记录列表
     * @param record 签到任务查询条件
     * @return 课程签到记录集合
     */
    List<SysCourseSigninRecord> selectSigninRecordList(SysCourseSigninRecord record);

    /**
     * 新增课程签到记录
     * @param record 课程签到记录
     * @return 结果
     */
    int insertCourseSigninRecord(SysCourseSigninRecord record);

    /**
     * 批量新增课程签到记录
     * @param records 课程签到记录集合
     * @return 结果
     */
    int batchInsertSigninRecords(List<SysCourseSigninRecord> records);

    /**
     * 修改课程签到记录
     * @param record 课程签到记录
     * @return 结果
     */
    int updateSigninRecordStatus(SysCourseSigninRecord record);

    /**
     * 根据签到元数据为该班级下所有学生预生成签到记录
     * @param signin 签到元数据
     * @return void
     */
    void generateSigninRecords(SysCourseSignin signin);

    /**
     * 查询已签到用户列表
     * @param signinId
     * @return
     */
    public List<SysCourseSigninRecord> selectSignedUsers(Long signinId);

    /**
     * 查询未签到用户列表
     * @param signinId
     * @return
     */
    public List<SysCourseSigninRecord> selectUnsignedUsers(Long signinId);
}


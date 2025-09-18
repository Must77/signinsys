package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysCourseSigninRecord;
import java.util.List;

/**
 * 课程签到记录 数据层
 * 
 * @author Must77
 */
public interface SysCourseSigninRecordMapper {
    /**
     * 根据ID查询签到记录
     * @param recordId 签到记录ID
     * @return 签到记录
     */
    SysCourseSigninRecord selectSigninRecordById(Long recordId);

    /**
     * 条件查询签到记录列表
     * @param record 查询条件
     * @return 签到记录列表
     */
    List<SysCourseSigninRecord> selectSigninRecordList(SysCourseSigninRecord record);

    /**
     * 查看用户的待签到记录
     * @param userId 用户Id
     * @return
     */
    List<SysCourseSigninRecord> selectSigninRecordPending(Long userId);

    /**
     * 插入单条记录
     * @param record 签到记录
     * @return 影响的行数
     */
    int insertCourseSigninRecord(SysCourseSigninRecord record);

    /**
     * 批量插入签到记录
     * @param records 签到记录列表
     * @return 影响的行数
     */
    int batchInsertSigninRecords(List<SysCourseSigninRecord> records);

    /**
     * 更新签到记录的状态
     * @param record 签到记录
     * @return 影响的行数
     */
    int updateSigninRecordStatus(SysCourseSigninRecord record);

    /**
     * 删除签到记录
     * 没想好要不要做
     */
    int deleteSigninRecordById(Long recordId);
}

package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class SysCourseSigninAuto extends BaseEntity {
    /** 自动签到活动任务ID **/
    private Long autoId;
    /** 课程ID **/
    private Long courseId;
    /** 定时任务设置 表达式 **/
    private String cronExpression;
    /** 状态（0=启用, 1=停用） **/
    private String status;
    /** 删除标志（0存在 2删除） **/
    private String delFlag;
    /** 备注 **/
    private String remark;

    // getter/setter
    public Long getAutoId() { return autoId; }
    public void setAutoId(Long autoId) { this.autoId = autoId; }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public String getCronExpression() { return cronExpression; }
    public void setCronExpression(String cronExpression) { this.cronExpression = cronExpression; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDelFlag() { return delFlag; }
    public void setDelFlag(String delFlag) { this.delFlag = delFlag; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}

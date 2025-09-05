package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class SysCourseSigninRecord extends BaseEntity {
    /** 预生成签到的ID **/
    @Excel(name = "预生成签到的ID")
    private Long id;

    /** 对应的签到任务（签到元数据）的ID **/
    @Excel(name = "对应的签到任务（签到元数据）的ID")
    private Long signinId;

    /** 用户ID **/
    @Excel(name = "用户ID")
    private Long userId;
    // TODO: 将用户ID转换为用户名

    /** 需要签到的课程ID **/
    @Excel(name = "需要签到的课程ID")
    private Long courseId;
    // TODO: 将课程ID转换为课程名字

    /** 签到状态（0未签到，1已签到） **/
    @Excel(name = "签到状态（0未签到，1已签到）")
    private String status;

    /** 签到时间 **/
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "签到时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date signinTime;

    /** 注释 **/
    @Excel(name = "注释")
    private String remark;

    // getter / setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getSigninId() {
        return signinId;
    }

    public void setSigninId(Long signinId) {
        this.signinId = signinId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getSigninTime() {
        return signinTime;
    }

    public void setSigninTime(Date signinTime) {
        this.signinTime = signinTime;
    }

    @Override
    public String getRemark() {
        return remark;
    }

    @Override
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
}

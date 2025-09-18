package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class SysCourseSigninRecord extends BaseEntity {
    /** 预生成签到的ID **/
    @Excel(name = "预生成签到的ID")
    private Long recordId;

    /** 对应的签到任务（签到元数据）的ID **/
    @Excel(name = "对应的签到任务（签到元数据）的ID")
    private Long signinId;

    /** 用户ID **/
    @Excel(name = "用户ID")
    private Long userId;

    /** 需要签到的课程ID **/
    @Excel(name = "需要签到的课程ID")
    private Long courseId;

    /** 签到状态（0未签到，1已签到） **/
    @Excel(name = "签到状态（0未签到，1已签到）")
    private String status;

    /** 签到时间 **/
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "签到时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date signinTime;

    /** 用于前端展示的字段 **/
    private String title;   // 签到活动的标题
    private String courseName;
    private String deptName;
    private String userName;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;


    // getter / setter
    public Long getRecordId() {
        return recordId;
    }

    public void setRecordId(Long id) {
        this.recordId = id;
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}

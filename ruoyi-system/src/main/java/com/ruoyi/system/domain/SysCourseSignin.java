package com.ruoyi.system.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;


public class SysCourseSignin extends BaseEntity{
    /** 签到的ID **/
    private Long signinId;

    /** 课程ID **/
    @Excel(name = "课程ID")
    private Long courseId;

    /** 部门ID **/
    @Excel(name = "部门ID")
    private Long deptId;

    /** 签到标题 **/
    @Excel(name = "签到标题")
    private String title;

    /** 签到开始时间 **/
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "签到开始时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** 签到结束时间 **/
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "签到结束时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    /** 签到任务状态（0未开始，1进行中，2已结束） **/
    @Excel(name = "签到任务状态（0未开始，1进行中，2已结束）")
    private String status;

    /** 删除标记(0存在,2删除) **/
    private String delFlag;

    /** 用于前端显示的字段: 部门名字和课程名字**/
    private String deptName;
    private String courseName;

    // getter/setter
    public Long getSigninId() {
      return signinId;
    }

    public void setSigninId(Long signinId) {
      this.signinId = signinId;
    }

    public Long getCourseId() {
      return courseId;
    }

    public void setCourseId(Long courseId) {
      this.courseId = courseId;
    }

    public Long getDeptId() {
      return deptId;
    }

    public void setDeptId(Long deptId) {
      this.deptId = deptId;
    }

    public String getTitle() {
      return title;
    }

    public void setTitle(String title) {
      this.title = title;
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

    public String getStatus() {
      return status;
    }

    public void setStatus(String status) {
      this.status = status;
    }

    public String getDelFlag() {
      return delFlag;
    }

    public void setDelFlag(String delFlag) {
      this.delFlag = delFlag;
    }

    public String getDeptName() {
      return deptName;
    }

    public void setDeptName(String deptName) {
      this.deptName = deptName;
    }

    public String getCourseName() {
      return courseName;
    }

    public void setCourseName(String courseName) {
      this.courseName = courseName;
    }

    
    
}

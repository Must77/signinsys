package com.ruoyi.system.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.annotation.Excel;

/**
 * 课程作业对象 sys_course_assignment
 * 
 * @author must77
 */
public class SysCourseAssignment extends BaseEntity {
    /** 作业ID */
    @Excel(name = "作业ID")
    private Long assignmentId;
    
    /** 课程ID */
    @Excel(name = "课程ID")
    private Long courseId;

    /** 班级ID **/
    @Excel(name = "班级ID")
    private Long deptId;

    /** 作业标题 */
    @Excel(name = "作业标题")
    private String assignmentTitle;

    /** 作业描述 */
    @Excel(name = "作业描述")
    private String assignmentDescribe;

    /** 截止时间 */
    @Excel(name = "截止时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date deadline;

    /** 开始时间 */
    @Excel(name = "开始时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** 结束时间 */
    @Excel(name = "结束时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    /** 删除标志（0代表存在 2代表删除） */
    @Excel(name = "删除标志")
    private String delFlag;

    /** 创建者 */
    @Excel(name = "创建者")
    private String createBy;
    /** 创建时间 */
    @Excel(name = "创建时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;
    /** 更新者 */
    @Excel(name = "更新者")
    private String updateBy;
    /** 更新时间 */
    @Excel(name = "更新时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;
    /** 备注 */
    @Excel(name = "备注")
    private String remark;

    /** 课程名称（展示用） */
    @Excel(name = "课程名称")
    private String courseName;

    // getter/setter
    public Long getAssignmentId() {
        return assignmentId;
    }


    public void setAssignmentId(Long assignmentId) {
        this.assignmentId = assignmentId;
    }


    public Long getCourseId() {
        return courseId;
    }


    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }


    public String getAssignmentTitle() {
        return assignmentTitle;
    }


    public void setAssignmentTitle(String assignmentTitle) {
        this.assignmentTitle = assignmentTitle;
    }


    public String getAssignmentDescribe() {
        return assignmentDescribe;
    }


    public void setAssignmentDescribe(String assignmentDescribe) {
        this.assignmentDescribe = assignmentDescribe;
    }


    public Date getDeadline() {
        return deadline;
    }


    public void setDeadline(Date deadline) {
        this.deadline = deadline;
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


    public String getDelFlag() {
        return delFlag;
    }


    public void setDelFlag(String delFlag) {
        this.delFlag = delFlag;
    }


    public String getCreateBy() {
        return createBy;
    }


    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }


    public Date getCreateTime() {
        return createTime;
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }


    public String getUpdateBy() {
        return updateBy;
    }


    public void setUpdateBy(String updateBy) {
        this.updateBy = updateBy;
    }


    public Date getUpdateTime() {
        return updateTime;
    }


    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }


    public String getRemark() {
        return remark;
    }


    public void setRemark(String remark) {
        this.remark = remark;
    }


    public String getCourseName() {
        return courseName;
    }


    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }


    public Long getDeptId() {
        return deptId;
    }


    public void setDeptId(Long deptId) {
        this.deptId = deptId;
    }

    
    
}

package com.ruoyi.system.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;

public class SysQuestionnaireSubmission {

    /** 提交ID **/
    @Excel(name = "提交ID")
    private Long submissionId;

    /** 问卷ID **/
    @Excel(name = "问卷ID")
    private Long metaId;

    /** 用户ID **/
    @Excel(name = "用户ID")
    private Long userId;

    /** 部门ID **/
    @Excel(name = "部门ID")
    private Long deptId;

    /** 提交时间 **/
    @Excel(name = "提交时间")
    private Date submitTime;

    /** 提交来源IP地址 **/
    @Excel(name = "提交来源IP地址")
    private String ipAddr;

    /** 备注 **/
    @Excel(name = "备注")
    private String remark;

    /** 创建时间 **/
    @Excel(name = "创建时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    /** 创建人 **/
    @Excel(name = "创建人")
    private String createBy;

    /** 更新时间 **/
    @Excel(name = "更新时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;

    /** 更新人 **/
    @Excel(name = "更新人")
    private String updateBy;

    /** 删除标志（0代表存在 2代表删除） */
    @Excel(name = "删除标志")
    private String delFlag;

    // getters/setters
    public Long getSubmissionId() {
        return submissionId;
    }
    public void setSubmissionId(Long submissionId) {
        this.submissionId = submissionId;
    }
    public Long getMetaId() {
        return metaId;
    }
    public void setMetaId(Long metaId) {
        this.metaId = metaId;
    }
    public Long getUserId() {
        return userId;
    }
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    public Long getDeptId() {
        return deptId;
    }
    public void setDeptId(Long deptId) {
        this.deptId = deptId;
    }
    public Date getSubmitTime() {
        return submitTime;
    }
    public void setSubmitTime(Date submitTime) {
        this.submitTime = submitTime;
    }
    public String getIpAddr() {
        return ipAddr;
    }
    public void setIpAddr(String ipAddr) {
        this.ipAddr = ipAddr;
    }
    public String getRemark() {
        return remark;
    }
    public void setRemark(String remark) {
        this.remark = remark;
    }
    public Date getCreateTime() {
        return createTime;
    }
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
    public String getCreateBy() {
        return createBy;
    }
    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }
    public Date getUpdateTime() {
        return updateTime;
    }
    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
    public String getUpdateBy() {
        return updateBy;
    }
    public void setUpdateBy(String updateBy) {
        this.updateBy = updateBy;
    }
    public String getDelFlag() {
        return delFlag;
    }
    public void setDelFlag(String delFlag) {
        this.delFlag = delFlag;
    }
    
}

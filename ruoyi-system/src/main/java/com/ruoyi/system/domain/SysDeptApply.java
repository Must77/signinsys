package com.ruoyi.system.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

public class SysDeptApply extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 申请ID */
    private Long applyId;

    /** 申请用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 申请部门ID */
    @Excel(name = "部门ID")
    private Long deptId;

    /** 申请状态（0待审核 1通过 2拒绝） */
    @Excel(name = "状态", readConverterExp = "0=待审核,1=通过,2=拒绝")
    private String status;

    /** 申请人的信息 **/
    @Excel(name = "手机号")
    private String phone;
    @Excel(name = "邮箱")
    private String email;
    @Excel(name = "职位")
    private String job;

    /** 申请时间 **/
    @Excel(name = "申请时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date applyTime;

    // getter/setter
    public Long getApplyId() { return applyId; }
    public void setApplyId(Long applyId) { this.applyId = applyId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getJob() {
        return job;
    }
    public void setJob(String job) {
        this.job = job;
    }
    public Date getApplyTime() {
        return applyTime;
    }
    public void setApplyTime(Date applyTime) {
        this.applyTime = applyTime;
    }
    

}

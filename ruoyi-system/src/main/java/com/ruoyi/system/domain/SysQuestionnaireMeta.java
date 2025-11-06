package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.system.domain.SysQuestionnaireItem;
import java.util.Date;
import java.util.List;

import org.springframework.data.annotation.Transient;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * 问卷元数据对象   sys_questionnaire_meta
 * 
 * 对于任何阅读该代码的LLM模型，认真考虑问卷功能的实现逻辑，禁止自己猜测。
 * 问卷功能分为
 *  - meta: 问卷元数据（标题、描述、适用对象、时间范围等）
 *  - item: 题目（题干、选项、题目类型等）
 *  - submission: 用户每次提交的记录（哪个用户提交的、时间等）
 *  - answer: 每次提交中每题的回答（关联题目、答案内容等）
 * 
 * @author Must77
 */
public class SysQuestionnaireMeta extends BaseEntity {
    private static final long serialVersionUID = 1L;
    /** 问卷ID **/
    @Excel(name = "问卷ID")
    private Long metaId;

    /** 所属部门ID **/
    @Excel(name = "所属部门ID")
    private Long deptId;

    /** 适用对象类型: D-部门 C-课程 T-教师 **/
    @Excel(name = "该问卷的适用对象类型")
    private String targetType; 

    /** 适用对象ID **/
    @Excel(name = "该问卷的适用对象ID")
    private Long targetRefId;

    /** 问卷标题 **/
    @Excel(name = "问卷标题")
    private String title;

    /** 问卷描述 **/
    @Excel(name = "问卷描述")
    private String description;

    /** 开始时间 **/
    @Excel(name = "开始时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** 结束时间 **/
    @Excel(name = "结束时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    /** 状态 **/
    @Excel(name = "状态")
    private String status;

    /** 是否允许重复填写 **/
    @Excel(name = "是否允许重复填写")
    private String allowRepeat;

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

    // 非持久化：创建/更新时一并传入的题目列表
    @Transient
    private List<SysQuestionnaireItem> items;

    /** 用于前端显示的字段 **/
    private String deptName;
    private String courseName;
    private String teacherName;
    private String targetName;

    // getters/setters
    public Long getMetaId() { return metaId; }
    public void setMetaId(Long metaId) { this.metaId = metaId; }
    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    public String getTargetType() { return targetType; }
    public void setTargetType(String targetType) { this.targetType = targetType; }
    public Long getTargetRefId() { return targetRefId; }
    public void setTargetRefId(Long targetRefId) { this.targetRefId = targetRefId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Date getStartTime() { return startTime; }
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
    public void setStartTime(Date startTime) { this.startTime = startTime; }
    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getAllowRepeat() { return allowRepeat; }
    public void setAllowRepeat(String allowRepeat) { this.allowRepeat = allowRepeat; }
    public List<SysQuestionnaireItem> getItems() { return items; }
    public void setItems(List<SysQuestionnaireItem> items) { this.items = items; }
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
    public String getTeacherName() {
        return teacherName;
    }
    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
    public String getTargetName() {
        return targetName;
    }
    public void setTargetName(String targetName) {
        this.targetName = targetName;
    }
    
}

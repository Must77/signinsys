package com.ruoyi.system.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;

/**
 * 问卷题目对象   sys_questionnaire_item
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
public class SysQuestionnaireItem {
    /** 题目ID **/
    @Excel(name = "题目ID")
    private Long itemId;
    
    /** 所属问卷ID **/
    @Excel(name = "所属问卷ID")
    private Long metaId;
    
    /** 题目类型: S-单选 T-多选 M-文本 Q-评分 **/
    @Excel(name = "题目类型")
    private String itemType; 

    /** 题目文本 **/
    @Excel(name = "题目文本")
    private String questionText;
    
    /** 是否必填 **/
    @Excel(name = "是否必填")
    private String required;
    
    /** 排序 **/
    @Excel(name = "排序")
    private Integer orderNum;

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
    public Long getItemId() {
        return itemId;
    }

    public void setItemId(Long itemId) {
        this.itemId = itemId;
    }

    public Long getMetaId() {
        return metaId;
    }

    public void setMetaId(Long metaId) {
        this.metaId = metaId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getRequired() {
        return required;
    }

    public void setRequired(String required) {
        this.required = required;
    }

    public Integer getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(Integer orderNum) {
        this.orderNum = orderNum;
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

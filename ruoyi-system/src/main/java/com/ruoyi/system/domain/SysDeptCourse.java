package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 部门课程对象 sys_dept_course
 * 
 * @author Must77
 */
public class SysDeptCourse extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 课程ID */
    private Long courseId;

    /** 部门ID */
    @Excel(name = "部门ID")
    private Long deptId;
    
    /** 部门名称 **/
    @Excel(name = "部门名称")
    private String deptName;

    /** 课程名称, 描述, 人数, 容量, 封面 */
    @Excel(name = "课程名称")
    private String name;

    @Excel(name = "课程描述")
    private String brief;

    @Excel(name = "课程人数")
    private Integer size;

    @Excel(name = "课程容量")
    private Integer cap;

    @Excel(name = "课程封面")
    private String coverURL;

    // getter/setter
    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public Long getDeptId() { return deptId; }
    public void setDeptId(Long deptId) { this.deptId = deptId; }
    
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }

    public String getName() { return name; }
    public void setName(String courseName) { this.name = courseName; }

    public String getBrief() { return brief; }
    public void setBrief(String courseDesc) { this.brief = courseDesc; }

    public Integer getSize() {
        return size;
    }
    public void setSize(Integer size) {
        this.size = size;
    }
    public Integer getCap() {
        return cap;
    }
    public void setCap(Integer cap) {
        this.cap = cap;
    }
    public String getCoverURL() {
        return coverURL;
    }
    public void setCoverURL(String coverURL) {
        this.coverURL = coverURL;
    }
}

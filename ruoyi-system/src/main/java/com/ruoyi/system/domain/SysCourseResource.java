package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import java.io.Serializable;
import java.util.Date;

public class SysCourseResource extends BaseEntity 
{
    private static final long serialVersionUID = 1L;

    /** 资源ID */
    private Long resourceId;

    /** 课程ID */
    @Excel(name = "课程ID")
    private Long courseId;

    /** 部门ID */
    @Excel(name = "部门ID")
    private Long deptId;

    /** 原始文件名 */
    @Excel(name = "文件名")
    private String fileName;

    /** 文件访问路径/URL */
    @Excel(name = "文件路径")
    private String filePath;

    /** 文件类型（扩展名） */
    @Excel(name = "文件类型")
    private String fileType;

    /** 文件大小（字节） */
    @Excel(name = "文件大小")
    private Long fileSize;


    // getter / setter
    public Long getResourceId() {
        return resourceId;
    }
    public void setResourceId(Long resourceId) {
        this.resourceId = resourceId;
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
    public String getFileName() {
        return fileName;
    }
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
    public String getFilePath() {
        return filePath;
    }
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    public String getFileType() {
        return fileType;
    }
    public void setFileType(String fileType) {
        this.fileType = fileType;
    }
    public Long getFileSize() {
        return fileSize;
    }
    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

}

package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.SysDeptApply;

/**
 * 部门申请 数据层
 * 
 * @author Must77
 */
public interface SysDeptApplyMapper {

    /**
     * 根据申请ID查询部门申请详细信息（包含用户和部门扩展信息）
     * 
     * @param applyId 部门申请ID
     * @return 部门申请详细信息（包含用户姓名、昵称、部门名称等扩展字段）
     */
    SysDeptApply selectDeptApplyById(Long applyId);

    /**
     * 根据条件查询部门申请列表（包含分页和排序支持）
     * 
     * @param query 查询条件对象，包含以下可选参数：
     *        - status: 申请状态
     *        - userId: 用户ID
     *        - deptId: 部门ID
     *        - params.beginTime: 申请开始时间（用于时间范围筛选）
     *        - params.endTime: 申请结束时间（用于时间范围筛选）
     * @return 部门申请结果列表（按创建时间倒序排列）
     */
    List<SysDeptApply> selectDeptApplyList(SysDeptApply query);

    /**
     * 新增部门申请记录
     * 
     * @param apply 部门申请对象，包含以下字段：
     *        - userId: 申请用户ID
     *        - deptId: 目标部门ID
     *        - status: 申请状态
     *        - remark: 申请备注
     *        - createBy: 创建人
     *        - updateBy: 更新人
     * @return 插入操作影响的行数
     */
    int insertDeptApply(SysDeptApply apply);

    /**
     * 修改部门申请记录
     * 
     * @param apply 部门申请对象，包含以下字段：
     *        - applyId: 申请ID（必填）
     *        - userId: 更新后的用户ID
     *        - deptId: 更新后的部门ID
     *        - status: 更新后的状态
     *        - remark: 更新后的备注
     *        - updateBy: 更新人
     * @return 更新操作影响的行数
     */
    int updateDeptApply(SysDeptApply apply);

    /**
     * 删除单个部门申请记录
     * 
     * @param applyId 要删除的部门申请ID
     * @return 删除操作影响的行数
     */
    int deleteDeptApplyById(Long applyId);

    /**
     * 批量删除部门申请记录
     * 
     * @param applyIds 要删除的部门申请ID数组
     * @return 删除操作影响的行数
     */
    int deleteDeptApplyByIds(Long[] applyIds);

    /**
     * 更新部门申请状态
     * 
     * 感觉这个接口设计的有点石, updateDeptApply用于更新申请记录的信息, 而这个用于只用于更新申请状态
     * 
     * @param apply 包含申请ID和新的状态的部门申请对象
     * @return 更新操作影响的行数
     */
    int updateStatus(SysDeptApply apply);
}

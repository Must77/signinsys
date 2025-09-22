package com.ruoyi.system.service;

import com.ruoyi.system.domain.*;
import java.util.List;

/**
 * 问卷 服务层
 * @author Must77
 */
public interface ISysQuestionnaireService {
    /**
     * 根据Id查看问卷meta
     * @param metaId
     * @return 问卷meta
     */
    SysQuestionnaireMeta selectMetaById(Long metaId);

    /**
     * 条件筛选问卷meta
     * @param query
     * @return 问卷meta列表
     */
    List<SysQuestionnaireMeta> selectMetaList(SysQuestionnaireMeta query);

    /**
     * 新增问卷meta+item
     * @param meta
     * @return 影响的行数
     */
    int insertMeta(SysQuestionnaireMeta meta);

    /**
     * 更新问卷meta+item
     * @param meta
     * @return 影响的行数
     */
    int updateMeta(SysQuestionnaireMeta meta);

    /**
     * 通过Ids删除问卷meta
     * @param metaIds
     * @return 影响的行数
     */
    int deleteMetaByIds(Long[] metaIds);

    /**
     * 用户提交问卷answer
     * @param metaId 目标问卷meta的Id
     * @param userId 提交用户的Id
     * @param answers 提交的问卷answer列表
     * @return 影响的行数
     */
    int submitAnswers(Long metaId, Long userId, List<SysQuestionnaireAnswer> answers);

    /**
     * 条件筛选问卷submission
     * @param metaId 目标问卷meta的Id
     * @return 问卷submission列表
     */
    List<SysQuestionnaireSubmission> selectSubmissions(Long metaId);

    /**
     * 条件筛选问卷answer
     * @param submissionId 目标问卷submission的Id
     * @return 问卷answer列表
     */
    List<SysQuestionnaireAnswer> selectAnswers(Long submissionId);
}

package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysQuestionnaireMeta;
import java.util.List;

public interface SysQuestionnaireMetaMapper {
    SysQuestionnaireMeta selectQuestionnaireMetaById(Long metaId);
    List<SysQuestionnaireMeta> selectQuestionnaireMetaList(SysQuestionnaireMeta meta);
    int insertQuestionnaireMeta(SysQuestionnaireMeta meta);
    int updateQuestionnaireMeta(SysQuestionnaireMeta meta);
    int deleteQuestionnaireMetaById(Long metaId);
    int deleteQuestionnaireMetaByIds(Long[] metaIds);
}

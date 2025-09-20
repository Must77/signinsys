package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysQuestionnaireMeta;
import java.util.List;

public interface SysQuestionnaireMetaMapper {
    SysQuestionnaireMeta selectQuestionnaireMetaById(Long quesMetaId);
    List<SysQuestionnaireMeta> selectQuestionnaireMetaList(SysQuestionnaireMeta meta);
    int insertQuestionnaireMeta(SysQuestionnaireMeta meta);
    int updateQuestionnaireMeta(SysQuestionnaireMeta meta);
    int deleteQuestionnaireMetaById(Long quesMetaId);
    int deleteQuestionnaireMetaByIds(Long[] quesMetaIds);
}

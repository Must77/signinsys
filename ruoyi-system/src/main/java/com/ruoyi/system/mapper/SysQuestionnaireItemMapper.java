package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysQuestionnaireItem;
import java.util.List;

public interface SysQuestionnaireItemMapper {
    SysQuestionnaireItem selectQuestionnaireItemById(Long quesItemId);
    List<SysQuestionnaireItem> selectQuestionnaireItemList(Long quesMetaId);
    int insertQuestionnaireItem(SysQuestionnaireItem item);
    int updateQuestionnaireItem(SysQuestionnaireItem item);
    int deleteQuestionnaireItemById(Long quesItemId);
    int deleteQuestionnaireItemByMetaId(Long quesMetaId);
}

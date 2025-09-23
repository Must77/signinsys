package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysQuestionnaireItem;
import java.util.List;

public interface SysQuestionnaireItemMapper {
    SysQuestionnaireItem selectQuestionnaireItemById(Long itemId);
    List<SysQuestionnaireItem> selectQuestionnaireItemByMetaId(Long metaId);
    int insertQuestionnaireItem(SysQuestionnaireItem item);
    int updateQuestionnaireItem(SysQuestionnaireItem item);
    int deleteQuestionnaireItemById(Long itemId);
    int deleteQuestionnaireItemByMetaId(Long metaId);
}

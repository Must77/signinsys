package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysQuestionnaireSubmission;
import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface SysQuestionnaireSubmissionMapper {
    SysQuestionnaireSubmission selectSubmissionById(Long submissionId);
    SysQuestionnaireSubmission selectSubmissionByMetaAndUser(@Param("metaId") Long metaId, @Param("userId") Long userId);
    List<SysQuestionnaireSubmission> selectSubmissionList(SysQuestionnaireSubmission query);
    int insertSubmission(SysQuestionnaireSubmission submission);
    
}

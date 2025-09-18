package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysQuestionnaireSubmission;
import java.util.List;

public interface SysQuestionnaireSubmissionMapper {
    SysQuestionnaireSubmission selectSubmissionById(Long submissionId);
    SysQuestionnaireSubmission selectSubmissionByMetaAndUser(Long quesMetaId, Long userId);
    List<SysQuestionnaireSubmission> selectSubmissionList(Long quesMetaId);
    int insertSubmission(SysQuestionnaireSubmission submission);
}

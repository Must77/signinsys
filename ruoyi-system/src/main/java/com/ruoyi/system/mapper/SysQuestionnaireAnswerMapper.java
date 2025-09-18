package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysQuestionnaireAnswer;
import java.util.List;

public interface SysQuestionnaireAnswerMapper {
    List<SysQuestionnaireAnswer> selectAnswersBySubmissionId(Long submissionId);
    int insertAnswer(SysQuestionnaireAnswer answer);
    int batchInsertAnswers(List<SysQuestionnaireAnswer> answers);
}

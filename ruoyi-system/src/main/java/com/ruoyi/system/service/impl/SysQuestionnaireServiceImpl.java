package com.ruoyi.system.service.impl;

import com.ruoyi.system.domain.*;
import com.ruoyi.system.mapper.*;
import com.ruoyi.system.service.ISysQuestionnaireService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class SysQuestionnaireServiceImpl implements ISysQuestionnaireService {

    @Autowired
    private SysQuestionnaireMetaMapper metaMapper;

    @Autowired
    private SysQuestionnaireItemMapper itemMapper;

    @Autowired
    private SysQuestionnaireSubmissionMapper submissionMapper;

    @Autowired
    private SysQuestionnaireAnswerMapper answerMapper;

    @Override
    public SysQuestionnaireMeta selectMetaById(Long quesMetaId) {
        return metaMapper.selectQuestionnaireMetaById(quesMetaId);
    }

    @Override
    public List<SysQuestionnaireMeta> selectMetaList(SysQuestionnaireMeta query) {
        return metaMapper.selectQuestionnaireMetaList(query);
    }

    @Override
    @Transactional
    public int insertMeta(SysQuestionnaireMeta meta, List<SysQuestionnaireItem> items) {
        int rows = metaMapper.insertQuestionnaireMeta(meta);
        for (SysQuestionnaireItem item : items) {
            item.setQuesMetaId(meta.getQuesMetaId());
            itemMapper.insertQuestionnaireItem(item);
        }
        return rows;
    }

    @Override
    @Transactional
    public int updateMeta(SysQuestionnaireMeta meta, List<SysQuestionnaireItem> items) {
        int rows = metaMapper.updateQuestionnaireMeta(meta);
        itemMapper.deleteQuestionnaireItemByMetaId(meta.getQuesMetaId());
        for (SysQuestionnaireItem item : items) {
            item.setQuesMetaId(meta.getQuesMetaId());
            itemMapper.insertQuestionnaireItem(item);
        }
        return rows;
    }

    @Override
    @Transactional
    public int deleteMetaByIds(Long[] quesMetaIds) {
        for (Long id : quesMetaIds) {
            itemMapper.deleteQuestionnaireItemByMetaId(id);
        }
        return metaMapper.deleteQuestionnaireMetaByIds(quesMetaIds);
    }

    @Override
    @Transactional
    public int submitAnswers(Long quesMetaId, Long userId, List<SysQuestionnaireAnswer> answers) {
        SysQuestionnaireSubmission submission = submissionMapper.selectSubmissionByMetaAndUser(quesMetaId, userId);
        if (submission != null) {
            throw new RuntimeException("该用户已提交过该问卷");
        }
        submission = new SysQuestionnaireSubmission();
        submission.setQuesMetaId(quesMetaId);
        submission.setUserId(userId);
        submissionMapper.insertSubmission(submission);

        for (SysQuestionnaireAnswer ans : answers) {
            ans.setSubmissionId(submission.getSubmissionId());
        }
        return answerMapper.batchInsertAnswers(answers);
    }

    @Override
    public List<SysQuestionnaireSubmission> selectSubmissions(Long quesMetaId) {
        return submissionMapper.selectSubmissionList(quesMetaId);
    }

    @Override
    public List<SysQuestionnaireAnswer> selectAnswers(Long submissionId) {
        return answerMapper.selectAnswersBySubmissionId(submissionId);
    }
}

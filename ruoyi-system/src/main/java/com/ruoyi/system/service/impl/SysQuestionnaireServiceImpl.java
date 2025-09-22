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
    public SysQuestionnaireMeta selectMetaById(Long metaId) {
        return metaMapper.selectQuestionnaireMetaById(metaId);
    }

    @Override
    public List<SysQuestionnaireMeta> selectMetaList(SysQuestionnaireMeta query) {
        return metaMapper.selectQuestionnaireMetaList(query);
    }

    @Override
    @Transactional
    public int insertMeta(SysQuestionnaireMeta meta) {
        int rows = metaMapper.insertQuestionnaireMeta(meta);
        Long metaId = meta.getMetaId();
        List<SysQuestionnaireItem> items = meta.getItems();
        // 允许只创建问卷的meta而不创建具体题目item
        if (items != null && !items.isEmpty()) {
            for (SysQuestionnaireItem item : items) {
                item.setMetaId(metaId);
                rows += itemMapper.insertQuestionnaireItem(item);
            }
        }
        return rows;
    }

    @Override
    @Transactional
    public int updateMeta(SysQuestionnaireMeta meta) {
        int rows = metaMapper.updateQuestionnaireMeta(meta);
        Long metaId = meta.getMetaId();

        // 如果更新了item, 就逻辑删除再插入
        // TODO：考虑要不要直接更新而非逻辑删除再插入
        List<SysQuestionnaireItem> items = meta.getItems();
        if (items != null && !items.isEmpty()) {
            itemMapper.deleteQuestionnaireItemByMetaId(metaId);
            for (SysQuestionnaireItem item : items) {
                item.setMetaId(metaId);
                rows += itemMapper.insertQuestionnaireItem(item);
            }
        }
        return rows;
    }

    @Override
    @Transactional
    public int deleteMetaByIds(Long[] metaIds) {
        int rows = 0;
        for (Long id : metaIds) {
            rows += itemMapper.deleteQuestionnaireItemByMetaId(id);
        }
        rows += metaMapper.deleteQuestionnaireMetaByIds(metaIds);
        return rows;
    }

    @Override
    @Transactional
    public int submitAnswers(Long metaId, Long userId, List<SysQuestionnaireAnswer> answers) {
        // 检查用户是否重复提交submission
        SysQuestionnaireSubmission submission = submissionMapper.selectSubmissionByMetaAndUser(metaId, userId);
        if (submission != null) {
            throw new RuntimeException("该用户已提交过该问卷");
        }
        // 创建一次新的提交submission
        submission = new SysQuestionnaireSubmission();
        submission.setMetaId(metaId);
        submission.setUserId(userId);
        submissionMapper.insertSubmission(submission);
        Long submissionId = submission.getSubmissionId();

        // 插入所有回答answer
        for (SysQuestionnaireAnswer ans : answers) {
            // 后端确保sys_questionnaire_answer每个answer项的NOT NULL字段正常
            ans.setSubmissionId(submissionId);
            ans.setMetaId(metaId);
            ans.setUserId(userId);
        }
        return answerMapper.batchInsertAnswers(answers);
    }

    @Override
    public List<SysQuestionnaireSubmission> selectSubmissions(Long metaId) {
        return submissionMapper.selectSubmissionList(metaId);
    }

    @Override
    public List<SysQuestionnaireAnswer> selectAnswers(Long submissionId) {
        return answerMapper.selectAnswersBySubmissionId(submissionId);
    }
}

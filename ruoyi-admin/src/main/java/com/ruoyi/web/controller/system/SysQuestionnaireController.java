package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.*;
import com.ruoyi.system.service.ISysQuestionnaireService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * 问卷管理
 * @author Must77
 */
@RestController
@RequestMapping("/system/questionnaire")
public class SysQuestionnaireController extends BaseController {

    @Autowired
    private ISysQuestionnaireService questionnaireService;

    /**
     * 条件筛选问卷
     * @param query 查询条件
     * @return 问卷列表
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:list')")
    @GetMapping("/list")
    public AjaxResult list(SysQuestionnaireMeta query) {
        List<SysQuestionnaireMeta> list = questionnaireService.selectMetaList(query);
        return success(list);
    }

    /**
     * 获取问卷meta
     * @param quesMetaId 问卷ID
     * @return 问卷及其题目列表
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:query')")
    @GetMapping("/{questionnaireMetaId}")
    public AjaxResult getInfo(@PathVariable Long questionnaireMetaId) {
        return success(questionnaireService.selectMetaById(questionnaireMetaId));
    }

    /**
     * 新增问卷
     * @param questionnaireMeta 问卷meta+item
     * @return 影响的表行数
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:add')")
    @Log(title = "问卷管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysQuestionnaireMeta questionnaireMeta) {
        return toAjax(questionnaireService.insertMeta(questionnaireMeta));
    }

    /**
     * 修改问卷。如果传入item也会一并更新，否则只更新meta
     * @param questionnaireMeta 问卷meta+item
     * @return 影响的表行数
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:edit')")
    @Log(title = "问卷管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysQuestionnaireMeta questionnaireMeta) {
        return toAjax(questionnaireService.updateMeta(questionnaireMeta));
    }

    /**
     * 删除问卷
     * @param questionnaireMetaIds 问卷ID数组
     * @return 影响的表行数
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:remove')")
    @Log(title = "问卷管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{questionnaireMetaIds}")
    public AjaxResult remove(@PathVariable Long[] questionnaireMetaIds) {
        return toAjax(questionnaireService.deleteMetaByIds(questionnaireMetaIds));
    }

    /**
     * 提交问卷答案
     * @param questionnaireMetaId 问卷ID
     * @param answers 答案列表
     * @return 影响的表行数
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:submit')")
    @PostMapping("/{questionnaireMetaId}/submit")
    public AjaxResult submit(@PathVariable Long questionnaireMetaId, @RequestBody List<SysQuestionnaireAnswer> answers) {
        Long userId = getUserId();
        int rows = 0;
        try{
            rows = questionnaireService.submitAnswers(questionnaireMetaId, userId, answers);
        }catch(RuntimeException e){
            return AjaxResult.error(e.getMessage());
        }
        return toAjax(rows);
    }

    /**
     * 查看问卷提交记录
     * @param questionnaireMetaId 问卷ID
     * @return 提交记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:submission:list')")
    @GetMapping("/{questionnaireMetaId}/submissions")
    public AjaxResult listSubmissions(@PathVariable Long questionnaireMetaId) {
        SysQuestionnaireSubmission query = new SysQuestionnaireSubmission();
        query.setMetaId(questionnaireMetaId);
        return success(questionnaireService.selectSubmissionList(query));
    }

    /**
     * 查看某次提交的问卷答案
     * TODO: 这里的URL是不是应该为 /submission/{submissionId}/answers 更合适一些？
     * @param submissionId 提交记录ID
     * @return 答案列表
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:submission:answers')")
    @GetMapping("/answers/{submissionId}")
    public AjaxResult listAnswers(@PathVariable Long submissionId) {
        return success(questionnaireService.selectAnswers(submissionId));
    }

    /**
     * 条件筛选查看submission, 不区分问卷meta
     * @param query 查询条件
     * @return submission列表
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:submission:list')")
    @GetMapping("/submission/list")
    public AjaxResult listSubmissions(SysQuestionnaireSubmission query) {
        List<SysQuestionnaireSubmission> list = questionnaireService.selectSubmissionList(query);
        return success(list);
    }

    /**
     * 根据Id查看submission
     * @param submissionId submission的Id
     * @return submission
     */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:submission:query')")
    @GetMapping("/submission/{submissionId}")
    public AjaxResult getSubmission(@PathVariable Long submissionId) {
        return success(questionnaireService.selectSubmissionById(submissionId));
    }

    /** 
     * 查看某个问卷的所有item
     * @param metaId
     * @return 题目列表
    */
    @PreAuthorize("@ss.hasPermi('system:questionnaire:query')")
    @GetMapping("/{metaId}/items")
    public AjaxResult listItems(@PathVariable Long metaId) {
        return success(questionnaireService.selectItems(metaId));
    }
}
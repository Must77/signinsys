package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.*;
import com.ruoyi.system.service.ISysQuestionnaireService;
import org.springframework.beans.factory.annotation.Autowired;
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
    @GetMapping("/list")
    public AjaxResult list(SysQuestionnaireMeta query) {
        List<SysQuestionnaireMeta> list = questionnaireService.selectMetaList(query);
        return success(list);
    }

    /**
     * 获取问卷详细信息
     * @param quesMetaId 问卷ID
     * @return 问卷及其题目列表
     */
    @GetMapping("/{quesMetaId}")
    public AjaxResult getInfo(@PathVariable Long quesMetaId) {
        return success(questionnaireService.selectMetaById(quesMetaId));
    }

    @Log(title = "问卷管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysQuestionnaireMetaWrapper wrapper) {
        return toAjax(questionnaireService.insertMeta(wrapper.getMeta(), wrapper.getItems()));
    }

    @Log(title = "问卷管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysQuestionnaireMetaWrapper wrapper) {
        return toAjax(questionnaireService.updateMeta(wrapper.getMeta(), wrapper.getItems()));
    }

    @Log(title = "问卷管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{quesMetaIds}")
    public AjaxResult remove(@PathVariable Long[] quesMetaIds) {
        return toAjax(questionnaireService.deleteMetaByIds(quesMetaIds));
    }

    @PostMapping("/{quesMetaId}/submit")
    public AjaxResult submit(@PathVariable Long quesMetaId, @RequestBody List<SysQuestionnaireAnswer> answers) {
        Long userId = getUserId();
        return toAjax(questionnaireService.submitAnswers(quesMetaId, userId, answers));
    }

    @GetMapping("/{quesMetaId}/submissions")
    public AjaxResult listSubmissions(@PathVariable Long quesMetaId) {
        return success(questionnaireService.selectSubmissions(quesMetaId));
    }

    @GetMapping("/answers/{submissionId}")
    public AjaxResult listAnswers(@PathVariable Long submissionId) {
        return success(questionnaireService.selectAnswers(submissionId));
    }

    /**
     * 包装类：用于新增/修改时接收 meta + items
     */
    public static class SysQuestionnaireMetaWrapper {
        private SysQuestionnaireMeta meta;
        private List<SysQuestionnaireItem> items;

        public SysQuestionnaireMeta getMeta() { return meta; }
        public void setMeta(SysQuestionnaireMeta meta) { this.meta = meta; }

        public List<SysQuestionnaireItem> getItems() { return items; }
        public void setItems(List<SysQuestionnaireItem> items) { this.items = items; }
    }
}

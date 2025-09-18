package com.ruoyi.web.controller.system;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.system.domain.SysCourseSigninRecord;
import com.ruoyi.system.service.ISysCourseSigninRecordService;

@RestController
@RequestMapping("/system/signinRecord")
public class SysCourseSigninRecordController extends BaseController {

    @Autowired
    private ISysCourseSigninRecordService recordService;

    /**
     * 用户签到
     */
    @PutMapping("/doSignin/{recordId}")
    public AjaxResult doSignin(@PathVariable Long recordId) {
        SysCourseSigninRecord record = new SysCourseSigninRecord();
        record.setUserId(getUserId());
        record.setRecordId(recordId);
        record.setStatus("1"); // 已签到
        
        int rows = recordService.updateSigninRecordStatus(record);
        return rows > 0 ? AjaxResult.success("签到成功") : AjaxResult.error("签到失败或已签到");
    }

    /**
     * 查看当前用户的待签到记录
     * @parma 无
     * @return 表格分页数据对象
     */
    @GetMapping("/myPending")
    public TableDataInfo listMyPending()
    {
        startPage();
        List<SysCourseSigninRecord> list = recordService.selectSigninRecordPending(getUserId());
        return getDataTable(list);
    }

    /** 
     * 条件查询某个签到记录
     * @param query 条件
     * @return 成功与否
    */
    @GetMapping("/list")
    public TableDataInfo list(SysCourseSigninRecord query)
    {
        // 添加用户ID条件，确保只能查询自己的记录
        query.setUserId(getUserId());
        startPage();
        List<SysCourseSigninRecord> list = recordService.selectSigninRecordList(query);
        return getDataTable(list);
    }
}
package com.ruoyi.web.controller.system;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
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
    @PreAuthorize("@ss.hasPermi('system:signinRecord:doSignin')")
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
    @PreAuthorize("@ss.hasPermi('system:signinRecord:myPending')")
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
    @PreAuthorize("@ss.hasPermi('system:signinRecord:list')")
    public AjaxResult list(SysCourseSigninRecord query)
    {
        // 添加用户ID条件，确保只能查询自己的记录
        query.setUserId(getUserId());
        startPage();
        List<SysCourseSigninRecord> list = recordService.selectSigninRecordList(query);
        return getDataTable(list);
    }

    /**
     * 导出签到记录
     * @param response 响应流
     * @param query 查询条件
     * @throws UnsupportedEncodingException 
     */
    @Log(title = "签到记录-导出", businessType = com.ruoyi.common.enums.BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('system:signinRecord:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, @RequestBody SysCourseSigninRecord query) throws UnsupportedEncodingException
    {
        List<SysCourseSigninRecord> list = recordService.selectSigninRecordList(query);
        ExcelUtil<SysCourseSigninRecord> util = new ExcelUtil<SysCourseSigninRecord>(SysCourseSigninRecord.class);
        // 文件名中添加人类可读的时间戳
        String fileName = DateUtils.dateTimeNow("yyyyMMdd_HHmmss") + "_签到记录数据.xlsx";
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
        util.exportExcel(response, list, "签到记录数据");
    }
}


package com.ruoyi.web.controller.system;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.SysCourseSignin;
import com.ruoyi.system.domain.SysCourseSigninRecord;
import com.ruoyi.system.service.ISysCourseSigninRecordService;
import com.ruoyi.system.service.ISysCourseSigninService;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 课程签到 Controller
 * 
 * @author 
 */
@RestController
@RequestMapping("/system/signin")
public class SysCourseSigninController extends BaseController
{
    @Autowired
    private ISysCourseSigninService signinService;

    @Autowired
    private ISysCourseSigninRecordService recordService;

    /**
     * 查询课程签到列表（admin）
     */
    @GetMapping("/list/{signinId}")
    public TableDataInfo list(SysCourseSignin query)
    {
        startPage();
        List<SysCourseSignin> list = signinService.selectCourseSigninList(query);
        return getDataTable(list);
    }

    /**
     * 获取课程签到详细信息（admin）
     */
    @GetMapping("/{signinId}")
    public AjaxResult getInfo(@PathVariable Long signinId)
    {
        return AjaxResult.success(signinService.selectCourseSigninById(signinId));
    }

    /**
     * 新增课程签到（admin发布签到）
     * 
     * TODO: 插入签到元数据时还预生成签到记录, 因此之后需要新增加一个@Transactional的Service, 通过事务保证一次性都成功或者都失败
     */
    @Log(title = "课程签到", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysCourseSignin signin)
    {
        // 判断签到状态：0未开始,1进行中,2已结束
        Date now = new Date();
        if (now.before(signin.getStartTime())) {
            signin.setStatus("0");
        } else if (now.after(signin.getEndTime())) {
            signin.setStatus("2");
        } else {
            signin.setStatus("1");
        }
        signin.setCreateBy(getUsername());

        int rows = signinService.insertCourseSignin(signin);

        Long signinId = signin.getId();
        if (rows > 0 && signinId != null) {
            // 预生成签到记录
            recordService.generateSigninRecords(signin); // 里面用 signin.getId()
        } else if (rows > 0) {
            return error("创建签到成功但未获取到主键ID，请检查 Mapper 的 useGeneratedKeys 配置");
        }
        return toAjax(rows);
    }

    /**
     * 修改课程签到（admin）
     */
    @Log(title = "课程签到", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysCourseSignin signin)
    {
        return toAjax(signinService.updateCourseSignin(signin));
    }

    /**
     * 删除课程签到（admin）
     */
    @Log(title = "课程签到", businessType = BusinessType.DELETE)
    @DeleteMapping("/{signinIds}")
    public AjaxResult remove(@PathVariable Long[] signinIds)
    {
        return toAjax(signinService.deleteCourseSigninByIds(signinIds));
    }


    /**
     * 查看某个签到的签到结果（admin）
     * 已签到人员 / 未签到人员
     */
    @GetMapping("/result/{signinId}")
    public AjaxResult result(@PathVariable Long signinId)
    {
        List<SysCourseSigninRecord> signed = recordService.selectSignedUsers(signinId);
        List<SysCourseSigninRecord> unsigned = recordService.selectUnsignedUsers(signinId);

        Map<String, Object> result = new HashMap<>();
        result.put("signed", signed);
        result.put("unsigned", unsigned);

        return AjaxResult.success(result);
    }

}

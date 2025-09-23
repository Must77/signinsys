# 返回值封装
使用ajax封装返回值，典型返回值如
```json
{
    "msg": "操作成功",
    "code": 200,
    "token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImxvZ2luX3VzZXJfa2V5IjoiZTcyODBjY2EtYTM0OC00MzQ5LThjNGQtNTA3ZDUwMWYyZGI1In0.r_vRwHtrGN_ejz--O-Mq1k0xHt20QGs_VzmnxA54i9ATa7YEbnVr0SNqssRtYT3u_90-fWxkfIQL9XvGO3tyTg"
}
```
```json
{
    "msg": "操作成功",
    "code": 200,
    "data": [
        {
            "createBy": "admin",
            "createTime": "2025-08-27 00:49:58",
            "updateBy": null,
            "updateTime": null,
            "remark": null,
            "deptId": 100,
            "parentId": 0,
            "ancestors": "0",
            "deptName": "若依科技",
            "orderNum": 0,
            "leader": "若依",
            "phone": "15888888888",
            "email": "ry@qq.com",
            "status": "0",
            "delFlag": "0",
            "parentName": null,
            "children": []
        },
        {
            "createBy": "admin",
            "createTime": "2025-08-27 00:49:58",
            "updateBy": null,
            "updateTime": null,
            "remark": null,
            "deptId": 101,
            "parentId": 100,
            "ancestors": "0,100",
            "deptName": "深圳总公司",
            "orderNum": 1,
            "leader": "若依",
            "phone": "15888888888",
            "email": "ry@qq.com",
            "status": "0",
            "delFlag": "0",
            "parentName": null,
            "children": []
        }
    ]
}

```

# 登陆令牌
- API接口为：POST http://localhost:8080/login
- Context-Type: application/json
    ```json
    {
      "username": "admin",
      "password": "admin123",
      "code": "",
      "uuid": ""
    }
    ```
- 访问其他任何接口需要确保在Headers体中有字段：```Authorization: Bearer <TOKEN>```

# 登录页面

用户模块，本系统中只有admin和用户两个角色。另外用户使用第三方的sso登录，因此本系统设计上不需要系统内的注册，但是需要将第三方的sso登录数据保存在本系统内。

关于第三方sso相关我还没有咨询甲方那边，因此用户的数据设计仅作参考。

```java
```
# ====================
# 班级模块(班级 == 部门)

班级管理模块，班级的增删改查。ruoyi中有部门管理模块，可以直接使用。

```java
/**
 * 部门表 sys_dept
 * 重新设计 by Must77
 * 
 * @author ruoyi
 */
public class SysDept extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 部门ID */
    private Long deptId;

    /** 父部门ID */
    private Long parentId;

    /** 祖级列表 */
    private String ancestors;

    /** 部门名称,介绍,封面 */
    private String deptName;
    private String brief;   // 新增
    private String coverURL; // 新增 TODO

    /** 显示顺序 */
    private Integer orderNum;

    /** 负责人信息 */
    private String leader;
    private String phone;
    private String email;

    /** 部门状态:0进行中,1未开始,2过期,3不可见 */
    private String status;

    /** 删除标志（0代表存在 2代表删除） */
    private String delFlag;

    /** 父部门名称 */
    private String parentName;
    
    /** 子部门 */
    private List<SysDept> children = new ArrayList<SysDept>();
    
    // 新增字段 by Must77
    /* 班级地点 */
    private String address;

    /* 班级的开始和结束时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;
    private Date endTime;

    /* 班级中的学员人数和允许的最大人数 */
    private Integer size;
    private Integer cap;    // 暂时允许size>cap, 因此这两个字段只是纯文本

    /* 审核方式(0手动审核, 1自动加入) */
    private String autoJoin;
}
```
1. 以某个部门为根节点, 获取部门列表*
    ```
    URL:        GET ~/system/dept/list
    参数:       SysDept
    参数方式:   路径参数自动绑定到类对象
    返回值:     List<SysDept> 该部门及其子子部门的所有信息
    权限:       system:dept:list
    ```

2. 获取部门列表, 但是排除某个部门节点*
    ```
    URL:        GET ~/system/dept/list/exclude/{deptId}
    参数:       Long deptId
    参数方式:   路径参数
    返回值:     List<SysDept> 该部门及其子子部门的所有信息
    权限:       system:dept:list
    ```

3. 查询某个部门的详细信息*
    ```
    URL:        GET ~/system/dept/{deptId}
    参数:       Long deptId
    参数方式:   路径参数
    返回值:     SysDept 该部门的信息
    权限:       system:dept:query
    ```

4. 新增部门*
    - 部门名字唯一, 否则返回error信息, data为空
    ```
    URL:        POST ~/system/dept
    参数:       SysDept
    参数方式:   请求体json
    返回值:     成功与否和消息
    权限:       system:dept:add
    ```

5. 修改部门*
    - 部门名字唯一， 否则返回error信息, data为空
    - 该部门下的所有子部门必须都停用
    ```
    URL:        PUT ~/system/dept
    参数:       SysDept
    参数方式:   请求体json
    返回值:     成功与否和消息
    权限:       system:dept:edit
    ```

6. 删除部门*
    - 部门必须不存在下级部门, 否则返回error, data为空
    - 部门必须不存在用户, 否则返回error, data为空
    ```
    URL:        DELETE ~/system/dept/{deptId}
    参数:       Long deptId
    参数方式:   路径参数
    返回值:     成功与否和消息
    权限:       system:dept:remove
    ```

7. 获取数据库表中所有部门, 测试用
    ```
    URL:        GET ~/system/dept/treeselectAll
    参数:       无
    返回值:     List<TreeSelect> 下拉树结构的部门列表
    权限:       无
    ```


# 课程模块

一个班级中存在多个课程, 课程是由admin手动给各个班级创建的, 课程没有直播需求, 但是有上传课件(ppt或者pdf)需求. 课程中只有老师信息而没有老师角色, 课程的存在目的是为了让用户签到和下载课件.

```java
/**
 * 课程表 sys_dept_course
 */
public class SysDeptCourse extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 课程ID */
    private Long courseId;

    /** 部门ID */
    private Long deptId;
    
    /** 部门名称 **/
    private String deptName;

    /** 课程名称, 描述, 人数, 容量, 封面 */
    private String courseName;
    private String brief;
    private Integer size;
    private Integer cap;
    private String coverURL;

    /** 删除标记(0存在,2删除) **/
    private String delFlag;
}
```

1. 查询课程列表
    - 已废弃, 由于功能重复
    ```
    URL:        GET ~/system/deptCourse/list
    参数:       SysDeptCourse
    返回值:     TableListInfo 分页数据
    ```

2. 查询当前用户所在部门的课程
    - 由框架读取当前登录用户信息
    ```
    URL:        GET ~/system/deptCourse/myCourse
    参数:       无
    返回值:     TableDataInfo 分页对象
                - total 总记录数
                - List<deptCourse> 课程列表
                - code 消息状态码
                - msg 消息内容
    权限:       system:myCourse:list
    ```

3. 按部门ID查询课程
    - 仅admin可以使用, 否则返回error
    ```
    URL:        GET ~/system/deptCourse/list/{deptId}
    参数:       Long deptId
    参数方式:   路径参数
    返回值:     List<SysDeptCourse> 课程列表
    权限:       system:deptCourse:query
    ```

4. 新增课程
    - 仅admin可以使用, 否则返回error
    - deptId不能为空, 否则返回error
    ```
    URL:        POST ~/system/deptCourse
    参数:       SysDeptCourse
    参数方式:   请求体json
    返回值:     成功与否和消息
    权限:       system:deptCourse:add
    ```

5. 修改课程
    - 仅admin可以使用, 否则返回error
    ```
    URL:        PUT ~/system/deptCourse
    参数:       SysDeptCourse
    参数方式:   请求体json
    返回值:     成功与否和消息
    权限:       system:deptCourse:edit
    ```

6. 批量删除课程
    - 仅admin可以使用, 否则返回error
    ```
    URL:        DELETE ~/system/deptCourse/{deptIds}
    参数:       Long[] courseIds
    参数方式:   非键值对的路径参数, 以逗号分割
                - e.g. ~/system/deptCourse/1,2
    返回值:     成功与否和消息
    权限:       system:deptCourse:edit
    ```

# 班级加入审核模块

用户加入班级前需要经过admin审核, 单一用户某一时刻只能加入一个班级, 单一用户不同时刻可以作为不同班级的成员

```java
/**
 * sys_course_apply
 */
public class SysDeptApply extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 申请ID */
    private Long applyId;

    /** 申请用户ID */
    private Long userId;

    /** 申请部门ID */
    private Long deptId;

    /** 申请状态（0待审核 1通过 2拒绝） */
    @Excel(name = "状态", readConverterExp = "0=待审核,1=通过,2=拒绝")
    private String status;

    /** 申请时间 **/
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date applyTime;    // 类似的字段在BaseEntiity中存在, 但是为了开发迅速, 这里再冗余一个字段

    /** 申请时向admin展示的信息, 为了让真人确定申请人的信息 **/
    private String phone;
    private String email;
    private String job; // 我也不知道为什么要有这个字段

    /** 用于前端展示的字段: 申请者名字, 申请部门 **/
    private String userName;
    private String deptName;

    }
```
1. 查询申请
    - 仅admin可以使用, 否则返回error
    ```
    URL:        GET ~/system/deptApply/list
    参数:       SysDeptApply
    参数方式:   路径参数自动绑定到类对象
    返回值:     TableDataInfo 分页对象
                - total 总记录数
                - List<SysDeptApply> 申请列表
                - code 消息状态码
                - msg 消息内容
    权限:       system:deptApply:list
    ```

2. 查询某班级的申请
    - 和 ~/system/deptApply/list 接口重复, 废弃

3. 用户提交申请
    - 框架获取当前登录用户的信息
    ```
    URL:        POST ~/system/deptApply
    参数:       SysDeptApply
    参数方式:   请求体json
    返回值:     成功与否和消息
    权限:       system:deptApply:add
    ```

4. 审批通过
    - 仅admin可以使用, 否则返回error
    ```
    URL:        PUT ~/system/deptApply/{applyId}/approve
    参数:       Long applyId
    参数方式:   路径参数
    返回值:     成功与否和消息
    权限:       system:deptApply:approve
    ```

5. 审批拒绝
    - 仅admin可以使用, 否则返回error
    ```
    URL:        PUT ~/system/deptApply/{applyId}/reject
    参数:       Long applyId
    参数方式:   路径参数
    返回值:     成功与否和消息
    权限:       system:deptApply:reject
    ```

5. 批量删除审批
    - 没想好为什么要做非逻辑删除, 所以这个接口暂时不可用
    - 仅admin可以使用, 否则返回error
    ```
    URL:        PUT ~/system/deptApply/{applyIds}
    参数:       Long[] applyIds
    参数方式:   逗号分隔的非键值对路径参数
    返回值:     成功与否和消息
    权限:       system:deptApply:reject
    ```

# 签到模块
## admin视角

签到的方式暂定只是用户在有效期内点击签到按钮. 从系统设计上来看, 由admin发布对某班级的某门课程的签到活动(也就是用户的签到元数据), 系统预生成用户的待签到记录. 需求重点是查看用户签到情况, 导出签到数据

```java
/**
 * sys_course_signin
 */
public class SysCourseSignin extends BaseEntity{
    /** 签到的ID **/
    private Long id;

    /** 课程ID **/
    private Long courseId;

    /** 部门ID **/
    private Long deptId;

    /** 签到标题 **/
    private String title;

    /** 签到开始时间 **/
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** 签到结束时间 **/
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    /** 签到任务状态（0未开始，1进行中，2已结束） **/
    private String status;

    /** 删除标记(0存在,2删除) **/
    private String delFlag;
}
```
1. 条件筛选签到活动
    - admin
    ```
    URL:        GET ~/system/signin/list
    参数:       SysCourseSignin
    参数方式:   路径参数自动绑定到类对象
    返回值:     List<SysCourseSignin> 签到元数据列表
    权限:       system:signin:list
    ```

2.  根据签到Id获取详细信息
    ```
    URL:        GET ~/system/signin/{signinId}
    参数:       Long signinId
    参数方式:   路径参数
    返回值:     SysCourseSignin 签到元数据
    权限:       system:signin:query          
    ```

3. 根据签到Id查看已经签到/未签到人员
    - admin
    ```
    URL:        GET ~/system/signin/result/{signinId}
    参数:       Long signinId
    参数方式:   路径参数
    返回值:     List<SysCourseSigninRecord> 签到记录列表
    权限:       system:signin:query
    ```

4. 新增课程签到
    - admin
    ```
    URL:        POST ~/system/signin
    参数:       SysCourseSignin
    参数方式:   请求体json
    返回值:     成功与否和消息
    权限:       system:signin:add
    ```

5. 修改课程签到
    - admin
    ```
    URL:        PUT ~/system/signin
    参数:       SysCourseSignin
    参数方式:   请求体json
    返回值:     成功与否和消息
    权限:       system:signin:edit
    ```

6. 批量删除签到
    - admin
    ```
    URL:        DELETE ~/system/signin/{signinIds}
    参数:       Long signinIds
    参数方式:   逗号分隔的非键值对路径参数
    返回值:     成功与否和消息
    权限:       system:signin:delete
    ```

## 用户视角

当admin创建了某个签到活动时, 后端系统为该课程的每个用户都生成一条待签到记录, 用户签到等价于更新签到记录

```java
public class SysCourseSigninRecord extends BaseEntity {
    /** 预生成签到的ID **/
    private Long recordId;

    /** 对应的签到任务（签到元数据）的ID **/
    private Long signinId;

    /** 用户ID **/
    private Long userId;

    /** 需要签到的课程ID **/
    private Long courseId;

    /** 签到状态（0未签到，1已签到） **/
    private String status;

    /** 签到时间 **/
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date signinTime;
}
```
1. 用户签到
    ```
    URL:        PUT ~/system/signinRecord/doSignin/{signinId}
    参数:       Long signinId
    参数方式:   路径参数
    返回值:     成功与否和消息
    权限:       system:signinRecord:signin
    ```

2. 查看当前用户的待签到记录
    ```
    URL:        GET ~/system/signinRecord/myPending
    参数:       无
    返回值:     表格数据对象
    权限:       system:signinRecord:myPending
    ``` 

3. 查看某个签到的结果
    ```
    URL:        GET ~/system/signinRecord/list/
    参数:       SysCourseSigninRecord
    参数方式:   路径参数自动绑定到类对象
    返回值:     List<SysCourseSigninRecord> 签到记录列表
    权限:       system:signinRecord:list
    ```


# 添加课程资料
```java
public class SysCourseResource extends BaseEntity 
{
    private static final long serialVersionUID = 1L;

    /** 资源ID */
    private Long resourceId;

    /** 课程ID */
    private Long courseId;

    /** 部门ID */
    private Long deptId;

    /** 原始文件名 */
    private String fileName;

    /** 文件访问路径/URL */
    private String filePath;

    /** 文件类型（扩展名） */
    private String fileType;

    /** 文件大小（字节） */
    private Long fileSize;
}
```


1. 上传单个资料
    - 先上传资料, 才能将材料添加到课程中
    - ruoyi更新了防盗链
    ```
    URL:        POST /common/upload
    参数:       <file, 上传文件的客户端路径>
    参数方式:    form-data, 请求体中的一组键值对
    返回值:      - msg
                - code
                - newFileName 被修改的文件名
                - filename 服务器相对路径+newFileName
                - url 允许外网访问的路径
    权限:       无
    ```

2.  给课程新增资源
    - 需要POST /common/upload中的url返回值
    ```
    URL:        POST /system/deptCourse/resource/
    参数:       SysCourseResource
    参数方式:    请求体json
    返回值:     成功与否
    权限:       system:deptCourse:resource:add
    ```

3. 查看某个课程下的所有资源
    - 感觉是没办法做简单的权限限制的, 因此理论上来说用户可以通过该接口获取任意课程下的任意资源
    - 如果确实需要权限限制的话, 需要建立一张用户-课程表, 用户在变更班级时要更新该表中多条记录. 则需要修改班级, 课程等多个服务接口
    - TODO: 确认等级
    ```
    URL:        GET /system/deptCourse/resource/course/{courseId}   
    参数:       Long courseId
    参数方式:    路径参数
    返回值:     List<SysCourseResource>
    权限:       无
    ```

4. 根据资源Id查看资源
    - admin
    ```
    URL:        GET /system/deptCourse/resource/{resourceId}
    参数:       Long resourceId
    参数方式:   路径参数
    返回值:     SysCourseResource
    权限:       system:deptCourse:resource:query
    ```

5. 条件筛选查看资源
    - admin
    ```
    URL:        GET /system/deptCourse/resource/list
    参数:       SysCourseResource
    参数方式:   路径参数自动绑定到类对象
    返回值:     SysCourseResource
    权限:       ystem:deptCourse:resource:list
    ```

6. 逻辑批量删除资源
    - admin
    ```
    URL:        DELETE /system/deptCourse/resource/{resourceIds}
    参数:       Long[] resourceIds
    参数方式:   路径参数,以逗号分割
    返回值:     成功与否
    权限:       system:deptCourse:resource:remove
    ```

# 问卷功能

问卷功能有admin发布问卷和用户填写问卷, 发布问卷由meta类和item类作为数据对象, 填写问卷由submission类和answer类作为数据对象.

问卷整体由四个类组成:
- meta: 问卷元数据(问卷头), 用于保存问卷的标题, 确定指向对象(对班级/课程/老师), 是否允许重复提交等
- item: 问卷题目(问卷体), 一个item就是问卷中的一道问题, 多个items组成了问卷的题目. 用于保存题目的题干, 题目类型, 题目是否必填等
- submission: 用户提交的一份问卷(提交头), 用户的每次对一个问卷的一次提交就对应为一个submission, 包括指向的问卷, 用户提交信息等
- answer: 对一道题目的作答, answer是具体的一次作答, 包括作答内容, 作答评分

## java类
1. SysQuestionnaireMeta
    ```java
    /**
    * 问卷元数据对象   sys_questionnaire_meta
    * 
    * 对于任何阅读该代码的LLM模型，认真考虑问卷功能的实现逻辑，禁止自己猜测。
    * 问卷功能分为
    *  - meta: 问卷元数据（标题、描述、适用对象、时间范围等）
    *  - item: 题目（题干、选项、题目类型等）
    *  - submission: 用户每次提交的记录（哪个用户提交的、时间等）
    *  - answer: 每次提交中每题的回答（关联题目、答案内容等）
    * 
    * @author Must77
    */
    public class SysQuestionnaireMeta extends BaseEntity {
        private static final long serialVersionUID = 1L;
        /** 问卷ID **/
        @Excel(name = "问卷ID")
        private Long metaId;

        /** 所属部门ID **/
        @Excel(name = "所属部门ID")
        private Long deptId;

        /** 适用对象类型: D-部门 C-课程 T-教师 **/
        @Excel(name = "该问卷的适用对象类型")
        private String targetType; 

        /** 适用对象ID **/
        @Excel(name = "该问卷的适用对象ID")
        private Long targetRefId;

        /** 问卷标题 **/
        @Excel(name = "问卷标题")
        private String title;

        /** 问卷描述 **/
        @Excel(name = "问卷描述")
        private String description;

        /** 开始时间 **/
        @Excel(name = "开始时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date startTime;

        /** 结束时间 **/
        @Excel(name = "结束时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date endTime;

        /** 状态 **/
        @Excel(name = "状态")
        private String status;

        /** 是否允许重复填写 **/
        @Excel(name = "是否允许重复填写")
        private String allowRepeat;

        /** 备注 **/
        @Excel(name = "备注")
        private String remark;

        /** 创建时间 **/
        @Excel(name = "创建时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date createTime;

        /** 创建人 **/
        @Excel(name = "创建人")
        private String createBy;

        /** 更新时间 **/
        @Excel(name = "更新时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date updateTime;

        /** 更新人 **/
        @Excel(name = "更新人")
        private String updateBy;

        /** 删除标志（0代表存在 2代表删除） */
        @Excel(name = "删除标志")
        private String delFlag;

        // 非持久化：创建/更新时一并传入的题目列表
        @Transient
        private List<SysQuestionnaireItem> items;
    }

    ```
2. SysQuestionnaireItem
    ```java
    /**
    * 问卷题目对象   sys_questionnaire_item
    * 
    * 对于任何阅读该代码的LLM模型，认真考虑问卷功能的实现逻辑，禁止自己猜测。
    * 问卷功能分为
    *  - meta: 问卷元数据（标题、描述、适用对象、时间范围等）
    *  - item: 题目（题干、选项、题目类型等）
    *  - submission: 用户每次提交的记录（哪个用户提交的、时间等）
    *  - answer: 每次提交中每题的回答（关联题目、答案内容等）
    * 
    * @author Must77
    */
    public class SysQuestionnaireItem {
        /** 题目ID **/
        @Excel(name = "题目ID")
        private Long itemId;
        
        /** 所属问卷ID **/
        @Excel(name = "所属问卷ID")
        private Long metaId;
        
        /** 题目类型: S-单选 M-多选 T-文本 Q-评分 **/
        @Excel(name = "题目类型")
        private String itemType; 

        /** 题目文本 **/
        @Excel(name = "题目文本")
        private String questionText;
        
        /** 是否必填 **/
        @Excel(name = "是否必填")
        private String required;
        
        /** 排序 **/
        @Excel(name = "排序")
        private Integer orderNum;

        /** 备注 **/
        @Excel(name = "备注")
        private String remark;

        /** 创建时间 **/
        @Excel(name = "创建时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date createTime;

        /** 创建人 **/
        @Excel(name = "创建人")
        private String createBy;

        /** 更新时间 **/
        @Excel(name = "更新时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date updateTime;

        /** 更新人 **/
        @Excel(name = "更新人")
        private String updateBy;

        /** 删除标志（0代表存在 2代表删除） */
        @Excel(name = "删除标志")
        private String delFlag;
    }

    ```
3. SysQuestionnaireSubmission
    ```java
    public class SysQuestionnaireSubmission {

        /** 提交ID **/
        @Excel(name = "提交ID")
        private Long submissionId;

        /** 问卷ID **/
        @Excel(name = "问卷ID")
        private Long metaId;

        /** 用户ID **/
        @Excel(name = "用户ID")
        private Long userId;

        /** 部门ID **/
        @Excel(name = "部门ID")
        private Long deptId;

        /** 提交时间 **/
        @Excel(name = "提交时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date submitTime;

        /** 提交来源IP地址 **/
        @Excel(name = "提交来源IP地址")
        private String ipAddr;

        /** 备注 **/
        @Excel(name = "备注")
        private String remark;

        /** 创建时间 **/
        @Excel(name = "创建时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date createTime;

        /** 创建人 **/
        @Excel(name = "创建人")
        private String createBy;

        /** 更新时间 **/
        @Excel(name = "更新时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date updateTime;

        /** 更新人 **/
        @Excel(name = "更新人")
        private String updateBy;

        /** 删除标志（0代表存在 2代表删除） */
        @Excel(name = "删除标志")
        private String delFlag;

    }
    ```
4. SysQuestionnaireAnswer
    ```java
    public class SysQuestionnaireAnswer {
        /** 答案ID **/
        @Excel(name = "答案ID")
        private Long answerId;

        /** 提交ID **/
        @Excel(name = "提交ID")
        private Long submissionId;

        /** 问卷ID **/
        @Excel(name = "问卷ID")
        private Long metaId;

        /** 题目ID **/
        @Excel(name = "题目ID")
        private Long itemId;

        /** 用户ID **/
        @Excel(name = "用户ID")
        private Long userId;

        /** 评分 **/
        @Excel(name = "评分")
        private Integer score;

        /** 文本答案 **/
        @Excel(name = "文本答案")
        private String textAnswer;

        /** 备注 **/
        @Excel(name = "备注")
        private String remark;

        /** 创建时间 **/
        @Excel(name = "创建时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date createTime;

        /** 创建人 **/
        @Excel(name = "创建人")
        private String createBy;

        /** 更新时间 **/
        @Excel(name = "更新时间")
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date updateTime;

        /** 更新人 **/
        @Excel(name = "更新人")
        private String updateBy;

        /** 删除标志（0代表存在 2代表删除） */
        @Excel(name = "删除标志")
        private String delFlag;
    }
    ```
## 接口
### meta相关
1. 新增问卷

    注意到, SysQuestionnaireMeta中有非持久化字段items, 用于前端创建问卷meta+item时临时接收item
    ```
    URL:        POST /system/questionnaire
    参数:       SysQuestionnaireMeta
    参数方式:   请求体参数
    返回值:     影响的行数
    ```

2.  删除问卷
    ```
    URL:        DELETE /system/questionnaire/{questionnaireMetaIds}
    参数:       Long questionnaireMetaIds
    参数方式:   路径参数, 允许传多个
    返回值:     影响的行数
    ```

3. 修改问卷

    只传入meta时只修改meta, 如果使用SysQuestionnaireMeta中的非持久化字段items, 系统就会认为本次同时要修改meta和item, 此时也会同时修改meta和item
    ```
    URL:        PUT /system/questionnaire
    参数:       SysquestionnaireMeta
    参数方式:   请求体参数
    返回值:     影响的行数
    ```

4. 根据metaId查找问卷
    ```
    URL:        GET /system/questionnaire/{questionnaireMetaId}
    参数:       Long questionnaireMetaId
    参数方式:   路径参数
    返回值:     SysQuestionnaireMeta
    ```

5. 条件筛选问卷
    ```
    URL:        GET /system/questionnaire/list
    参数:       SysQuestionnaireMeta
    参数方式:   路径参数自动绑定到类对象
    返回值:     List<SysQuestionnaireMeta>
    ```

### item相关

1. 新增题目

    使用**新增问卷**功能新增题目, 不再提供单独的新增题目接口
    ```
    URL:        POST /system/questionnaire/
    参数:       SysQuestionnaireMeta
    参数方式:   请求体参数
    ```

2. 删除题目

    使用**修改问卷**功能修改题目, 不再提供单独的删除题目接口
    ```
    URL:        PUT /system/questionnaire
    参数:       SysQuestionnaireMeta
    参数方式:   请求体参数
    返回值:     影响的行数
    ```

3. 修改题目

    使用**修改问卷**功能修改题目, 不再提供单独的修改题目接口
    ```
    URL:        PUT /system/questionnaire
    参数:       SysQuestionnaireMeta
    参数方式:   请求体参数
    返回值:     影响的行数
    ```

4. 查看问卷的题目

    ```
    URL:        GET /system/questionnaire/{metaId}/items
    参数:       Long metaId
    参数方式:   路径参数
    返回值:     List<SysQuestionnaireItem>
    ```

### submission相关
1. 条件查询作答记录

    ```
    URL:        GET /system/questionnaire/submission/list
    参数:       SysQuestionnaireSubmission
    参数方式:   路径参数自动绑定到请求体
    返回值:     List<SysQuestionnaireSubmission>
    ```

2. 根据submissionId查询作答记录

    ```
    URL:        GET /system/questionnaire/{submissionId}
    参数:       Long submissionId
    参数方式:   路径参数
    返回值:     SysQuestionnaireSubmission
    ```

3. 查看单个问卷的作答记录
    ```
    URL:        GET /system/questionnaire/{questionnaireMetaId}/submissions
    参数:       Long questionnaireMetaId
    参数方式:   路径参数
    返回值:     List<SysQuestionnaireSubmission>
    ```

### answer相关
1. 用户提交问卷
    ```
    URL:        POST /system/questionnaire/{questionnaireMetaId}/submit
    参数:       Long questionnaireMetaId, SysQuestionnaireSubmission submission
    参数方式:   路径参数和请求体参数
    返回值:     影响的行数
    ```

2. 查看用户提交的答案

    TODO: URL改为 /system/questionnaire/submission/{submissionId}/answers
    ```
    URL:        GET /system/questionnaire/answers/{submissionId}
    参数:       Long submissionId
    参数方式:   路径参数
    返回值:     List<SysQuestionnaireAnswer>
    ```

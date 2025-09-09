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
    private String name;
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
1. 根据班级Id查询所有的签到
    - admin
    ```
    URL:        GET ~/system/signin/list/{signinId}
    参数:       Long signinId
    参数方式:   路径参数
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


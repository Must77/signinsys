# 班级管理 API 接口文档

## 接口基础信息

- 基础URL: `/system/class`
- 所有接口均使用 GET 方法
- 返回格式: JSON

## 通用响应结构

所有接口返回的数据都遵循以下结构：

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {}
}
```

对于分页接口，返回的数据结构为：

```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [],
  "total": 0
}
```

## 接口列表

### 1. 查询班级列表

**接口地址**: `/system/class/list`

**请求方法**: GET

**请求参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| query  | Object | 否 | 查询条件 |

**响应数据 (rows)**:
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "deptId": 1,
      "deptName": "一班",
      "startTime": "2025-01-01 09:00:00",
      "endTime": "2025-06-30 17:00:00",
      "size": 30,
      "status": "进行中"
    }
  ],
  "total": 1
}
```

### 2. 查询进行中的班级

**接口地址**: `/system/class/ongoing`

**请求方法**: GET

**请求参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| query  | Object | 否 | 查询条件 |

**响应数据**:
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "deptId": 1,
      "deptName": "一班",
      "startTime": "2025-01-01 09:00:00",
      "endTime": "2025-06-30 17:00:00",
      "size": 30,
      "status": "进行中"
    }
  ],
  "total": 1
}
```

### 3. 查询已完结的班级

**接口地址**: `/system/class/finished`

**请求方法**: GET

**请求参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| query  | Object | 否 | 查询条件 |

**响应数据**:
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "deptId": 2,
      "deptName": "二班",
      "startTime": "2024-01-01 09:00:00",
      "endTime": "2024-06-30 17:00:00",
      "size": 28,
      "status": "已完结"
    }
  ],
  "total": 1
}
```

### 4. 查询待发布的班级

**接口地址**: `/system/class/unpublished`

**请求方法**: GET

**请求参数**:
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| query  | Object | 否 | 查询条件 |

**响应数据**:
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "deptId": 3,
      "deptName": "三班",
      "startTime": "2025-09-01 09:00:00",
      "endTime": "2026-02-28 17:00:00",
      "size": 32,
      "status": "待发布"
    }
  ],
  "total": 1
}
```

## 数据字段说明

| 字段名 | 类型 | 示例 | 说明 |
|--------|------|------|------|
| deptId | Long | 1 | 班级ID |
| deptName | String | 一班 | 班级名称 |
| startTime | String | 2025-01-01 09:00:00 | 班级开始时间 |
| endTime | String | 2025-06-30 17:00:00 | 班级结束时间 |
| size | Integer | 30 | 学员人数 |
| status | String | 进行中 | 班级状态（进行中/已完结/待发布） |

## 响应码说明

| 响应码 | 说明 |
|--------|------|
| 200 | 请求成功 |
| 401 | 认证失败，需要重新登录 |
| 500 | 服务器内部错误 |

## 前端调用示例

```javascript
import { listOngoingClass, listFinishedClass, listUnpublishedClass } from '@/api/system/class'

// 获取进行中的班级
listOngoingClass().then(response => {
  console.log('进行中的班级:', response.rows)
}).catch(error => {
  console.error('获取进行中的班级失败:', error)
})

// 获取已完结的班级
listFinishedClass().then(response => {
  console.log('已完结的班级:', response.rows)
}).catch(error => {
  console.error('获取已完结的班级失败:', error)
})

// 获取待发布的班级
listUnpublishedClass().then(response => {
  console.log('待发布的班级:', response.rows)
}).catch(error => {
  console.error('获取待发布的班级失败:', error)
})
```

## 注意事项

1. 所有接口都需要用户登录后才能访问
2. 如果返回401错误，需要重新登录系统
3. 响应数据可能包含rows或data字段，请根据实际情况处理
4. 时间字段格式为: `yyyy-MM-dd HH:mm:ss`
import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/**
 * Note: 路由配置项
 *
 * hidden: true                     // 当设置 true 的时候该路由不会再侧边栏出现 如401，login等页面，或者如一些编辑页面/edit/1
 * alwaysShow: true                 // 当你一个路由下面的 children 声明的路由大于1个时，自动会变成嵌套的模式--如组件页面
 *                                  // 只有一个时，会将那个子路由当做根路由显示在侧边栏--如引导页面
 *                                  // 若你想不管路由下面的 children 声明的个数都显示你的根路由
 *                                  // 你可以设置 alwaysShow: true，这样它就会忽略之前定义的规则，一直显示根路由
 * redirect: noRedirect             // 当设置 noRedirect 的时候该路由在面包屑导航中不可被点击
 * name:'router-name'               // 设定路由的名字，一定要填写不然使用<keep-alive>时会出现各种问题
 * query: '{"id": 1, "name": "ry"}' // 访问路由的默认传递参数
 * roles: ['admin', 'common']       // 访问路由的角色权限
 * permissions: ['a:a:a', 'b:b:b']  // 访问路由的菜单权限
 * meta : {
    noCache: true                   // 如果设置为true，则不会被 <keep-alive> 缓存(默认 false)
    title: 'title'                  // 设置该路由在侧边栏和面包屑中展示的名字
    icon: 'svg-name'                // 设置该路由的图标，对应路径src/assets/icons/svg
    breadcrumb: false               // 如果设置为false，则不会在breadcrumb面包屑中显示
    activeMenu: '/system/user'      // 当路由设置了该属性，则会高亮相对应的侧边栏。
  }
 */

// 公共路由
export const constantRoutes = [
  {
    path: '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: () => import('@/views/redirect')
      }
    ]
  },
  // 放在 constantRoutes 数组里
{
  path: '/course/:courseId(\\d+)/resource',
  component: () => import('@/views/system/deptCourse/resource.vue'),
  name: 'CourseResource',
  hidden: true,
  meta: { title: '课程资源管理', icon: 'folder', activeMenu: '/system/deptCourse' }
},
  {
    path: '/system/questionnaire',
    component: Layout,
    hidden: true,
    children: [
      {
        path: 'userList',
        component: () => import('@/views/system/questionnaire/userList.vue'),
        name: 'UserQuestionnaireList',
        meta: { title: '问卷列表', icon: 'form' }
      },
      {
        path: 'userSubmit/:questionnaireMetaId(\\d+)',
        component: () => import('@/views/system/questionnaire/userSubmit.vue'),
        name: 'UserQuestionnaireSubmit',
        meta: { title: '填写问卷', icon: 'form' },
        hidden: true
      }
    ]
  },
  {
    path: '/class-display/index',
    
        component: () => import('@/views/system/classDisplay/index.vue'),
        name: 'ClassDisplay',
        hidden: true,
        meta: { title: '班级广场', icon: 'peoples' }
      
  },
  {
    path: '/system/myCourse/index',
    
        component: () => import('@/views/system/myCourse/index.vue'),
        name: 'MyCourse',
        hidden: true,
        meta: { title: '我的课程', icon: 'education' }
      
    
  },
  {
    path: '/system/mySignin/index',
    
        component: () => import('@/views/system/mySignin/index.vue'),
        name: 'MySignin',
        hidden: true,
        meta: { title: '我的签到', icon: 'education' }
      },
    {
    path: '/system/leave/index',
    
        component: () => import('@/views/system/myLeave/index.vue'),
        name: 'Leave',
        hidden: true,
        meta: { title: '我的请假', icon: 'documentation' }
     
  },
  {
    path: '/login',
    component: () => import('@/views/login'),
    hidden: true
  },
  {
    path: '/register',
    component: () => import('@/views/register'),
    hidden: true
  },
  {
    path: '/mobile',
    component: () => import('@/views/mobile/Home'),
    hidden: true
  },
  {
    path: '/mobile/notice',
    component: () => import('@/views/mobile/Notice'),
    hidden: true
  },
  {
  path: '/mobile/user/profile',
  component: () => import('@/views/system/user/profile/index'),
  name: 'MobileProfile',
  hidden: true,
  meta: { title: '个人中心' }
},
{
  path: '/mobile/questionnaire/userList',
  component: () => import('@/views/system/questionnaire/userList.vue'),
  name: 'MobileQuestionnaireList',
  hidden: true,
  meta: { title: '问卷列表' }
},
{
  path: '/mobile/questionnaire/userSubmit/:questionnaireMetaId(\\d+)',
  component: () => import('@/views/system/questionnaire/userSubmit.vue'),
  name: 'MobileUserQuestionnaireSubmit',
  hidden: true,
  meta: { title: '填写问卷' }
},
  {
    path: '/404',
    component: () => import('@/views/error/404'),
    hidden: true
  },
  {
    path: '/401',
    component: () => import('@/views/error/401'),
    hidden: true
  },
  {
    path: '',
    component: Layout,
    redirect: 'index',
    children: [
      {
        path: 'index',
        component: () => import('@/views/index'),
        name: 'Index',
        meta: { title: '首页', icon: 'dashboard', noCache: true, affix: true }
      }
    ]
  },
  {
    path: '/user',
    component: Layout,
    hidden: true,
    redirect: 'noredirect',
    children: [
      {
        path: 'profile',
        component: () => import('@/views/system/user/profile/index'),
        name: 'Profile',
        meta: { title: '个人中心', icon: 'user' }
      }
    ]
  },
  
]

// 动态路由，基于用户权限动态去加载
export const dynamicRoutes = [
  
  {
    path: '/system/user-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:user:edit'],
    children: [
      {
        path: 'role/:userId(\\d+)',
        component: () => import('@/views/system/user/authRole'),
        name: 'AuthRole',
        meta: { title: '分配角色', activeMenu: '/system/user' }
      }
    ]
  },
  {
    path: '/system/role-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:role:edit'],
    children: [
      {
        path: 'user/:roleId(\\d+)',
        component: () => import('@/views/system/role/authUser'),
        name: 'AuthUser',
        meta: { title: '分配用户', activeMenu: '/system/role' }
      }
    ]
  },
  {
    path: '/system/dict-data',
    component: Layout,
    hidden: true,
    permissions: ['system:dict:list'],
    children: [
      {
        path: 'index/:dictId(\\d+)',
        component: () => import('@/views/system/dict/data'),
        name: 'Data',
        meta: { title: '字典数据', activeMenu: '/system/dict' }
      }
    ]
  },
  {
    path: '/system/mySignin',
    component: Layout,
    hidden: false,
    children: [
      {
        path: 'index',
        component: () => import('@/views/system/mySignin/index'),
        name: 'MySignin',
        meta: { title: '我的签到', icon: 'form', activeMenu: '/system/mySignin' }
      }
    ]
  },
  {
    path: '/monitor/job-log',
    component: Layout,
    hidden: true,
    permissions: ['monitor:job:list'],
    children: [
      {
        path: 'index/:jobId(\\d+)',
        component: () => import('@/views/monitor/job/log'),
        name: 'JobLog',
        meta: { title: '调度日志', activeMenu: '/monitor/job' }
      }
    ]
  },
  {
    path: '/tool/gen-edit',
    component: Layout,
    hidden: true,
    permissions: ['tool:gen:edit'],
    children: [
      {
        path: 'index/:tableId(\\d+)',
        component: () => import('@/views/tool/gen/editTable'),
        name: 'GenEdit',
        meta: { title: '修改生成配置', activeMenu: '/tool/gen' }
      }
    ]
  },
  // 新增的课程资源管理路由
  {
    path: '/course/:courseId(\\d+)/resource',
    component: () => import('@/views/system/deptCourse/resource.vue'),
    name: 'CourseResource',
    hidden: true,
    meta: { title: '课程资源管理', icon: 'folder', activeMenu: '/system/deptCourse' }
  },

  {
    path: '/system/myCourse/resource/:courseId',
    component: () => import('@/views/system/myCourse/resource.vue'),
    name: 'MyCourseResource',
    meta: { title: '我的课程资源', icon: '' }
  },
  {
    path: '/system/questionnaire',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/system/questionnaire/userList',
        component: () => import('@/views/system/questionnaire/userList'),
        name: 'QuestionnaireUserList',
        meta: { title: '问卷提交记录', icon: '' }
      },
    ]
  },
{
  path: '/system/notice',
  component: Layout,
  hidden: true,
  children: [
    {
      path: 'index',
      component: () => import('@/views/system/notice/index'),
      name: 'Notice',
      meta: { title: '通知公告', icon: 'message' }
    }
  ]
}
]

// 防止连续点击多次路由报错
let routerPush = Router.prototype.push
let routerReplace = Router.prototype.replace
// push
Router.prototype.push = function push(location) {
  return routerPush.call(this, location).catch(err => err)
}
// replace
Router.prototype.replace = function push(location) {
  return routerReplace.call(this, location).catch(err => err)
}

const router = new Router({
  mode: 'history',
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

// 添加详细的路由调试
router.beforeEach((to, from, next) => {
  console.log('=== 路由跳转调试信息 ===')
  console.log('目标路径:', to.path)
  console.log('完整路径:', to.fullPath)
  console.log('匹配的路由记录:', to.matched)
  console.log('路由名称:', to.name)
  console.log('=====================')
  next()
})

router.afterEach((to, from) => {
  console.log('路由跳转完成，当前路径:', to.path)
  console.log('匹配的组件:', to.matched.map(m => m.components.default))
})

export default new Router({
  mode: 'history', // 去掉url中的#
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

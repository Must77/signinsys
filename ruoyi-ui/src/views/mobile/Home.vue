<template>
  <div class="mobile-home">
    <div class="header">
      <h1>签到系统</h1>
      <p>欢迎使用移动端签到系统</p>
    </div>

    <div class="menu-grid">
      <div v-for="item in menuItems" :key="item.path" class="menu-item" @click="goToPage(item)">
        <i :class="item.icon" class="menu-icon"></i>
        <span class="menu-text">{{ item.title }}</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MobileHome',
  data() {
    return {
      menuItems: [
        {
          path: '/mobile/notice',
          title: '通知管理',
          icon: 'el-icon-message'
        },
        {
          path: '/class-display/index',
          title: '班级广场',
          icon: 'el-icon-school'
        },
        {
          path: '/system/myCourse/index',
          title: '我的课程',
          icon: 'el-icon-collection'
        },
        {
          path: '/system/mySignin/index',
          title: '我的签到',
          icon: 'el-icon-date'
        },
        {
          path: '/system/leave/index',
          title: '我的请假',
          icon: 'el-icon-document'
        },
        {
          path: '/mobile/questionnaire/userList', // 使用移动端专用路径
          title: '填写问卷',
          icon: 'el-icon-edit-outline'
        },
        {
          path: '/mobile/user/profile', // 使用移动端专用路径
          title: '个人中心',
          icon: 'el-icon-user'
        }
      ]
    }
  },
  methods: {
    goToPage(item) {
      if (item.external) {
        // 外部链接
        window.open(item.path, '_blank');
      } else {
        // 内部路由
        this.$router.push(item.path);
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.mobile-home {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

.header {
  text-align: center;
  margin-bottom: 30px;
  padding: 20px 0;

  h1 {
    font-size: 24px;
    color: #303133;
    margin-bottom: 10px;
  }

  p {
    font-size: 16px;
    color: #606266;
  }
}

.menu-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.menu-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px 10px;
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.15);
  }

  .menu-icon {
    font-size: 28px;
    color: #8B0000;
    margin-bottom: 10px;
  }

  .menu-text {
    font-size: 14px;
    color: #606266;
  }
}

@media screen and (max-width: 768px) {
  .menu-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
  }

  .menu-item {
    padding: 15px 5px;
  }

  .menu-icon {
    font-size: 24px !important;
  }

  .menu-text {
    font-size: 12px !important;
  }
}
</style>
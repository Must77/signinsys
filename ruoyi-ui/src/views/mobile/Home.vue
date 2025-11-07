<template>
  <div class="mobile-home">
    <!-- 顶部红色背景区域 -->
    <div class="top-section">
      <div class="header-content">
        <div class="party-emblem">
          <div class="emblem-icon">★</div>
        </div>
        <div class="title-content">
          <h1 class="system-title">干部培训签到系统</h1>
          <p class="system-subtitle">强化理论武装 • 提升履职能力</p>
        </div>
      </div>
      
      <div class="user-info">
        
        
      </div>
      <div class="red-background-wave"></div>
    </div>

    <!-- 功能菜单区域 -->
    <div class="menu-section">
      <div class="menu-grid">
        <div 
          v-for="(item, index) in menuItems" 
          :key="item.path" 
          class="menu-item"
          :class="`red-theme-${(index % 3) + 1}`"
          @click="goToPage(item)"
        >
          <div class="menu-icon-wrapper">
            <i :class="item.icon" class="menu-icon"></i>
          </div>
          <span class="menu-text">{{ item.title }}</span>
          <div class="menu-corner">
            <i class="el-icon-arrow-right"></i>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部红色装饰 -->
    <div class="bottom-red-decoration">
      <div class="red-circle circle-1"></div>
      <div class="red-circle circle-2"></div>
      <div class="red-circle circle-3"></div>
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
          path: '/mobile/questionnaire/userList',
          title: '填写问卷',
          icon: 'el-icon-edit-outline'
        },
        {
          path: '/mobile/user/profile',
          title: '个人中心',
          icon: 'el-icon-user'
        }
      ]
    }
  },
  methods: {
    goToPage(item) {
      if (item.external) {
        window.open(item.path, '_blank');
      } else {
        this.$router.push(item.path);
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.mobile-home {
  min-height: 100vh;
  background: linear-gradient(135deg, #8B0000 0%, #C00000 50%, #8B0000 100%);
  position: relative;
  overflow: hidden;
}

/* 顶部区域样式 */
.top-section {
  position: relative;
  padding: 30px 20px 60px;
  color: white;
  background: linear-gradient(135deg, #8B0000 0%, #C00000 100%);
}

.header-content {
  display: flex;
  align-items: center;
  margin-bottom: 25px;
  z-index: 2;
  position: relative;
}

.party-emblem {
  margin-right: 15px;
  
  .emblem-icon {
    font-size: 32px;
    width: 50px;
    height: 50px;
    background: gold;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
    color: #8B0000;
    font-weight: bold;
  }
}

.title-content {
  .system-title {
    font-size: 22px;
    font-weight: bold;
    margin: 0 0 8px 0;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
    letter-spacing: 1px;
  }
  
  .system-subtitle {
    font-size: 14px;
    margin: 0;
    opacity: 0.9;
    letter-spacing: 0.5px;
    color: rgba(255, 255, 255, 0.9);
  }
}

.user-info {
  display: flex;
  align-items: center;
  z-index: 2;
  position: relative;
}

.avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.avatar i {
  font-size: 28px;
  color: white;
}

.welcome-text h2 {
  font-size: 20px;
  font-weight: 600;
  margin: 0 0 5px 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.welcome-text p {
  font-size: 14px;
  margin: 0;
  opacity: 0.9;
}

.red-background-wave {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 120" preserveAspectRatio="none"><path d="M321.39,56.44c58-10.79,114.16-30.13,172-41.86,82.39-16.72,168.19-17.73,250.45-.39C823.78,31,906.67,72,985.66,92.83c70.05,18.48,146.53,26.09,214.34,3V0H0V27.35A600.21,600.21,0,0,0,321.39,56.44Z" fill="rgba(178,34,34,0.3)"></path></svg>');
  background-size: cover;
  background-position: center;
}

/* 菜单区域样式 */
.menu-section {
  position: relative;
  z-index: 2;
  padding: 0 20px 40px;
}

.menu-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.menu-item {
  background: white;
  border-radius: 16px;
  padding: 20px 15px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 8px 25px rgba(139, 0, 0, 0.15);
  overflow: hidden;
  border: 1px solid #ffeaea;
  
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, var(--color), var(--color-light));
  }
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 30px rgba(139, 0, 0, 0.2);
  }
}

/* 红色主题配色 */
.menu-item.red-theme-1 {
  --color: #8B0000;
  --color-light: #C00000;
}

.menu-item.red-theme-2 {
  --color: #B22222;
  --color-light: #DC143C;
}

.menu-item.red-theme-3 {
  --color: #C00000;
  --color-light: #FF0000;
}

.menu-icon-wrapper {
  width: 60px;
  height: 60px;
  border-radius: 16px;
  background: linear-gradient(135deg, var(--color), var(--color-light));
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 12px;
  box-shadow: 0 4px 15px rgba(139, 0, 0, 0.2);
}

.menu-icon {
  font-size: 28px;
  color: white;
}

.menu-text {
  font-size: 14px;
  font-weight: 600;
  color: #2c3e50;
  text-align: center;
  margin-bottom: 8px;
}

.menu-corner {
  position: absolute;
  top: 15px;
  right: 15px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: rgba(139, 0, 0, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
}

.menu-corner i {
  font-size: 12px;
  color: #8B0000;
}

/* 底部红色装饰 */
.bottom-red-decoration {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 100px;
  overflow: hidden;
}

.red-circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
}

.circle-1 {
  width: 80px;
  height: 80px;
  bottom: -40px;
  left: 10%;
}

.circle-2 {
  width: 120px;
  height: 120px;
  bottom: -60px;
  right: 15%;
}

.circle-3 {
  width: 60px;
  height: 60px;
  bottom: 20px;
  left: 60%;
}

/* 响应式设计 */
@media screen and (max-width: 380px) {
  .menu-grid {
    grid-template-columns: 1fr;
    gap: 12px;
  }
  
  .menu-item {
    padding: 18px 12px;
  }
  
  .menu-icon-wrapper {
    width: 50px;
    height: 50px;
  }
  
  .menu-icon {
    font-size: 24px;
  }
  
  .menu-text {
    font-size: 13px;
  }
  
  .system-title {
    font-size: 18px !important;
  }
  
  .system-subtitle {
    font-size: 12px !important;
  }
}

@media screen and (min-width: 768px) {
  .menu-grid {
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
  }
  
  .top-section {
    padding: 40px 30px 80px;
  }
  
  .menu-section {
    padding: 0 30px 50px;
  }
}

/* 动画效果 */
@keyframes red-float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-8px);
  }
}

.menu-item:hover .menu-icon-wrapper {
  animation: red-float 1s ease-in-out infinite;
}

/* 滚动条样式优化 */
.mobile-home::-webkit-scrollbar {
  width: 6px;
}

.mobile-home::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
}

.mobile-home::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
}

.mobile-home::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

/* 金色点缀效果 */
.menu-item::after {
  content: '';
  position: absolute;
  top: 8px;
  right: 8px;
  width: 8px;
  height: 8px;
  background: gold;
  border-radius: 50%;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.menu-item:hover::after {
  opacity: 1;
}
</style>
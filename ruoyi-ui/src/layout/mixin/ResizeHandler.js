import store from '@/store'
import router from '@/router'

const { body } = document
const WIDTH = 992 // refer to Bootstrap's responsive design

export default {
  watch: {
    $route(route) {
      if (this.device === 'mobile' && this.sidebar.opened) {
        store.dispatch('app/closeSideBar', { withoutAnimation: false })
      }
    }
  },
  beforeMount() {
    window.addEventListener('resize', this.$_resizeHandler)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.$_resizeHandler)
  },
  mounted() {
    const isMobile = this.$_isMobile()
    if (isMobile) {
      store.dispatch('app/toggleDevice', 'mobile')
      store.dispatch('app/closeSideBar', { withoutAnimation: true })
      // 检查用户角色，只有common用户才跳转到移动端首页
      const roles = store.getters.roles;
      const isCommonUser = roles.includes('common') && !roles.includes('admin') && !roles.includes('manager');
      // 如果当前不是移动端首页，且用户是common用户，则跳转到移动端首页
      if (this.$route.path !== '/mobile' && isCommonUser) {
        router.push('/mobile')
      }
    }
  },
  methods: {
    // use $_ for mixins properties
    // https://vuejs.org/v2/style-guide/index.html#Private-property-names-essential
    $_isMobile() {
      const rect = body.getBoundingClientRect()
      return rect.width - 1 < WIDTH
    },
    $_resizeHandler() {
      if (!document.hidden) {
        const isMobile = this.$_isMobile()
        store.dispatch('app/toggleDevice', isMobile ? 'mobile' : 'desktop')

        if (isMobile) {
          store.dispatch('app/closeSideBar', { withoutAnimation: true })
          // 检查用户角色，只有common用户才跳转到移动端首页
          const roles = store.getters.roles;
          const isCommonUser = roles.includes('common') && !roles.includes('admin') && !roles.includes('manager');
          // 如果当前不是移动端首页，且用户是common用户，则跳转到移动端首页
          if (this.$route.path !== '/mobile' && isCommonUser) {
            router.push('/mobile')
          }
        } else {
          // 如果是桌面端且当前在移动端首页，则跳转到常规首页
          if (this.$route.path === '/mobile') {
            router.push('/index')
          }
        }
      }
    }
  }
}
export default {
  name: 'Login',
  data() {
    return {
      // ... existing data ...
    }
  },
  methods: {
    // ... existing methods ...
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          login(this.loginForm).then(response => {
            setToken(response.token)
            this.$store.dispatch('user/Login', this.loginForm).then(() => {
              // 登录成功后重定向到首页
              this.$router.push({ path: '/' })
            }).catch(error => {
              console.error('Login failed:', error)
            })
          }).catch(error => {
            console.error('Login request failed:', error)
          })
        }
      })
    }
  }
}
<template>
  <div class="login">
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
      <h3 class="title">{{ title }}</h3>
      
      <!-- 登录方式切换 -->
      <el-tabs v-model="activeLoginType" @tab-click="handleLoginTypeChange">
        <el-tab-pane label="账号密码登录" name="password"></el-tab-pane>
        <el-tab-pane label="手机验证码登录" name="sms"></el-tab-pane>
      </el-tabs>
      
      <!-- 账号密码登录 -->
      <div v-show="activeLoginType === 'password'">
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" type="text" auto-complete="off" placeholder="账号">
            <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="loginForm.password" type="password" auto-complete="off" placeholder="密码"
            @keyup.enter.native="handleLogin">
            <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
          </el-input>
        </el-form-item>
      </div>
      
      <!-- 手机验证码登录 -->
      <div v-show="activeLoginType === 'sms'">
        <el-form-item prop="phoneNumber">
          <el-input v-model="loginForm.phoneNumber" type="text" auto-complete="off" placeholder="手机号码">
            <svg-icon slot="prefix" icon-class="phone" class="el-input__icon input-icon" />
          </el-input>
        </el-form-item>
        <el-form-item prop="smsCode" style="position: relative;">
          <el-input v-model="loginForm.smsCode" auto-complete="off" placeholder="短信验证码" style="width: 65%"
            @keyup.enter.native="handleLogin">
            <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
          </el-input>
          <el-button type="primary" :disabled="smsCodeDisabled" @click="sendSmsCode" style="position: absolute; right: 0; top: 0;">
            {{ smsCodeButtonText }}
          </el-button>
        </el-form-item>
      </div>
      
      <!-- <el-form-item prop="code" v-if="captchaEnabled">
        <el-input v-model="loginForm.code" auto-complete="off" placeholder="验证码" style="width: 63%"
          @keyup.enter.native="handleLogin">
          <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
        </el-input>
        <div class="login-code">
          <img :src="codeUrl" @click="getCode" class="login-code-img" />
        </div>
      </el-form-item> -->
      <el-checkbox v-model="loginForm.rememberMe" style="margin:0px 0px 25px 0px;">记住密码</el-checkbox>
      <el-form-item style="width:100%;">
        <el-button :loading="loading" size="medium" type="primary" style="width:100%;"
          @click.native.prevent="handleLogin">
          <span v-if="!loading">登 录</span>
          <span v-else>登 录 中...</span>
        </el-button>
        <div style="float: right;" v-if="register">
          <router-link class="link-type" :to="'/register'">立即注册</router-link>
        </div>
      </el-form-item>
    </el-form>
    <!--  底部  -->
    <div class="el-login-footer">
      <span>欢迎使用中国地质调查局干部培训中心签到系统</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg, login, loginWithSms, sendSmsCode } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'
import { setToken } from '@/utils/auth'

export default {
  name: "Login",
  data() {
    // 手机号验证规则
    var validatePhone = (rule, value, callback) => {
      const reg = /^1[3|4|5|7|8|9][0-9]\d{8}$/
      if (!reg.test(value)) {
        callback(new Error('请输入正确的手机号'))
      } else {
        callback()
      }
    }
    
    return {
      title: process.env.VUE_APP_TITLE,
      codeUrl: "",
      activeLoginType: "password", // 当前登录方式 password: 账号密码登录, sms: 手机验证码登录
      smsCodeDisabled: false, // 短信验证码按钮是否禁用
      smsCodeButtonText: "获取验证码", // 短信验证码按钮文字
      smsCodeTimer: null, // 短信验证码倒计时器
      smsCodeCountdown: 60, // 短信验证码倒计时
      loginForm: {
        username: "admin",
        password: "admin123",
        phoneNumber: "", // 手机号码
        smsCode: "", // 短信验证码
        rememberMe: false,
        code: "",
        uuid: ""
      },
      loginRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" }
        ],
        phoneNumber: [
          { required: true, trigger: "blur", message: "请输入手机号码" },
          { validator: validatePhone, trigger: "blur" }
        ],
        smsCode: [
          { required: true, trigger: "blur", message: "请输入短信验证码" }
        ],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      // 验证码开关
      captchaEnabled: true,
      // 注册开关
      register: false,
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function (route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  created() {
    this.getCode()
    this.getCookie()
  },
  destroyed() {
    // 清除定时器
    if (this.smsCodeTimer) {
      clearInterval(this.smsCodeTimer)
    }
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.loginForm.uuid = res.uuid
        }
      })
    },
    getCookie() {
      const username = Cookies.get("username")
      const password = Cookies.get("password")
      const rememberMe = Cookies.get('rememberMe')
      this.loginForm = {
        username: username === undefined ? this.loginForm.username : username,
        password: password === undefined ? this.loginForm.password : decrypt(password),
        phoneNumber: "",
        smsCode: "",
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
      }
    },
    // 切换登录方式
    handleLoginTypeChange() {
      // 清除表单验证
      this.$refs.loginForm.clearValidate()
    },
    // 发送短信验证码
    sendSmsCode() {
      // 先验证手机号
      this.$refs.loginForm.validateField('phoneNumber', (errorMsg) => {
        if (errorMsg) {
          return
        }
        
        // 调用发送短信验证码接口
        sendSmsCode(this.loginForm.phoneNumber).then(res => {
          if (res.code === 200) {
            this.$message.success("短信验证码已发送，请注意查收！")
            
            // 设置倒计时
            this.smsCodeDisabled = true
            this.smsCodeButtonText = `${this.smsCodeCountdown}秒后重新获取`
            this.smsCodeTimer = setInterval(() => {
              this.smsCodeCountdown--
              this.smsCodeButtonText = `${this.smsCodeCountdown}秒后重新获取`
              if (this.smsCodeCountdown <= 0) {
                clearInterval(this.smsCodeTimer)
                this.smsCodeDisabled = false
                this.smsCodeButtonText = "获取验证码"
                this.smsCodeCountdown = 60
              }
            }, 1000)
          } else {
            this.$message.error(res.msg || "发送失败")
          }
        }).catch(error => {
          this.$message.error("发送验证码失败")
          console.error("发送验证码失败:", error)
        })
      })
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          
          // 如果是账号密码登录
          if (this.activeLoginType === 'password') {
            if (this.loginForm.rememberMe) {
              Cookies.set("username", this.loginForm.username, { expires: 30 })
              Cookies.set("password", encrypt(this.loginForm.password), { expires: 30 })
              Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 })
            } else {
              Cookies.remove("username")
              Cookies.remove("password")
              Cookies.remove('rememberMe')
            }
            
            // 调用账号密码登录接口
            login(this.loginForm.username, this.loginForm.password, this.loginForm.code, this.loginForm.uuid).then(res => {
              setToken(res.token)
              this.$store.commit('SET_TOKEN', res.token)
              this.$router.push({ path: this.redirect || "/" }).catch(() => { })
            }).catch(() => {
              this.loading = false
              if (this.captchaEnabled) {
                this.getCode()
              }
            })
          } 
          // 如果是手机验证码登录
          else if (this.activeLoginType === 'sms') {
            // 调用手机号验证码登录接口
            loginWithSms(this.loginForm.phoneNumber, this.loginForm.smsCode).then(res => {
              if (res.code === 200) {
                // 登录成功，设置token并跳转
                setToken(res.token)
                this.$store.commit('SET_TOKEN', res.token)
                this.$router.push({ path: this.redirect || "/" }).catch(() => { })
              } else {
                this.loading = false
                this.$message.error(res.msg || "登录失败")
              }
            }).catch(() => {
              this.loading = false
              this.$message.error("登录失败，请稍后重试")
            })
          }
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss">
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-image: url("../assets/images/login-background2.jpg");
  background-size: cover;
}

.title {
  margin: 0px auto 30px auto;
  text-align: center;
  color: #707070;
}

.login-form {
  border-radius: 6px;
  background: #ffffff;
  width: 400px;
  padding: 25px 25px 5px 25px;
  z-index: 1;

  .el-input {
    height: 38px;

    input {
      height: 38px;
    }
  }

  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 2px;
  }
}

.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}

.login-code {
  width: 33%;
  height: 38px;
  float: right;

  img {
    cursor: pointer;
    vertical-align: middle;
  }
}

.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: #fff;
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
}

.login-code-img {
  height: 38px;
}
</style>
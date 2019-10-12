<template>
  <div class="container">
    <header class="navbar " style="background: #cf9236">
      <el-row>
        <el-col :span="12" class="center">
          <span class="topText">欢迎来到集成应用系统</span>
        </el-col>
        <el-col :span="12" v-show="!hasLogin" class="center">
          <el-button type="default">登录</el-button>
        </el-col>
        <el-col :span="12" class="center" v-show="hasLogin">
          <el-dropdown trigger="click">
            <span class="el-dropdown-link">
              {{ username }}<i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item @click.native="showPasswordDialog">
                重置密码
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
          <el-button type="default" @click="loginOut()">退出</el-button>
        </el-col>
      </el-row>
    </header>
    <!-- 导航主页 开始-->
    <aside class="sidebar-container menu-expanded">
      <el-radio-group v-model="isCollapse" style="margin-bottom: 2px;">
        <el-radio-button :label="false" v-if="isCollapse">
          <i class="iconfont icon-icon_next_arrow"></i>
          <i class="iconfont icon-icon_next_arrow"></i>
        </el-radio-button>
        <el-radio-button :label="true" v-else>
          <i class="iconfont icon-icon_left"></i>
          <i class="iconfont icon-icon_left"></i>
        </el-radio-button>
      </el-radio-group>
      <el-menu
        :default-active="$route.path"
        mode="vertical"
        class="el-menu-vertical-demo menu-vertical"
        background-color="#545c64"
        text-color="#fff"
        active-text-color="#ffd04b"
        :collapse="isCollapse"
        unique-opened>
        <template v-for="parentTree in authorityTree">
          <el-submenu :index="parentTree.path">
            <template slot="title">
              <i :class="parentTree.icon"></i>
              <span>{{ parentTree.name }}</span>
            </template>
            <el-menu-item-group>
              <el-menu-item :index="childrenValue.path" v-for="(childrenValue,index) in parentTree.children"
                            :key="index">
                <router-link :to="childrenValue.path" tag="li">
                  <i :class="childrenValue.icon"></i>
                  {{ childrenValue.name }}
                </router-link>
              </el-menu-item>
            </el-menu-item-group>
          </el-submenu>
        </template>
      </el-menu>
    </aside>
    <!-- 内容主体区域 -->
    <main class="content-container left-collapsed">
      <transition name="fade" mode="out-in">
        <router-view/>
      </transition>
    </main>
    <!-- 导航主页 结束-->

    <!--修改密码的弹出框-->
    <el-dialog title="重置密码" :visible.sync="dialog.updatePasswordVisible">
      <el-form :model="userFrom" status-icon :rules="passwordRules" ref="userUpdateFrom" label-width="100px" class="demo-ruleForm">
        <el-form-item label="旧密码" prop="oldPassword">
          <el-input v-model="userFrom.oldPassword" type="password" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input  v-model="userFrom.newPassword" type="password" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input  v-model="userFrom.confirmPassword" type="password" auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitUpdateFrom('userUpdateFrom')">提交</el-button>
          <el-button @click="resetForm('userUpdateFrom')">重置</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>
<script>
  import VueCookie from 'vue-cookies'
  import axiosClient from '../client/axiosClient'

  export default {
    name: 'display',
    data () {
      const validateOldPassword = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('密码不能为空'));
        }
        callback()
      }
      const validateNewPassword = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请输入新密码'));
        } else {
          if (this.userFrom.confirmPassword !== '') {
            this.$refs.userUpdateFrom.validateField('confirmPassword');
          }
          callback()
        }
      }
      const validateConfirmPassword = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请再次输入密码'));
        } else if (value !== this.userFrom.newPassword) {
          callback(new Error('两次输入密码不一致!'))
        } else {
          callback();
        }
      }
      return {
        dialog: {
          updatePasswordVisible: false
        },
        isCollapse: false,
        hasLogin: false,
        userId: 0,
        username: '',
        active: true,
        form: {
          nameOrOther: '',
          password: ''
        },
        userPlaceholder: {
          password: '请输入密码',
          confirmPassword: '请输入确认密码'
        },
        userFrom: {
          id: '',
          oldPassword: '',
          newPassword: '',
          confirmPassword: ''
        },
        passwordRules: {
          oldPassword: [
            {validator: validateOldPassword, trigger: 'blur'}
          ],
          newPassword: [
            {validator: validateNewPassword, trigger: 'blur'}
          ],
          confirmPassword: [
            {validator: validateConfirmPassword, trigger: 'blur'}
          ]
        },
        authorityMap: new Map(),
        authorityTree: JSON.parse(window.sessionStorage.getItem('authorityTree')),
        formLabelWidth: '100px'
      }
    },
    mounted() {
      const token = VueCookie.get('token')
      // 如果token存在，则跳转到内容页面
      if (token) {
        const tokenVo = JSON.parse(token)
        this.hasLogin = true
        this.userId = tokenVo.userId
        this.userFrom.id = tokenVo.userId
        this.username = tokenVo.username
      }
    },

    methods: {
      loginOut() {
        axiosClient({
          method: 'post',
          url: 'to_login_out/' + this.userId
        }).then(response => {
          let data = response.data
          // 成功
          if (data.success) {
            VueCookie.remove('token')
            window.sessionStorage.removeItem('authorityTree')
            this.$router.push('/')
          } else {
            this.$message.error('退出平台失败，请联系管理员')
          }
        }).catch(() => {
          this.$message.error('登录平台网络异常，请联系管理员')
        })
      },
      submitUpdateFrom(formName) {
        this.$refs[formName].validate((valid) => {
          console.log(valid)
          if (valid) {
            this.toUpdatePassword()
            return true
          } else {
            return false;
          }
        })
      },
      resetForm (formName) {
        this.$refs[formName].resetFields();
      },
      toUpdatePassword () {
        this.loading = true
        axiosClient({
          url: 'user/to_update_password',
          method: 'post',
          data: this.userFrom
        }).then(response => {
          debugger
          this.dialog.updatePasswordVisible = false
          this.loading = false
          if (response.data.success) {
            this.$message.info('重置密码成功！')
            return
          }
          this.$message.error('请求返回异常!' + response.data.message)
        }).catch(error => {
          this.dialog.roleAddVisible = false
          this.loading = false
          this.$message.error('axiosAddOneUser: ' + error.message)
        })
      },
      showPasswordDialog() {
        this.dialog.updatePasswordVisible = true
      }
    }
  }
</script>

<style>
  @import url(//at.alicdn.com/t/font_549694_nrw9hz9yl2.css);

  .navbar {
    height: 40px;
    line-height: 40px;
    border-radius: 0px !important;
  }

  #app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: left;
    color: #2c3e50;
    min-width: 1200px;
    margin: 0 auto;
  }

  body {
    margin: 0;
  }

  /* 头部导航 */
  header {
    z-index: 1000;
    min-width: 1200px;
    transition: all 0.5s ease;
    border-top: solid 4px #3091F2;
    background-color: #fff;
    box-shadow: 0 2px 4px 0 rgba(0, 0, 0, .12), 0 0 6px 0 rgba(0, 0, 0, .04);
  }

  /* 主内容区 */
  main {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    min-height: 800px;
    border: solid 0px #E9ECF1;
    background-color: #FCFCFC;
  }

  .content-container {
    position: absolute;
    height: calc(100% - 40px);
    min-width: 800px;
    overflow: auto;
    background: #fff;
    flex: 1;
    padding: 10px;
  }

  .left-collapsed {
    left: 180px;
    width: calc(100% - 50px);
  }

  .sidebar-container {
    position: absolute;
    width: 180px;
    height: calc(100% - 40px);
  }

  .menu-expanded {
    width: 180px;
  }

  .menu-vertical {
    min-height: 800px;
  }

  .toggle-menu-collapsed a {
    position: fixed;
    bottom: 0;
    left: 0;
    font-size: 13px;
    height: 40px;
    text-align: center;
    line-height: 40px;
    transition-duration: .3s;
    outline: none;
    color: #48576a;
    background: #e4e8f1;

  }

  /*滚动条整体部分 定义滚动条高宽及背景*/
  ::-webkit-scrollbar {
    width: 6px;
    height: 8px;
    background: none;
  }

  /*!*滚动条的轨道 内阴影+圆角*!*/
  ::-webkit-scrollbar-track-piece {
    background: none;
  }

  /*!*滚动条里面的滑块 内阴影+圆角*!*/
  ::-webkit-scrollbar-thumb {
    background-color: #8492A6;
    border-radius: 1px;
  }

  .center {
    text-align: center
  }

  .topText {
    font-family: 'Microsoft YaHei';
    color: aqua
  }
</style>

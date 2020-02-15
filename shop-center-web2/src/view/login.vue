<template>
  <div>
    <el-row :span="6"  style=" padding:6em 0;"></el-row>
    <el-row :span="12">
      <el-col :span="6"  style=" padding:6em 0;"></el-col>
      <el-col :span="12" class="login-03 third-login">
        <h1>欢迎来到监控平台</h1>
        <!-- 登录表单 开始-->
        <el-form ref="form" :label-position="labelPosition" :model="form" label-width="80px" :rules="rules">
          <el-form-item label="用户名" prop="nameOrOther">
            <el-input v-model="form.nameOrOther" ></el-input>
          </el-form-item>
          <el-form-item label="用户密码" prop="password">
            <el-input v-model="form.password" type="password" ></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="login" @keyup.enter.native="login">登录</el-button>
          </el-form-item>
        </el-form>
        <!-- 登录表单 结束-->
      </el-col>
    </el-row>
  </div>
</template>

<script>
import VueCookie from 'vue-cookies'
import axiosClient from '../client/axiosClient'

export default {
  name: 'login',
  data () {
    return {
      rules: {
        nameOrOther: { required: true, message: '请输入用户名称', trigger: 'blur' },
        password: { required: true, message: '请输入用户密码', trigger: 'blur' }
      },
      labelPosition: 'left',
      form: {
        nameOrOther: '',
        password: ''
      },
      userToken: ''
    }
  },
  methods: {
    login () {
      axiosClient({
        method: 'post',
        url: 'to_login_in',
        data: this.form
      }).then(response => {
        let data = response.data
        // 成功
        if (data.success) {
          let userToken = data.data
          VueCookie.set('token', userToken, 60 * 60 * 24)
          let user = JSON.parse(userToken)
          this.getAuthorityTree(user.userId)
          return
        }
        this.$message.error('[' + data.code + ']' + data.message)
      }).catch(() => {
        this.$message.error('登录平台网络异常，请联系管理员')
      })
    },
    getAuthorityTree (userId) {
      axiosClient({
        method: 'post',
        url: 'user/get_user_authority/' + userId
      }).then(response => {
        let data = response.data
        // 成功
        if (data.success) {
          let authorityData = JSON.parse(data.data)
          if (authorityData === null || authorityData === undefined ||
            authorityData.roleVoList === null || authorityData.roleVoList === undefined) {
            this.$message.error('对不起，您暂未分配角色，请联系管理员')
            return
          }
          let roleList = authorityData.roleVoList
          let authorityMap = new Map()
          for (let role of roleList) {
            let authorityList = role.authorityVoList
            authorityList.sort((o1, o2) => {
              return o1.id - o2.id
            })
            for (let authority of authorityList) {
              debugger
              if (authority.parentId === 0) { // 为0，则父菜单
                if (authorityMap.get(authority.id)) { // 如果已经存在父菜单，则不添加,继续下一个
                  continue
                }
                authorityMap.set(authority.id, authority)
              } else { // 非0 则为子菜单
                let parent = authorityMap.get(authority.parentId) // 一定能先存放了父菜单，所以一定能parent不为空
                if (parent.children) {
                  if (parent.children.get(authority.id)) { // 如果已经存在子菜单，则不添加,继续下一个
                    continue
                  }
                  parent.children.set(authority.id, authority)
                } else { // 不存在子节点
                  parent.children = new Map()
                  parent.children.set(authority.id, authority)
                }
              }
            }
          }
          let authorityTree = this.menuMapToList(authorityMap)
          authorityTree.sort((o1, o2) => {
            return o1.id - o2.id
          })
          window.sessionStorage.setItem('authorityTree', JSON.stringify(authorityTree))
          this.$router.push('/display')
          return
        }
        this.$message.error('[' + data.code + ']' + data.message)
      }).catch((error) => {
        this.$message.error('登录平台网络异常，请联系管理员' + error)
      })
    },
    // 菜单树转换为菜单数组
    menuMapToList (source) {
      let authorityTree = []
      if (!source) {
        return authorityTree
      }
      let key, value
      for ([key, value] of source) {
        let parentNode = {
          id: value.id,
          name: value.name,
          path: value.path,
          icon: value.icon
        }
        console.log(key)
        if (value.children) {
          parentNode.children = []
          let childrenKey, childrenValue
          for ([childrenKey, childrenValue] of value.children) {
            let childrenNode = {
              id: childrenValue.id,
              name: childrenValue.name,
              path: childrenValue.path,
              icon: childrenValue.icon
            }
            console.log(childrenKey)
            parentNode.children.push(childrenNode)
          }
        }
        authorityTree.push(parentNode)
      }
      return authorityTree
    }
  },
  mounted () {
    const token = VueCookie.get('token')
    // 如果token存在，则跳转到内容页面
    if (token) {
      this.$router.push('/display')
    }
  }
}
</script>

<style scoped>
  .login-03 {
    background: url(../assets/bright.png) repeat;
    padding:6em 0;
  }
  .third-login p {
    color: #868686;
    font-size: 19px;
    padding-bottom: 15px;
  }
</style>

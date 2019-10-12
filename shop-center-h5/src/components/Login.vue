<template>
  <div>
    <br>
    <br>
    <group label-width="4.5em" label-margin-right="2em" label-align="right" :model="form">
      <x-input title="用户名" placeholder="请输入用户名" v-model="form.nameOrOther"></x-input>
      <x-input title="密码" type="password" placeholder="请输入密码" v-model="form.password"></x-input>
    </group>
    <br>
    <br>
    <br>
    <br>
    <br>
    <box gap="10px 10px">
      <x-button  plain style="border-radius:99px;" @click.native="login()">登录</x-button>
    </box>
  </div>
</template>


<script>
  import { Group, XInput, XButton, Box, AlertModule } from 'vux'

  export default {
    components: {
      Group,
      XInput,
      XButton,
      Box,
      AlertModule
    },
    data () {
      return {
        form: {
          nameOrOther: '',
          password: ''
        },
        url: process.env.BASE_URL,
        user: {}
      }
    },
    methods: {
      login () {
        this.$http.post(this.url + '/to_login_in', this.form).then(({data}) => {
          // 成功
          if (data.success) {
            let userToken = data.data
            this.user = JSON.parse(userToken)
            this.$router.push({path: '/display'})
          } else {
            AlertModule.show({
              content: data.message
            })
          }
        }).catch(() => {
          AlertModule.show({
            content: '登录平台网络异常，请联系管理员'
          })
        })
      }
    }
  }
</script>

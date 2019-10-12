<template>
  <div>
    <panel header="设备列表" :list="deviceList" type="3"></panel>
  </div>
</template>

<script>
import { Group, Cell, Panel, AlertModule } from 'vux'

export default {
  components: {
    Group,
    Cell,
    Panel,
    AlertModule
  },
  data () {
    return {
      header: '设备列表',
      url: process.env.BASE_URL,
      deviceList: []
    }
  },
  methods: {
    initDevice () {
      this.$http.get(this.url + '/device/get_all_device').then(({data}) => {
        // 成功
        if (data.success) {
          let deviceList = JSON.parse(data.data)
          for (let device of deviceList) {
            this.deviceList.push({
              title: device.deviceName,
              url: '/channel?deviceId=' + device.deviceId
            })
          }
        } else {
          let _this = this
          AlertModule.show({
            content: data.message,
            onHide () {
              _this.$router.back()
            }
          })
        }
      }).catch((e, error) => {
        // AlertModule.show({
        //   content: '登录平台网络异常，请联系管理员'
        // })
        let _this = this
        AlertModule.show({
          content: '登录平台网络异常，请联系管理员',
          onHide () {
            _this.$router.back()
          }
        })
      })
    }
  },
  mounted () {
    this.initDevice()
  }
}
</script>

<style>
.vux-demo {
  text-align: center;
}
.logo {
  width: 100px;
  height: 100px
}
</style>

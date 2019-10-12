<template>
  <div>
    <group-title>通道列表</group-title>
    <br>
    <div v-for="(p, index) in channelParentList" :key="index">
      <grid>
        <grid-item :label="o.name" v-for="(o, index) in p" :key="index" @on-item-click="startStreamPush(o)"  >
          <img slot="icon" :src="computedSrc(o)">
          <span slot="label">通道{{o.channelId}}</span>
        </grid-item>
      </grid>
      <br>
      <br>
    </div>
  </div>
</template>

<script>
import { GroupTitle, Grid, GridItem, AlertModule } from 'vux'

export default {
  components: {
    GroupTitle,
    Grid,
    GridItem,
    AlertModule
  },
  data () {
    return {
      channelList: [],
      channelId: this.$route.query.deviceId,
      url: process.env.BASE_URL,
      channelParentList: []
    }
  },
  methods: {
    renderChannel (channelList) {
      if (channelList && channelList.length > 0) {
        let size = channelList.length
        // 2 * 2
        if (size > 2 && size < 5) {
          let channelChildList = []
          for (let index = 0; index < size; index++) {
            if (index % 2 === 0) {
              channelChildList = []
            }
            channelChildList.push(channelList[index])
            if (index % 2 === 1) {
              this.channelParentList.push(channelChildList)
            }
          }
        }
        // 3 * 3
        if (size > 4 && size < 10) {
          let channelChildList = []
          for (let index = 0; index < size; index++) {
            if (index % 3 === 0) {
              channelChildList = []
            }
            channelChildList.push(channelList[index])
            if (index % 3 === 2) {
              this.channelParentList.push(channelChildList)
            }
          }
        }
        // 4 * 4
        if (size > 9) {
          let channelChildList = []
          for (let index = 0; index < size; index++) {
            if (index % 4 === 0) {
              channelChildList = []
            }
            channelChildList.push(channelList[index])
            if (index % 4 === 3) {
              this.channelParentList.push(channelChildList)
            }
          }
        }
      }
    },
    initChannel () {
      this.$http.get(this.url + '/channel/get_channel_by_device/' + this.$route.query.deviceId).then(({data}) => {
        // 成功
        if (data.success) {
          let channelData = data.data
          this.channelList = JSON.parse(channelData)
          this.renderChannel(this.channelList)
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
        let _this = this
        AlertModule.show({
          content: '登录平台网络异常，请联系管理员',
          onHide () {
            _this.$router.back()
          }
        })
      })
    },
    computedLink (channel) {
      return '/video?deviceId=' + channel.deviceId + '&channelId=' + channel.channelId
    },
    computedSrc (channel) {
      return process.env.BASE_URL + '/channel_snapshot/to_display_snapshot/' + channel.deviceId + '/' + channel.channelId
    },
    startStreamPush (channel) {
      let _this = this
      this.$http.get(process.env.BASE_URL + '/device/start_stream_push/' + channel.deviceId + '/' + channel.channelId).then(({data}) => {
        // 成功
        if (data.success) {
          _this.$router.push({path: this.computedLink(channel)})
        } else {
          AlertModule.show({
            content: '登录平台网络异常，请联系管理员',
            onHide () {
              _this.$router.back()
            }
          })
        }
      }).catch((e, error) => {
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
    this.initChannel()
  },
  computed: {

  }
}
</script>


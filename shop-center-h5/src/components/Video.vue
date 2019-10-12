<template>
  <div>
    <group-title>视频播放</group-title>
    <br>
    <video class="centeredVideo" id="videoElement" controls width="100%"  autoplay muted >
      Your browser is too old which doesn't support HTML5 video.
    </video>
  </div>
</template>

<script>
import { GroupTitle, Grid, GridItem, AlertModule } from 'vux'
import * as flvjs from 'flv.js'

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
      deviceId: this.$route.query.deviceId,
      channelId: this.$route.query.channelId,
      serverUrl: process.env.BASE_URL,
      channelParentList: [],
      rtmpUrl: ''
    }
  },
  methods: {
    playVideo () {
      this.videoPlayerDiv = document.querySelector('#videoElement')
      if (flvjs.default.isSupported()) {
        // 创建flvjs对象
        let videoUrl = this.rtmpUrl + '/' + this.deviceId + '/' + this.channelId + '.flv'
        this.flvPlayer = flvjs.default.createPlayer({
          type: 'flv', // 指定视频类型
          isLive: true, // 开启直播
          hasAudio: false, // 关闭声音
          cors: true, // 开启跨域访问
          url: videoUrl // 指定流链接
        })
        // 将flvjs对象和DOM对象绑定
        this.flvPlayer.attachMediaElement(this.videoPlayerDiv)
        // 加载视频
        this.flvPlayer.load()
        // 播放视频
        this.flvPlayer.play()
      }
    },
    getRtmpUrlConfigure () {
      this.$http.get(process.env.BASE_URL + '/configure/get_pull_rtmp_url').then(({data}) => {
        // 成功
        if (data.success) {
          let rtmpUrl = data.data
          if (rtmpUrl) {
            this.rtmpUrl = rtmpUrl
            this.playVideo()
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
        let _this = this
        AlertModule.show({
          content: '登录平台网络异常，请联系管理员',
          onHide () {
            _this.$router.back()
          }
        })
      })
    },
    stopStreamPush () {
      this.$http.get(process.env.BASE_URL + '/device/stop_stream_push/' + this.deviceId + '/' + this.channelId)
    }
  },
  mounted () {
    this.getRtmpUrlConfigure()
  },
  destroyed () {
    this.stopStreamPush()
  }
}
</script>


<template>
  <div class="gateway-wrap" v-loading="loading" style="width: 100%">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="box-card">
          <div class="text item">
            <el-table
              ref="deviceTable"
              :data="deviceList"
              height="720"
              highlight-current-row
              @row-click="handleCurrentClick">
              <el-table-column
                prop="deviceName"
                label="设备列表"
                min-width="180">
              </el-table-column>
            </el-table>
          </div>
        </el-card>
      </el-col>
      <el-col :span="16">

        <el-card class="box-card" :class="this.place()">
          <div class="nine-place" v-for="(o, index) in channelList">
            <el-card>
              <img :src="computedSrc(o)" class="image" @click="toPlay(o)"
                   :onerror="defaultImage">
              <div style="padding: 14px;">
                <div class="bottom clearfix">
                  <span><el-tag type="success">通道{{ o.channelId }}预览</el-tag></span>
                  <span>
                     <el-tag type="primary" v-if="o.status === 0">【在线】</el-tag>
                     <el-tag type="primary" v-else>【离线】</el-tag>
                  </span>
                </div>
                <el-button type="text" class="button" @click="getChannelSnapshot(o)">获取预览图</el-button>
              </div>
            </el-card>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <!--编辑的弹出框-->
    <div class="el-dialog el-dialog--small" style="top: 15%;" v-show="dialog.videoVisible">
      <div class="el-dialog__header">
        <span class="el-dialog__title">视频播放器</span>
        <button type="button" aria-label="Close" class="el-dialog__headerbtn">
          <i class="el-dialog__close el-icon el-icon-close" @click="handleVideoClose"></i>
        </button>
      </div>
      <div class="el-dialog__body">
        <video class="centeredVideo" id="videoElement" controls width="100%" height="70%" autoplay
               ref="wallVideoPlayer">
          Your browser is too old which doesn't support HTML5 video.
        </video>
      </div>
    </div>
  </div>
</template>
<script>
  import axiosClient from '../../client/axiosClient'
  import * as flvjs from 'flv.js'

  export default {
    name: 'display',
    data() {
      return {
        loading: false,
        dialog: {
          videoDisplay: true,
          videoVisible: false,
          wallFlashVisible: false
        },
        rtmpUrl: '',
        hasLogin: false,
        userId: 0,
        username: '',
        active: true,
        form: {
          nameOrOther: '',
          password: ''
        },
        defaultImage: 'this.src="./static/image_default.jpg"',
        authorityMap: new Map(),
        authorityTree: JSON.parse(window.sessionStorage.getItem('authorityTree')),
        deviceList: [],
        channelList: [],
        currentChannel: '',
        currentRow: null,
        flvPlayer: {},
        videoPlayerDiv: ''

      }
    },
    methods: {
      place() {
        if (this.channelList.length < 3) {
          return 'one-one'
        }
        if (this.channelList.length < 5) {
          return 'two-two'
        }
        if (this.channelList.length < 10) {
          return 'three-three'
        }
        if (this.channelList.length < 17) {
          return 'four-four'
        }
        return 'five-five'
      },
      handleCurrentClick(device) {
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'channel/get_channel_by_device/' + device.deviceId
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            let channelList = JSON.parse(response.data.data)
            if (channelList) {
              this.channelList = channelList
            }
            this.$refs.deviceTable.setCurrentRow(device)
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
      },
      handleFirst(device) {
        this.handleCurrentClick(device)
      },
      toPlay(channel) {
        this.startStreamPush(channel, this.doPlayVideo)
      },
      doPlayVideo(channel) {
        this.dialog.videoVisible = true
        this.videoPlayerDiv = document.querySelector('#videoElement')
        if (flvjs.default.isSupported()) {
          // 创建flvjs对象
          let url = this.rtmpUrl + '/' + channel.deviceId + '/' + channel.channelId + '.flv'
          this.flvPlayer = flvjs.default.createPlayer({
            type: 'flv', // 指定视频类型
            isLive: true, // 开启直播
            hasAudio: false, // 关闭声音
            cors: true, // 开启跨域访问
            url: url // 指定流链接
          })
          // 将flvjs对象和DOM对象绑定
          this.flvPlayer.attachMediaElement(this.videoPlayerDiv)
          // 加载视频
          this.flvPlayer.load()
          // 播放视频
          this.flvPlayer.play()
        }
      },
      initDevice() {
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'device/get_all_device'
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            let deviceList = JSON.parse(response.data.data)
            if (deviceList) {
              this.deviceList = deviceList
              this.handleFirst(this.deviceList[0])
            }
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
      },
      handleVideoClose() {
        this.dialog.videoVisible = false
        if (this.flvPlayer) {
          this.flvPlayer.pause()
          this.flvPlayer.unload()
          this.flvPlayer.detachMediaElement()
          this.flvPlayer.destroy()
          this.flvPlayer = null
        }
        this.stopStreamPush(this.currentChannel)
      },
      onPlayerPlay(player) {
      },
      onPlayerPause(player) {
      },
      startStreamPush(channel, doPlayVideo) {
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'device/start_stream_push/' + channel.deviceId + '/' + channel.channelId
        }).then(response => {
          this.loading = false
          if (response.data) {
            doPlayVideo(channel)
            this.currentChannel = channel
          }
          if (!response.data.success) {
            this.$message.info(response.data.message)
          }
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
      },
      stopStreamPush(channel) {
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'device/stop_stream_push/' + channel.deviceId + '/' + channel.channelId
        }).then(response => {
          this.loading = false
          if (!response.data.success) {
            this.$message.info(response.data.message)
          }
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
      },
      getRtmpUrlConfigure() {
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'configure/get_pull_rtmp_url'
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            let rtmpUrl = response.data.data
            if (rtmpUrl) {
              this.rtmpUrl = rtmpUrl
            }
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
      },
      getChannelSnapshot(channel) {
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'channel_snapshot/to_channel_snapshot/' + channel.deviceId + '/' + channel.channelId
        }).then(response => {
          this.loading = false
          if (!response.data.success) {
            this.$message.info(response.data.message)
          }
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
      },
      computedSrc: function(channel) {
        return process.env.BASE_URL + '/channel_snapshot/to_display_snapshot/' + channel.deviceId + '/' + channel.channelId
      }
    },
    mounted() {
      this.initDevice()
      this.getRtmpUrlConfigure()
    },
    filters: {},
    computed: {

    },
    components: {}
  }
</script>

<style>
  .el-table .info-row {
    background: #c9e5f5;
  }

  .el-table .positive-row {
    background: #e2f0e4;
  }

  .gateway-wrap .btn-add {
    text-align: right;
  }

  .wall-place {
    transform: translate(0, -50%);
  }

  .nine-place {
    width: 210px;
    border: 1px solid rgba(255, 255, 255, 0.01);
    border-radius: 3%;
    float: left;
    margin: 1%;
  }

  .one-one {
    width: 40%;
  }

  .two-two {
    width: 40%;
  }

  .three-three {
    width: 60%;
  }

  .four-four {
    width: 80%;
  }

  .five-five {
    width: 100%;
  }

  .image {
    width: 100%;
    height: 170px;
  }
</style>

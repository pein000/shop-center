<template>
  <div class="gateway-wrap" v-loading="loading" style="width: 100%">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="box-card">
          <div  class="text item">
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
      <el-col :span="16" >
        <el-card class="box-card">
          <div  class="nine-place" v-for="(o, index) in channelList" >
            <el-card>
              <img :src="o" class="image" @click="toPlay(o)"  :onerror="defaultImage">
              <div>
                <span >【{{ o.channelId }}】</span>
                <span >
                   <el-tag type="primary" v-if="o.status === 0">在线</el-tag>
                   <el-tag type="primary" v-else>离线</el-tag>
                </span>
              </div>
            </el-card>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <el-dialog title="flash设置" :visible.sync="dialog.wallFlashVisible" >
      <p id="flash_div" class="vjs-no-js" style="width:400px; height: 300px;">
        <!--当前浏览器未设置flash，-->
        <a href="http://www.adobe.com/go/getflashplayer" target="_blank"  @click="dialog.wallFlashVisible = false">
          请点击设置
        </a>
      </p>
    </el-dialog>
    <!--编辑的弹出框-->
    <el-dialog title="视频播放器" :visible.sync="dialog.videoVisible" :before-close="handleDialogClose">
      <div class="player">
        <video-player  class="video-player vjs-custom-skin"
                       ref="wallVideoPlayer"
                       :playsinline="true"
                       :options="playerOptions"
                       @play="onPlayerPlay($event)"
                       @pause="onPlayerPause($event)">
        </video-player>
      </div>
    </el-dialog>
<!--    <el-dialog title="视频播放器2" :visible.sync="dialog.videoVisible2" :before-close="handleDialogClose">-->
<!--      <video id="myVideo" class="video-js" >-->
<!--        <source-->
<!--          src="//vjs.zencdn.net/v/oceans.mp4"-->
<!--          type="video/mp4"-->
<!--        >-->
<!--      </video>-->
<!--    </el-dialog>-->
  </div>
</template>
<script>
  import axiosClient from '../../client/axiosClient'
  import 'video.js/dist/video-js.css'
  import 'vue-video-player/src/custom-theme.css'
  import { videoPlayer } from 'vue-video-player'
  import 'videojs-flash'
  import SWF_URL from 'videojs-swf/dist/video-js.swf'

  export default {
    name: 'display',
    data () {
      return {
        loading: false,
        dialog: {
          videoVisible: false,
          wallFlashVisible: false,
          videoVisible2: true
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
        playerOptions: {
          playbackRates: [0.7, 1.0, 1.5, 2.0], // 播放速度
          autoplay: false, // 如果true,浏览器准备好时开始回放。
          muted: false, // 默认情况下将会消除任何音频。
          loop: false, // 导致视频一结束就重新开始。
          preload: 'auto', // 建议浏览器在<video>加载元素后是否应该开始下载视频数据。auto浏览器选择最佳行为,立即开始加载视频（如果浏览器支持）
          language: 'zh-CN',
          aspectRatio: '16:9', // 将播放器置于流畅模式，并在计算播放器的动态大小时使用该值。值应该代表一个比例 - 用冒号分隔的两个数字（例如"16:9"或"4:3"）
          fluid: true, // 当true时，Video.js player将拥有流体大小。换句话说，它将按比例缩放以适应其容器。
          flash: {
            hls:
              {
                withCredentials: false
              },
            swf: SWF_URL
          },
          html5: {
            hls: {
              withCredentials: false
            }
          },
          techOrder: ['html5', 'flash'], // 设置顺序
          sources: [],
          // sources: [{
          //   type: 'rtmp/flv',
          //   src: 'rtmp://58.200.131.2:1935/livetv/hunantva' // 你的视频地址（必填）
          // }],
          // {
          // type: "application/x-mpegURL",
          // src: "http://21810.liveplay.myqcloud.com/live/21810_ea70a9e139.m3u8" //你的m3u8地址（必填）
          // }
          poster: 'https://file.digitaling.com/eImg/uimages/20150907/1441607120885946.gif', // 你的封面地址 poster.jpg https://file.digitaling.com/eImg/uimages/20150907/1441607120885946.gif
          width: document.documentElement.clientWidth,
          notSupportedMessage: '此视频暂无法播放，请稍后再试', // 允许覆盖Video.js无法播放媒体源时显示的默认信息。
          controlBar: {
            timeDivider: true,
            durationDisplay: true,
            remainingTimeDisplay: false,
            fullscreenToggle: true // 全屏按钮
          }
        }
      }
    },
    methods: {
      handleCurrentClick (device) {
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
      handleFirst (device) {
        this.handleCurrentClick(device)
      },
      toPlay (channel) {
        this.startStreamPush(channel, this.doPlay)
      },
      doPlay (channel) {
        debugger
        // this.playerOptions.sources = [{
        //   type: 'rtmp/flv',
        //   src: this.rtmpUrl + '/' + channel.deviceId + '/' + channel.channelId // 你的视频地址（必填）
        //   // src: this.rtmpUrl + '/' + channel.deviceId // 你的视频地址（必填）
        // }]
        this.playerOptions.sources = [{
          type: 'video/mp4',
          src: this.rtmpUrl + '/' + channel.deviceId + '/' + channel.channelId + '.flv' // 你的视频地址（必填）
          // src: this.rtmpUrl + '/' + channel.deviceId // 你的视频地址（必填）
        }]
        this.currentChannel = channel
        this.dialog.videoVisible = true
      },
      initFlash () {
        let hasFlash = false
        try {
          hasFlash = Boolean(new ActiveXObject('ShockwaveFlash.ShockwaveFlash'))
        } catch (exception) {
          hasFlash = ('undefined' !== typeof navigator.mimeTypes['application/x-shockwave-flash'])
        }
        this.dialog.wallFlashVisible = !hasFlash
      },
      initDevice () {
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
      handleDialogClose (done) {
        done()
        if (this.player) {
          // this.player.dispose()
          this.player.pause()
        }
        this.stopStreamPush(this.currentChannel)
      },
      onPlayerPlay (player) {
      },
      onPlayerPause (player) {
      },
      startStreamPush (channel, doPlay) {
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'device/start_stream_push/' + channel.deviceId + '/' + channel.channelId
        }).then(response => {
          this.loading = false
          if (response.data) {
            doPlay(channel)
          }
          if (!response.data.success) {
            this.$message.info(response.data.message)
          }
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
      },
      stopStreamPush (channel) {
        this.loading = true
        debugger
        axiosClient({
          method: 'get',
          url: 'device/stop_stream_push/' + channel.deviceId + '/' + channel.channelId
        }).then(response => {
          debugger
          this.loading = false
          if (!response.data.success) {
            this.$message.info(response.data.message)
          }
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
      },
      getRtmpUrlConfigure () {
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'configure/get_rtmp_url'
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
      }
    },
    mounted () {
      this.initDevice()
      this.initFlash()
      this.getRtmpUrlConfigure()
    },
    filters: {},
    computed: {
      player () {
        return this.$refs.wallVideoPlayer.player
      }
    },
    components: {
      videoPlayer
    }
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
    width: 20%;
    border: 1px solid rgba(255, 255, 255, 0.01);
    border-radius: 3%;
    float: left;
    margin: 1%;
  }
  .image {
    width:100%;
    height:100%;
  }
</style>

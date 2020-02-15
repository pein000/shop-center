<template>
  <div class='gateway-wrap' v-loading='loading' style='width: 100%'>
    <div id='mapContainer'></div>
<!--    <div class="amap-page-container">-->
<!--      <el-amap ref="amap" :zoom="zoom" :plugin="plugin" class="amap-demo" :center="center">-->
<!--&lt;!&ndash;        <el-amap-marker v-for="(marker, index) in markers" :key="index" :position="marker.position" :events="marker.events" :visible="marker.visible" :draggable="marker.draggable" :vid="index">&ndash;&gt;-->
<!--&lt;!&ndash;        </el-amap-marker>&ndash;&gt;-->
<!--      </el-amap>-->
<!--    </div>-->
    <el-dialog  title='摄像头展示' :visible.sync='dialog.channelVisible' >
      <el-card class="box-card" :class="this.place()">
        <div class="nine-place" v-for="(o, index) in channelList">
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
    </el-dialog>
    <!--编辑的弹出框-->
      <div class="el-dialog el-dialog--small" style="top: 15%;" v-show="dialog.videoVisible">
        <div class="el-dialog__header">
          <span class="el-dialog__title">视频播放器</span>
          <button type="button" aria-label="Close" class="el-dialog__headerbtn" >
            <i class="el-dialog__close el-icon el-icon-close" @click="handleVideoClose"></i>
          </button>
        </div>
        <div class="el-dialog__body">
          <video class="centeredVideo" id="videoElement" controls width="100%" height="70%" autoplay >
            Your browser is too old which doesn't support HTML5 video.
          </video>
        </div>
      </div>
    </div>
</template>
<script>
  import axiosClient from '../../client/axiosClient'
  import * as flvjs from 'flv.js'
  import AMap from 'AMap'

  export default {
    name: 'display',
    data () {
      return {
        loading: false,
        dialog: {
          videoDisplay: true,
          channelVisible: false,
          flashVisible: false
        },
        map: {},
        userId: 0,
        username: '',
        active: true,
        currentChannel: '',
        defaultImage: 'this.src="./static/image_default.jpg"',
        form: {
          nameOrOther: '',
          password: ''
        },
        authorityMap: new Map(),
        authorityTree: JSON.parse(window.sessionStorage.getItem('authorityTree')),
        deviceList: [],
        channelList: [],
        currentRow: null,
        flvPlayer: {},
        videoPlayerDiv: '',
        markerList: [],
        loaded: false
      }
    },
    methods: {
      place () {
        if (this.channelList.length < 3 ){
          return 'one-one'
        }
        if (this.channelList.length < 5 ){
          return 'two-two'
        }
        if (this.channelList.length < 10 ){
          return 'three-three'
        }
        if (this.channelList.length < 17 ){
          return 'four-four'
        }
        return 'five-five'
      },
      handleFirst (device) {
        this.handleCurrentClick(device)
      },
      toPlay (channel) {
        this.startStreamPush(channel, this.doPlayVideo)
      },
      doPlay (channel) {
        debugger
        this.playerOptions.sources = [{
          type: 'rtmp/flv',
          src: this.rtmpUrl + '/' + channel.deviceId + '/' + channel.channelId // 你的视频地址（必填）
        }]
        this.currentChannel = channel
        this.dialog.videoVisible = true
      },
      doPlayVideo (channel) {
        this.dialog.videoVisible = true
        this.dialog.channelVisible = false
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
      startStreamPush (channel, doPlay) {
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'device/start_stream_push/' + channel.deviceId + '/' + channel.channelId
        }).then(response => {
          this.loading = false
          if (response.data) {
            doPlay(channel)
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
      stopStreamPush (channel) {
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
      handleVideoClose () {
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
      onPlayerPlay (player) {

      },
      onPlayerPause (player) {
      },
      showChannelDialog (e) {
        let deviceInfo = e.target.getExtData().deviceInfo
        this.renderChannel(deviceInfo)
      },
      renderChannel (device) {
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
            this.dialog.channelVisible = true
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
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
              this.initMarker(deviceList)
            }
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.loading = false
          this.$message.error('请求返回异常: ' + error.message)
        })
      },
      getRtmpUrlConfigure () {
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
      initMap () {
        let map = new AMap.Map('mapContainer', {
          center: [121.59996, 31.197646],
          resizeEnable: true,
          zoom: 17,
          viewMode: '2D', // 设置地图模式
          lang: 'zh_cn' // 设置地图语言类型
        })
        AMap.plugin(['AMap.ToolBar', 'AMap.Scale'], () => {
          map.addControl(new AMap.ToolBar())
          map.addControl(new AMap.Scale())
        })
        map.on('complete', () => {
          // 地图图块加载完成后触发
          this.map = map
          this.initDevice()
        })
      },
      initMarker (deviceList) {
        if (deviceList) {
          for (let device of deviceList) {
            let iconImg
            if (device.deviceStatus === 0) { // 在线
              iconImg = 'https://webapi.amap.com/theme/v1.3/markers/n/mark_b.png'
            } else {
              iconImg = './static/map-marker.png'
            }
            let marker = new AMap.Marker({
              icon: new AMap.Icon({
                // size: new AMap.Size(40, 50),    // 图标尺寸
                image: iconImg // Icon的图像
              }),
              position: [device.gisLon, device.gisLat],
              title: device.deviceName,
              clickable: true,
              extData: {deviceInfo: device}
            })
            marker.on('click', this.showChannelDialog)
            this.markerList.push(marker)
          }
          this.map.add(this.markerList)
          this.map.setFitView()
        }
      }
    },
    mounted () {
      this.initMap()
      this.getRtmpUrlConfigure()
    },
    filters: {},
    computed: {
    },
    components: {
    }
  }
</script>

<style>
  .amap-page-container {
    position: relative;
    width: 100%;
    margin-top: 0.03rem;
    height: 500px;
    font-size: 0.12rem;
    color: #fff;
  }
  #mapContainer{
    width:100%;
    height:100%;
  }
  .nine-place {
    width: 160px;
    border: 1px solid rgba(255, 255, 255, 0.01);
    border-radius: 3%;
    float: left;
    margin: 1%;
  }
  .one-one {
    width: 40%;
  }
  .two-two {
    width: 60%;
  }
  .three-three {
    width: 80%;
  }
  .four-four {
    width: 100%;
  }
  .five-five {
    width: 100%;
  }
  .image {
    width:100%;
    height: 170px;
  }
</style>

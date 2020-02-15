import Vue from 'vue'
import Router from 'vue-router'
import VueCookie from 'vue-cookies'
import Login from '../view/login'
import Display from '../view/display'
import DeviceRegister from '../view/device/device_register'
import DeviceUnRegister from '../view/device/device_unregister'
import ChannelManage from '../view/device/channel_manage'
import Configure from '../view/manage_info/configure'
import StateDisplay from '../view/manage_info/state_display'
import MapModel from '../view/video_preview/map_model'
import WallModel from '../view/video_preview/wall_model'
import Authority from '../view/user_manage/authority'
import Role from '../view/user_manage/role'
import User from '../view/user_manage/user'

Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/',
      name: 'login',
      component: Login
    },
    {
      path: '/display',
      name: 'display',
      component: Display,
      children: [
        {
          path: '/device/channel_manage',
          name: 'channelManage',
          component: ChannelManage
        },
        {
          path: '/device/device_register',
          name: 'deviceRegister',
          component: DeviceRegister
        },
        {
          path: '/device/device_unregister',
          name: 'deviceUnRegister',
          component: DeviceUnRegister
        },
        {
          path: '/manage_info/configure',
          name: 'configure',
          component: Configure
        },
        {
          path: '/manage_info/state_display',
          name: 'stateDisplay',
          component: StateDisplay
        },
        {
          path: '/video_preview/map_model',
          name: 'mapModel',
          component: MapModel
        },
        {
          path: '/video_preview/wall_model',
          name: 'wallModel',
          component: WallModel
        },
        {
          path: '/user_manage/authority',
          name: 'authority',
          component: Authority
        },
        {
          path: '/user_manage/role',
          name: 'role',
          component: Role
        },
        {
          path: '/user_manage/user',
          name: 'user',
          component: User
        }
      ]
    }
  ]
})

router.beforeEach((to, from, next) => {
  // 如果即将进入登录路由，则直接放行
  if (to.path === '/') {
    next()
    return
  }
  // 如果存在token，则用户登录成功，直接放行
  if (VueCookie.get('token')) {
    next()
    return
  }
  // 如果不存在token，则进入登录页面
  router.push('/')
})

export default router

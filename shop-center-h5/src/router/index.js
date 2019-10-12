import Vue from 'vue'
import Router from 'vue-router'
import Channel from '@/components/Channel'
import Display from '@/components/Display'
import Login from '@/components/Login'
import Video from '@/components/Video'
import Home from '@/components/Home'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/channel',
      name: 'Channel',
      component: Channel
    },
    {
      path: '/display',
      component: Display
    },
    {
      path: '/login',
      component: Login
    },
    {
      path: '/video',
      component: Video
    },
    {
      path: '/home',
      component: Home
    }
  ]
})

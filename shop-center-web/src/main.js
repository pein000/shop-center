// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap/dist/js/bootstrap.min.js'
// adminlte
import './assets/css/skins/skin-blue.min.css'
import './assets/css/skins/_all-skins.min.css'
import './assets/css/AdminLTE.min.css'
import './assets/js/adminlte.min'

import $ from 'jquery'
window.$ = $
window.jQuery = $

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})

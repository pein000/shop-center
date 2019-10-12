'use strict'
const merge = require('webpack-merge')
const devEnv = require('./dev.env')

module.exports = merge(devEnv, {
  NODE_ENV: '"testing"',
  BASE_URL: '"http://101.231.202.132:92/deapp"',
  GOODS_URL: '"http://localhost:8020/goods-center"'
})

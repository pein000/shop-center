'use strict'
const merge = require('webpack-merge')
const prodEnv = require('./prod.env')

module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  BASE_URL: '"http://localhost:8092/deapp"',
  GOODS_URL: '"http://localhost:8020/goods-center"'

})

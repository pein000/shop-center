<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'App',
  data () {
    return {
      active: true,
      display: {
        form: true,
        container: false
      },
      form: {
        nameOrOther: '',
        password: ''
      }
    }
  },
  methods: {}
}
</script>

<style>

  #app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    min-width: 1200px;
    margin: 0 auto;
  }

  body {
    margin: 0;
  }

</style>

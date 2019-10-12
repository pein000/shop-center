<template>
  <!--分类栏目-->
  <button-tab>
    <button-tab-item @on-item-click="chooseClassify(o.classifyCode)" v-for="(o, index) in goodsClassifyList" :key="index">{{ o.classifyName }}</button-tab-item>
  </button-tab>


</template>

<script>
import { GroupTitle, Grid, GridItem, AlertModule, ButtonTab, ButtonTabItem, Divider } from 'vux'

export default {
  components: {
    GroupTitle,
    Grid,
    GridItem,
    AlertModule,
    ButtonTab,
    ButtonTabItem,
    Divider
  },
  data () {
    return {
      channelList: [],
      channelId: this.$route.query.deviceId,
      goodsUrl: process.env.GOODS_URL,
      goodsClassifyList: [],
      channelParentList: []
    }
  },
  methods: {
    initClassify () {
      this.$http.get(this.goodsUrl + '/goods/list_all_classify').then(({data}) => {
        // 成功
        if (data.success) {
          this.goodsClassifyList = JSON.parse(data.data)
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
    chooseClassify (classifyCode) {
    }
  },
  mounted () {
    this.initClassify()
  },
  computed: {

  }
}
</script>


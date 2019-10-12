<template>
  <div class="gateway-wrap" v-loading="loading">
    <el-tabs v-model="activeTab" type="card">
      <el-tab-pane label="推流设备" name="pull_tab">
        <el-row>
          <h3>推流设备</h3>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-table
              :data="rmtpPushList"
              style="width: 100%"
              height="360"
              stripe>
              <el-table-column
                prop="id"
                label="序号"
                width="240px">
              </el-table-column>
              <el-table-column
                prop="deviceId"
                label="设备编号"
                width="240px">
              </el-table-column>
              <el-table-column
                prop="channelId"
                label="通道编号"
                width="240px">
              </el-table-column>
              <el-table-column
                prop="status"
                label="状态"
                width="240px">
              </el-table-column>
              <el-table-column
                prop="speed"
                label="30秒平均速度"
                width="240px">
              </el-table-column>
            </el-table>
          </el-col>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="取流设备" name="push_tab">
        <el-row>
          <h3>取流设备</h3>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-table
              :data="rmtpPullList"
              style="width: 100%"
              height="360"
              stripe>
              <el-table-column
                prop="id"
                label="序号"
                width="240px">
              </el-table-column>
              <el-table-column
                prop="ip"
                label="ip"
                width="240px">
              </el-table-column>
              <el-table-column
                prop="url"
                label="url"
                width="240px">
              </el-table-column>
              <el-table-column
                prop="status"
                label="状态"
                width="240px">
              </el-table-column>
              <el-table-column
                prop="speed"
                label="30秒平均速度"
                width="240px">
              </el-table-column>
            </el-table>
          </el-col>
        </el-row>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>
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
</style>
<script>
  import axiosClient from '../../client/axiosClient'

  export default {
    data () {
      return {
        loading: false,
        activeTab: 'pull_tab',
        dialog: {
          configureAddVisible: false,
          configureEditVisible: false,
          configureDeleteVisible: false,
          configureImageVisible: false
        },
        configureAddForm: {},
        configureEditIndex: 0,
        configureEditForm: {
          credentialType: '',
          credentialNo: '',
          label: ''
        },
        configureDeleteIndex: 0,
        configureDeleteForm: {},
        configurePlaceholder: {
          id: '请输入配置编号',
          key: '请输入配置key',
          name: '请输入配置名称',
          value: '请输入配置value',
          remark: '请输入配置备注'
        },
        rmtpPushList: [],
        rmtpPullList: [],
        credentialTypeList: [],
        chooseCredentialType: '',
        picUrlList: [],
        formLabelWidth: '100px',
        currentDate: new Date()
      }
    },
    methods: {
      addConfigure () {
        this.configureAddForm = {}
        this.dialog.configureAddVisible = true
      },
      toAddConfigure () {
        this.loading = true
        axiosClient({
          method: 'post',
          url: 'configure/add_one_configure',
          data: this.configureAddForm
        }).then(response => {
          this.dialog.configureAddVisible = false
          this.loading = false
          if (response.data.success) {
            let configure = JSON.parse(response.data.data)
            this.configureAddForm = configure
            this.configureList.push(configure)
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.dialog.configureAddVisible = false
          this.loading = false
          this.$message.error('添加配置异常: ' + error.message)
        })
      },
      showEditDialog (index, configure) {
        this.configureEditIndex = index
        this.configureEditForm = JSON.parse(JSON.stringify(configure))
        this.dialog.configureEditVisible = true
      },
      toEditConfigure () {
        this.dialog.configureEditVisible = false
        this.loading = true
        axiosClient({
          method: 'post',
          url: 'configure/edit_configure',
          data: this.configureEditForm
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.$set(this.configureList, this.configureEditIndex, this.configureEditForm)
            this.$message.success('修改配置成功！')
            return
          }
          // 添加失败
          this.$message.error('修改配置失败!')
        }).catch(error => {
          this.loading = false
          this.$message.error('修改配置失败: ' + error.message)
        })
      },
      showDeleteDialog (index, configure) {
        this.configureDeleteIndex = index
        this.configureDeleteForm = JSON.parse(JSON.stringify(configure))
        this.dialog.configureDeleteVisible = true
      },
      toDeleteConfigure () {
        this.dialog.configureDeleteVisible = false
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'configure/to_delete_one/' + this.configureDeleteForm.id
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.configureList.splice(this.configureDeleteIndex, 1)
            this.$message.success('删除配置成功！')
            return
          }
          // 添加失败
          this.$message.error('删除配置失败!')
        }).catch(error => {
          this.loading = false
          this.$message.error('删除配置失败: ' + error.message)
        })
      }
    },
    mounted () {
      this.loading = true
      axiosClient({
        method: 'get',
        url: 'rtmp_push/get_all_rtmp_push'
      }).then(response => {
        this.loading = false
        if (response.data.success) {
          let rmtpPushList = JSON.parse(response.data.data)
          if (rmtpPushList) {
            this.rmtpPushList = rmtpPushList
          }
          return
        }
        this.$message.error('请求返回异常!')
      }).catch(error => {
        this.loading = false
        this.$message.error('请求返回异常: ' + error.message)
      })
      axiosClient({
        method: 'get',
        url: 'rtmp_pull/get_all_rtmp_pull'
      }).then(response => {
        this.loading = false
        if (response.data.success) {
          let rmtpPullList = JSON.parse(response.data.data)
          if (rmtpPullList) {
            this.rmtpPullList = rmtpPullList
          }
          return
        }
        this.$message.error('请求返回异常!')
      }).catch(error => {
        this.loading = false
        this.$message.error('请求返回异常: ' + error.message)
      })
    },
    filters: {},
    computed: {}
  }
</script>

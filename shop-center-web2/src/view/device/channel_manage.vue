<template>
  <div class="gateway-wrap" v-loading="loading">
    <el-row>
      <h3>通道管理</h3>
    </el-row>
    <el-row :span="24">
      <el-col class="btn-add">
        <el-button type="success" @click="addChannel()">添加</el-button>
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="24">
        <el-table
          :data="deviceChannelList"
          style="width: 100%" >
          <el-table-column type="expand">
            <template slot-scope="props">
              <el-form label-position="left" inline class="demo-table-expand">
                <el-form-item label="所属通道">
                  <el-table :data="props.row.channelList" style="width: 100%">
                    <el-table-column
                      prop="channelId"
                      label="通道编号"
                      width="220px">
                    </el-table-column>
                    <el-table-column
                      prop="status"
                      label="通道状态"
                      width="220px">
                    </el-table-column>
                    <el-table-column
                      prop="protocol"
                      label="通道协议"
                      width="220px">
                    </el-table-column>
                    <el-table-column
                      prop="url"
                      label="通道url"
                      width="220px">
                    </el-table-column>
                    <el-table-column
                      prop="deviceId"
                      label="设备编号"
                      width="220px">
                    </el-table-column>
                  </el-table>
                </el-form-item>
              </el-form>
            </template>
          </el-table-column>
          <el-table-column
            prop="deviceId"
            label="设备编号"
            width="140px">
          </el-table-column>
          <el-table-column
            prop="deviceName"
            label="设备名称"
            width="140px">
          </el-table-column>
          <el-table-column
            prop="deviceStatus"
            label="设备状态"
            width="140px">
            <template slot-scope="scope">
              <el-tag type="primary" v-if="scope.row.deviceStatus === 0">在线</el-tag>
              <el-tag type="info" v-else-if="scope.row.deviceStatus === 1">离线</el-tag>
              <el-tag type="primary" v-else-if="scope.row.deviceStatus === 2">注册中</el-tag>
              <el-tag type="primary" v-else-if="scope.row.deviceStatus === 3">已注册</el-tag>
              <el-tag type="info" v-else-if="scope.row.deviceStatus === 4">未注册</el-tag>
            </template>
          </el-table-column>
          <el-table-column
            prop="mqttStatus"
            label="MQ连接状态"
            width="140px">
            <template slot-scope="scope">
              <el-tag type="primary" v-if="scope.row.mqttStatus === 0">在线</el-tag>
              <el-tag type="info" v-else >离线</el-tag>
            </template>
          </el-table-column>
          <el-table-column
            prop="channelCount"
            label="通道数"
            width="140px">
          </el-table-column>
          <el-table-column
            prop="gisLon"
            label="经度"
            width="140px">
          </el-table-column>
          <el-table-column
            prop="gisLat"
            label="纬度"
            width="140px">
          </el-table-column>
          <el-table-column
            prop="gisAlt"
            label="高度"
            width="160px">
          </el-table-column>
          <el-table-column
            prop="gisType"
            label="gis类型"
            width="140px">
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
    <!--添加的弹出框-->
    <el-dialog title="添加通道" :visible.sync="dialog.channelAddVisible">
      <el-form :model="channelAddForm">
        <el-form-item label="通道编号" :label-width="formLabelWidth">
          <el-input v-model="channelAddForm.channelId" :placeholder="channelPlaceholder.channelId"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="通道状态" :label-width="formLabelWidth">
          <el-input v-model="channelAddForm.status" :placeholder="channelPlaceholder.status"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="通道协议" :label-width="formLabelWidth">
          <el-input v-model="channelAddForm.protocol" :placeholder="channelPlaceholder.protocol"
                    auto-complete="off"></el-input>
        </el-form-item>
         <el-form-item label="通道url" :label-width="formLabelWidth">
          <el-input v-model="channelAddForm.url" :placeholder="channelPlaceholder.url"
                    auto-complete="off"></el-input>
        </el-form-item>
         <el-form-item label="设备编号" :label-width="formLabelWidth">
          <el-input v-model="channelAddForm.deviceId" :placeholder="channelPlaceholder.deviceId"
                    auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.channelAddVisible = false">取 消</el-button>
        <el-button type="primary" @click="toAddChannel()">确 定</el-button>
      </div>
    </el-dialog>

    <!--编辑的弹出框-->
    <el-dialog title="编辑通道" :visible.sync="dialog.channelEditVisible">
      <el-form :model="channelEditForm">
        <el-form-item label="通道编号" :label-width="formLabelWidth">
          <el-input v-model="channelEditForm.channelId" :placeholder="channelPlaceholder.channelId"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="通道状态" :label-width="formLabelWidth">
          <el-input v-model="channelEditForm.status" :placeholder="channelPlaceholder.status"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="通道协议" :label-width="formLabelWidth">
          <el-input v-model="channelEditForm.protocol" :placeholder="channelPlaceholder.protocol"
                    auto-complete="off"></el-input>
        </el-form-item>
         <el-form-item label="通道url" :label-width="formLabelWidth">
          <el-input v-model="channelEditForm.url" :placeholder="channelPlaceholder.url"
                    auto-complete="off"></el-input>
        </el-form-item>
         <el-form-item label="设备编号" :label-width="formLabelWidth">
          <el-input v-model="channelEditForm.deviceId" :placeholder="channelPlaceholder.deviceId"
                    auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.channelEditVisible = false">取 消</el-button>
        <el-button type="primary" @click="toEditChannel()">确 定</el-button>
      </div>
    </el-dialog>

    <!--删除的弹出框-->
    <el-dialog title="删除通道" :visible.sync="dialog.channelDeleteVisible">
      确定删除通道 {{ channelDeleteForm.channelId }}？
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.channelDeleteVisible = false">取 消</el-button>
        <el-button type="primary" @click="toDeleteChannel()">确 定</el-button>
      </div>
    </el-dialog>
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
        dialog: {
          channelAddVisible: false,
          channelEditVisible: false,
          channelDeleteVisible: false,
          channelImageVisible: false
        },
        channelAddForm: {},
        channelEditIndex: 0,
        channelEditForm: {
          credentialType: '',
          credentialNo: '',
          label: ''
        },
        channelDeleteIndex: 0,
        channelDeleteForm: {},
        channelPlaceholder: {
          channelId: '请输入通道编号',
          status: '请输入通道状态',
          protocol: '请输入通道协议',
          url: '请输入通道url',
          deviceId: '请输入设备编号'
        },
        channelList: [],
        deviceChannelList: [],
        credentialTypeList: [],
        chooseCredentialType: '',
        picUrlList: [],
        formLabelWidth: '100px',
        currentDate: new Date()
      }
    },
    methods: {
      addChannel () {
        this.channelAddForm = {}
        this.dialog.channelAddVisible = true
      },
      toAddChannel () {
        this.loading = true
        axiosClient({
          method: 'post',
          url: 'channel/add_one_channel',
          data: this.channelAddForm
        }).then(response => {
          this.dialog.channelAddVisible = false
          this.loading = false
          if (response.data.success) {
            let channel = JSON.parse(response.data.data)
            this.channelAddForm = channel
            this.channelList.push(channel)
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.dialog.channelAddVisible = false
          this.loading = false
          this.$message.error('添加通道异常: ' + error.message)
        })
      },
      showEditDialog (index, channel) {
        this.channelEditIndex = index
        this.channelEditForm = JSON.parse(JSON.stringify(channel))
        this.dialog.channelEditVisible = true
      },
      toEditChannel () {
        this.dialog.channelEditVisible = false
        this.loading = true
        axiosClient({
          method: 'post',
          url: 'channel/edit_channel',
          data: this.channelEditForm
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.$set(this.channelList, this.channelEditIndex, this.channelEditForm)
            this.$message.success('修改通道成功！')
            return
          }
          // 添加失败
          this.$message.error('修改通道失败!')
        }).catch(error => {
          this.loading = false
          this.$message.error('修改通道失败: ' + error.message)
        })
      },
      showDeleteDialog (index, channel) {
        this.channelDeleteIndex = index
        this.channelDeleteForm = JSON.parse(JSON.stringify(channel))
        this.dialog.channelDeleteVisible = true
      },
      toDeleteChannel () {
        this.dialog.channelDeleteVisible = false
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'channel/to_delete_one/' + this.channelDeleteForm.id
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.channelList.splice(this.channelDeleteIndex, 1)
            this.$message.success('删除通道成功！')
            return
          }
          // 添加失败
          this.$message.error('删除通道失败!')
        }).catch(error => {
          this.loading = false
          this.$message.error('删除通道失败: ' + error.message)
        })
      }
    },
    mounted () {
      this.loading = true
      axiosClient({
        method: 'get',
        url: 'channel/get_device_channel'
      }).then(response => {
        this.loading = false
        debugger
        if (response.data.success) {
          let deviceChannelList = JSON.parse(response.data.data)
          if (deviceChannelList) {
            this.deviceChannelList = deviceChannelList
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

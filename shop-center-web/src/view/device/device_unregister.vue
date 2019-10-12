<template>
  <div class="gateway-wrap" v-loading="loading">
    <el-row>
      <h3>设备管理</h3>
    </el-row>
    <el-row :span="24">
      <el-col class="btn-add">
        <el-button type="success" @click="addDevice()">添加</el-button>
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="24">
        <el-table
          :data="deviceList"
          style="width: 100%"
          stripe>
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
           <el-table-column
             label="操作"
             min-width="200px">
            <template slot-scope="scope">
              <el-button @click="showEditDialog(scope.$index, scope.row)" type="text" size="small">编辑</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
    <!--添加的弹出框-->
    <el-dialog title="添加设备" :visible.sync="dialog.deviceAddVisible">
      <el-form :model="deviceAddForm">
        <el-form-item label="设备编号" :label-width="formLabelWidth">
          <el-input v-model="deviceAddForm.deviceId" :placeholder="devicePlaceholder.deviceId"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="设备名称" :label-width="formLabelWidth">
          <el-input v-model="deviceAddForm.deviceName" :placeholder="devicePlaceholder.deviceName"
                    auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.deviceAddVisible = false">取 消</el-button>
        <el-button type="primary" @click="toAddDevice()">确 定</el-button>
      </div>
    </el-dialog>

    <!--编辑的弹出框-->
    <el-dialog title="编辑设备" :visible.sync="dialog.deviceEditVisible">
      <el-form :model="deviceEditForm">
        <el-form-item label="设备编号" :label-width="formLabelWidth">
          <el-input v-model="deviceEditForm.deviceId" :placeholder="devicePlaceholder.deviceId"
                    auto-complete="off" disabled="disabled" ></el-input>
        </el-form-item>
        <el-form-item label="设备名称" :label-width="formLabelWidth">
          <el-input v-model="deviceEditForm.deviceName" :placeholder="devicePlaceholder.deviceName"
                    auto-complete="off"  ></el-input>
        </el-form-item>
        <el-form-item label="设备状态" :label-width="formLabelWidth">
          <el-input v-model="deviceEditForm.deviceStatus" :placeholder="devicePlaceholder.deviceStatus"
                    auto-complete="off" disabled="disabled" ></el-input>
        </el-form-item>
        <el-form-item label="MQ连接状态" :label-width="formLabelWidth">
          <el-input v-model="deviceEditForm.mqttStatus" :placeholder="devicePlaceholder.mqttStatus"
                    auto-complete="off" disabled="disabled" ></el-input>
        </el-form-item>
         <el-form-item label="通道数" :label-width="formLabelWidth">
          <el-input v-model="deviceEditForm.channelCount" :placeholder="devicePlaceholder.channelCount"
                    auto-complete="off" disabled="disabled" ></el-input>
        </el-form-item>
         <el-form-item label="经度" :label-width="formLabelWidth">
          <el-input v-model="deviceEditForm.gisLon" :placeholder="devicePlaceholder.gisLon"
                    auto-complete="off" disabled="disabled" ></el-input>
        </el-form-item>
         <el-form-item label="纬度" :label-width="formLabelWidth">
          <el-input v-model="deviceEditForm.gisLat" :placeholder="devicePlaceholder.gisLat"
                    auto-complete="off" disabled="disabled" ></el-input>
        </el-form-item>
         <el-form-item label="高度" :label-width="formLabelWidth">
          <el-input v-model="deviceEditForm.gisAlt" :placeholder="devicePlaceholder.gisAlt"
                    auto-complete="off" disabled="disabled" ></el-input>
        </el-form-item>
        <el-form-item label="gis类型" :label-width="formLabelWidth">
          <el-input v-model="deviceEditForm.gisType" :placeholder="devicePlaceholder.gisType"
                    auto-complete="off" disabled="disabled" ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.deviceEditVisible = false">取 消</el-button>
        <el-button type="primary" @click="toEditDevice()">确 定</el-button>
      </div>
    </el-dialog>

    <!--删除的弹出框-->
    <el-dialog title="删除设备" :visible.sync="dialog.deviceDeleteVisible">
      确定删除设备 {{ deviceDeleteForm.deviceId }}？
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.deviceDeleteVisible = false">取 消</el-button>
        <el-button type="primary" @click="toDeleteDevice()">确 定</el-button>
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
          deviceAddVisible: false,
          deviceEditVisible: false,
          deviceDeleteVisible: false,
          deviceImageVisible: false
        },
        deviceAddForm: {},
        deviceEditIndex: 0,
        deviceEditForm: {
          credentialType: '',
          credentialNo: '',
          label: ''
        },
        deviceDeleteIndex: 0,
        deviceDeleteForm: {},
        devicePlaceholder: {
          deviceId: '请输入设备编号',
          deviceName: '请输入设备名称',
          deviceStatus: '请输入设备状态',
          mqttStatus: '请输入MQ连接状态',
          channelCount: '请输入通道数',
          gisLon: '请输入经度',
          gisLat: '请输入纬度',
          gisAlt: '请输入高度',
          gisType: '请输入gis类型'
        },
        deviceList: [],
        credentialTypeList: [],
        chooseCredentialType: '',
        picUrlList: [],
        formLabelWidth: '100px',
        currentDate: new Date()
      }
    },
    methods: {
      addDevice () {
        this.deviceAddForm = {}
        this.dialog.deviceAddVisible = true
      },
      toAddDevice () {
        this.loading = true
        axiosClient({
          method: 'post',
          url: 'device/add_one_device',
          data: this.deviceAddForm
        }).then(response => {
          this.dialog.deviceAddVisible = false
          this.loading = false
          if (response.data.success) {
            let device = JSON.parse(response.data.data)
            this.deviceAddForm = device
            this.deviceList.push(device)
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.dialog.deviceAddVisible = false
          this.loading = false
          this.$message.error('添加设备异常: ' + error.message)
        })
      },
      showEditDialog (index, device) {
        this.deviceEditIndex = index
        this.deviceEditForm = JSON.parse(JSON.stringify(device))
        this.dialog.deviceEditVisible = true
      },
      toEditDevice () {
        this.dialog.deviceEditVisible = false
        this.loading = true
        axiosClient({
          method: 'post',
          url: 'device/edit_device',
          data: this.deviceEditForm
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.$set(this.deviceList, this.deviceEditIndex, this.deviceEditForm)
            this.$message.success('修改设备成功！')
            return
          }
          // 添加失败
          this.$message.error('修改设备失败!')
        }).catch(error => {
          this.loading = false
          this.$message.error('修改设备失败: ' + error.message)
        })
      },
      showDeleteDialog (index, device) {
        this.deviceDeleteIndex = index
        this.deviceDeleteForm = JSON.parse(JSON.stringify(device))
        this.dialog.deviceDeleteVisible = true
      },
      toDeleteDevice () {
        this.dialog.deviceDeleteVisible = false
        this.loading = true
        axiosClient({
          method: 'get',
          url: 'device/to_delete_one/' + this.deviceDeleteForm.id
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.deviceList.splice(this.deviceDeleteIndex, 1)
            this.$message.success('删除设备成功！')
            return
          }
          // 添加失败
          this.$message.error('删除设备失败!')
        }).catch(error => {
          this.loading = false
          this.$message.error('删除设备失败: ' + error.message)
        })
      }
    },
    mounted () {
      this.loading = true
      axiosClient({
        method: 'get',
        url: 'device/get_unregister_device'
      }).then(response => {
        this.loading = false
        if (response.data.success) {
          let deviceList = JSON.parse(response.data.data)
          if (deviceList) {
            this.deviceList = deviceList
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

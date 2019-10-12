<template>
  <div class="gateway-wrap" v-loading="loading">
    <el-row>
      <h3>配置管理</h3>
    </el-row>
    <el-row :span="24">
      <el-col class="btn-add">
        <el-button type="success" @click="addConfigure()">添加</el-button>
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="24">
        <el-table
          :data="configureList"
          style="width: 100%"
          stripe>
          <el-table-column
            prop="id"
            label="配置编号"
            width="100px">
          </el-table-column>
          <el-table-column
            prop="key"
            label="配置key"
            width="240px">
          </el-table-column>
          <el-table-column
            prop="name"
            label="配置名称"
            width="240px">
          </el-table-column>
          <el-table-column
            prop="value"
            label="配置value"
            width="240px">
          </el-table-column>
           <el-table-column
             prop="remark"
             label="配置备注"
             width="240px">
          </el-table-column>
           <el-table-column
             label="操作"
             min-width="200px">
            <template slot-scope="scope">
              <el-button @click="showEditDialog(scope.$index, scope.row)" type="text" size="small">编辑</el-button>
              <el-button @click="showDeleteDialog(scope.$index, scope.row)" type="text" size="small">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
    <!--添加的弹出框-->
    <el-dialog title="添加配置" :visible.sync="dialog.configureAddVisible">
      <el-form :model="configureAddForm">
        <el-form-item label="配置编号" :label-width="formLabelWidth">
          <el-input v-model="configureAddForm.id" :placeholder="configurePlaceholder.id"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="配置key" :label-width="formLabelWidth">
          <el-input v-model="configureAddForm.key" :placeholder="configurePlaceholder.key"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="配置名称" :label-width="formLabelWidth">
          <el-input v-model="configureAddForm.name" :placeholder="configurePlaceholder.name"
                    auto-complete="off"></el-input>
        </el-form-item>
         <el-form-item label="配置value" :label-width="formLabelWidth">
          <el-input v-model="configureAddForm.value" :placeholder="configurePlaceholder.value"
                    auto-complete="off"></el-input>
        </el-form-item>
         <el-form-item label="配置备注" :label-width="formLabelWidth">
          <el-input v-model="configureAddForm.remark" :placeholder="configurePlaceholder.remark"
                    auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.configureAddVisible = false">取 消</el-button>
        <el-button type="primary" @click="toAddConfigure()">确 定</el-button>
      </div>
    </el-dialog>

    <!--编辑的弹出框-->
    <el-dialog title="编辑配置" :visible.sync="dialog.configureEditVisible">
      <el-form :model="configureEditForm">
        <el-form-item label="配置编号" :label-width="formLabelWidth">
          <el-input v-model="configureEditForm.id" :placeholder="configurePlaceholder.id"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="配置key" :label-width="formLabelWidth">
          <el-input v-model="configureEditForm.key" :placeholder="configurePlaceholder.key"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="配置名称" :label-width="formLabelWidth">
          <el-input v-model="configureEditForm.name" :placeholder="configurePlaceholder.name"
                    auto-complete="off"></el-input>
        </el-form-item>
         <el-form-item label="配置value" :label-width="formLabelWidth">
          <el-input v-model="configureEditForm.value" :placeholder="configurePlaceholder.value"
                    auto-complete="off"></el-input>
        </el-form-item>
         <el-form-item label="配置备注" :label-width="formLabelWidth">
          <el-input v-model="configureEditForm.remark" :placeholder="configurePlaceholder.remark"
                    auto-complete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.configureEditVisible = false">取 消</el-button>
        <el-button type="primary" @click="toEditConfigure()">确 定</el-button>
      </div>
    </el-dialog>

    <!--删除的弹出框-->
    <el-dialog title="删除配置" :visible.sync="dialog.configureDeleteVisible">
      确定删除配置 {{ configureDeleteForm.name }}？
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.configureDeleteVisible = false">取 消</el-button>
        <el-button type="primary" @click="toDeleteConfigure()">确 定</el-button>
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
        configureList: [],
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
        url: 'configure/get_all_configure'
      }).then(response => {
        this.loading = false
        if (response.data.success) {
          let configureList = JSON.parse(response.data.data)
          if (configureList) {
            this.configureList = configureList
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

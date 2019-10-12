<template>
  <div class="gateway-wrap" v-loading="loading">
    <el-row>
      <h3>用户管理</h3>
    </el-row>
    <el-row :span="24">
      <el-col class="btn-add">
        <el-button type="info" @click="showAddDialog()">添加</el-button>
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="24">
        <el-table
          :data="userList"
          style="width: 100%"
          stripe>
          <el-table-column
            prop="id"
            label="用户编号"
            width="180">
          </el-table-column>
          <el-table-column
            prop="name"
            label="用户名称"
            width="200">
          </el-table-column>
          <el-table-column
            prop="telephone"
            label="联系方式"
            width="200">
          </el-table-column>
          <el-table-column
            prop="description"
            label="用户描述"
            width="180">
          </el-table-column>
          <el-table-column
            label="角色"
            width="200">
            <template slot-scope="scope">
              <span v-for="(item, index) in scope.row.roleVoList" :key="item.id"><el-tag type="primary">{{ item.name
                }}</el-tag></span>
            </template>
          </el-table-column>
          <el-table-column
            label="操作"
            min-width="180">
            <template slot-scope="scope">
              <el-button @click="showManageDialog(scope.$index, scope.row)" type="text" size="small">角色管理</el-button>
              <el-button @click="showDeleteDialog(scope.row)" type="text" size="small">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
    <!--角色管理的弹出框-->
    <el-dialog title="角色管理" :visible.sync="dialog.roleManageVisible">
      <el-form :model="roleManageForm">
        <el-form-item label="用户编号" :label-width="formLabelWidth">
          <el-input v-model="roleManageForm.id" auto-complete="off" disabled></el-input>
        </el-form-item>
        <el-form-item label="用户名称" :label-width="formLabelWidth">
          <el-input v-model="roleManageForm.name" auto-complete="off" disabled></el-input>
        </el-form-item>
        <el-form-item label="联系方式" :label-width="formLabelWidth">
          <el-input v-model="roleManageForm.telephone" auto-complete="off" disabled></el-input>
        </el-form-item>
        <el-form-item label="用户描述" :label-width="formLabelWidth">
          <el-input v-model="roleManageForm.description" auto-complete="off" disabled></el-input>
        </el-form-item>
        <el-form-item label="角色列表" :label-width="formLabelWidth">
          <el-checkbox-group v-model="checkList.labelList">
            <el-checkbox v-for="item in roleList" :label="item.name" :key="item.id" @change="changeCheck(item)">
              {{ item.name }}
            </el-checkbox>
          </el-checkbox-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.roleManageVisible = false">取 消</el-button>
        <el-button type="primary" @click="toManageRole()">确 定</el-button>
      </div>
    </el-dialog>

    <!--添加的弹出框-->
    <el-dialog title="添加用户" :visible.sync="dialog.userAddVisible">
      <el-form :model="userAddForm">
        <el-form-item label="用户名称" :label-width="formLabelWidth">
          <el-input v-model="userAddForm.name" :placeholder="userPlaceholder.name"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="联系方式" :label-width="formLabelWidth">
          <el-input v-model="userAddForm.telephone" :placeholder="userPlaceholder.telephone"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="用户描述" :label-width="formLabelWidth">
          <el-input v-model="userAddForm.description" auto-complete="off"
                    :placeholder="userPlaceholder.description"></el-input>
        </el-form-item>
        <el-form-item label="角色列表" :label-width="formLabelWidth">
          <el-checkbox-group v-model="checkList.labelList">
            <el-checkbox v-for="item in roleList" :label="item.name" :key="item.id" @change="changeCheck(item)">
              {{ item.name }}
            </el-checkbox>
          </el-checkbox-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.userAddVisible = false">取 消</el-button>
        <el-button type="primary" @click="toAddOneUser()">确 定</el-button>
      </div>
    </el-dialog>

    <!--删除的弹出框-->
    <el-dialog title="删除用户" :visible.sync="dialog.userDeleteVisible">
      您确定要删除？
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.userDeleteVisible = false">取 消</el-button>
        <el-button type="primary" @click="toDeleteUser()">确 定</el-button>
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
        dialog: {
          roleManageVisible: false,
          userAddVisible: false,
          userDeleteVisible: false
        },
        loading: false,
        userList: [],
        roleManageIndex: 0,
        roleManageForm: [],
        userPlaceholder: {
          name: '请输入用户名称',
          telephone: '请输入联系方式',
          description: '请输入用户描述'
        },
        userAddForm: {},
        userEditIndex: 0,
        userEditForm: {},
        userDeleteForm: {},
        checkList: {
          labelList: [],
          keyList: []
        },
        roleList: [],
        formLabelWidth: '100px'
      }
    },
    methods: {
      showManageDialog (index, user) {
        this.checkList = {
          labelList: [],
          keyList: []
        }
        this.roleManageIndex = index
        this.roleManageForm = JSON.parse(JSON.stringify(user))
        if (this.roleManageForm.roleVoList) {
          let checkLabelList = []
          let checkKeyList = []
          this.roleManageForm.roleVoList.forEach(callRole => {
            checkLabelList.push(callRole.name)
            checkKeyList.push(callRole.id)
          })
          this.checkList = {
            labelList: checkLabelList,
            keyList: checkKeyList
          }
        }
        this.dialog.roleManageVisible = true
      },
      changeCheck (role) {
        if (this.checkList.keyList.join().includes(role.id)) {
          // 删除
          let index = this.checkList.keyList.indexOf(role.id)
          if (index > -1) {
            this.checkList.keyList.splice(index, 1)
          }
        } else {
          this.checkList.keyList.push(role.id)
        }
      },
      toManageRole () {
        this.dialog.roleManageVisible = false
        this.loading = true
        let roleId = this.roleManageForm.roleId
        this.roleManageForm.roleId = this.checkList.keyList.join()
        let roleVoList = this.roleManageForm.roleVoList
        this.roleManageForm.roleVoList = []
        axiosClient({
          url: 'user/manage_role',
          method: 'post',
          data: this.roleManageForm
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.roleManageForm.roleVoList = JSON.parse(response.data.data)
            this.$set(this.userList, this.roleManageIndex, this.roleManageForm)
            this.$message.success('管理角色成功！')
            return
          }
          // 添加失败
          this.roleManageForm.roleId = roleId
          this.roleManageForm.roleVoList = roleVoList
          this.$set(this.userList, this.roleManageIndex, this.roleManageForm)
          this.$message.error('管理角色失败!')
        }).catch(error => {
          this.loading = false
          this.roleManageForm.roleId = roleId
          this.roleManageForm.roleVoList = roleVoList
          this.$set(this.userList, this.roleManageIndex, this.roleManageForm)
          this.$message.error('axiosManageRole: ' + error.message)
        })
      },
      showAddDialog () {
        this.checkList = {
          labelList: [],
          keyList: []
        }
        this.userAddForm = {}
        this.dialog.userAddVisible = true
      },
      toDeleteUser () {
        this.dialog.userDeleteVisible = false
        this.loading = true
        let userId = this.userDeleteForm.id
        axiosClient({
          url: 'user/to_delete_user/' + userId,
          method: 'post'
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.$message.success('删除用户成功！')
            this.initUserRole()
            return
          }
          this.$message.error('删除用户失败！' + response.data.message)
        }).catch(error => {
          this.$message.error('删除用户失败: ' + error.message)
        })
      },
      toAddOneUser () {
        this.loading = true
        this.userAddForm.roleId = this.checkList.keyList.join()
        axiosClient({
          url: 'user/add_one_user',
          method: 'post',
          data: this.userAddForm
        }).then(response => {
          debugger
          this.dialog.userAddVisible = false
          this.loading = false
          if (response.data.success) {
            this.initUserRole()
            return
          }
          this.$message.error('请求返回异常!' + response.data.message)
        }).catch(error => {
          this.dialog.roleAddVisible = false
          this.loading = false
          this.$message.error('axiosAddOneUser: ' + error.message)
        })
      },
      showDeleteDialog (user) {
        this.userDeleteForm = JSON.parse(JSON.stringify(user))
        this.dialog.userDeleteVisible = true
      },
      initUserRole () {
        this.loading = true
        axiosClient({
          url: 'user/get_all_user',
          method: 'post'
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.userList = JSON.parse(response.data.data)
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.loading = false
          this.$message.error('axiosGetAllUser: ' + error.message)
        })
        this.loading = true
        axiosClient({
          url: 'role/get_all_role',
          method: 'post'
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            let roleList = JSON.parse(response.data.data)
            if (roleList) {
              debugger
              this.roleList = roleList
            }
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.loading = false
          this.$message.error('axiosGetAllRole: ' + error.message)
        })
      }
    },
    mounted () {
      this.initUserRole()
    },
    filters: {}
  }
</script>

<template>
  <div class="gateway-wrap" v-loading="loading">
    <el-row>
      <h3>权限管理</h3>
    </el-row>
    <el-row :span="24">
      <el-col class="btn-add">
        <el-button type="success" @click="addAuthority()">添加</el-button>
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="24">
        <el-table
          :data="authorityList"
          style="width: 100%"
          stripe>
          <el-table-column
            prop="id"
            label="ID"
            width="180">
          </el-table-column>
          <el-table-column
            prop="name"
            label="权限名称"
            width="200">
          </el-table-column>
          <el-table-column
            prop="path"
            label="权限菜单"
            width="200">
          </el-table-column>
          <el-table-column
            prop="sortId"
            label="排序序号"
            width="200">
          </el-table-column>
          <el-table-column
            prop="parentId"
            label="父菜单ID"
            width="200">
          </el-table-column>
          <el-table-column
            prop="valid"
            label="是否可用"
            width="180">
            <template slot-scope="scope">
              <el-switch v-model="scope.row.valid" on-text="启用" off-text="禁用"
                         :on-value="1" :off-value="0" @change="changeAuthorityValid(scope.$index, scope.row)"
                         on-color="#13ce66" off-color="#ff4949">
              </el-switch>
            </template>
          </el-table-column>
          <el-table-column
            label="操作"
            min-width="100">
            <template slot-scope="scope">
              <el-button @click="showEditDialog(scope.$index, scope.row)" type="text" size="small">编辑</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>

    <!--添加的弹出框-->
    <el-dialog title="添加权限菜单" :visible.sync="dialog.authorityAddVisible">
      <el-form :model="authorityAddForm">
        <el-form-item label="权限名称" :label-width="formLabelWidth">
          <el-input v-model="authorityAddForm.name" :placeholder="authorityPlaceholder.name"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="权限菜单" :label-width="formLabelWidth">
          <el-input v-model="authorityAddForm.path" :placeholder="authorityPlaceholder.path"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="权限图标" :label-width="formLabelWidth">
          <el-input v-model="authorityAddForm.icon" :placeholder="authorityPlaceholder.icon"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="排序序号" :label-width="formLabelWidth">
          <el-input v-model="authorityAddForm.sortId" :placeholder="authorityPlaceholder.sortId"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="父菜单ID" :label-width="formLabelWidth">
          <el-input v-model="authorityAddForm.parentId" :placeholder="authorityPlaceholder.parentId"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="是否可用" :label-width="formLabelWidth">
          <el-switch v-model="authorityAddForm.valid" on-text="启用" off-text="禁用"
                     :off-value="0" :on-value="1"
                     on-color="#13ce66" off-color="#ff4949">
          </el-switch>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.authorityAddVisible = false">取 消</el-button>
        <el-button type="primary" @click="toAddAuthority()">确 定</el-button>
      </div>
    </el-dialog>

    <!--编辑的弹出框-->
    <el-dialog title="编辑权限菜单" :visible.sync="dialog.authorityEditVisible">
      <el-form :model="authorityEditForm">
        <el-form-item label="权限名称" :label-width="formLabelWidth">
          <el-input v-model="authorityEditForm.name" :placeholder="authorityPlaceholder.name"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="权限菜单" :label-width="formLabelWidth">
          <el-input v-model="authorityEditForm.path" :placeholder="authorityPlaceholder.path"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="权限图标" :label-width="formLabelWidth">
          <el-input v-model="authorityEditForm.icon" :placeholder="authorityPlaceholder.icon"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="排序序号" :label-width="formLabelWidth">
          <el-input v-model="authorityEditForm.sortId" :placeholder="authorityPlaceholder.sortId"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="父菜单ID" :label-width="formLabelWidth">
          <el-input v-model="authorityEditForm.parentId" :placeholder="authorityPlaceholder.parentId"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="是否可用" :label-width="formLabelWidth">
          <el-switch v-model="authorityEditForm.valid" on-text="启用" off-text="禁用"
                     :off-value="0" :on-value="1"
                     on-color="#13ce66" off-color="#ff4949">
          </el-switch>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.authorityEditVisible = false">取 消</el-button>
        <el-button type="primary" @click="toEditAuthority()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<style>
  .el-table .info-row {
      background: #c9e5f5;
    }
  .el-table  .positive-row {
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
          authorityAddVisible: false,
          authorityEditVisible: false
        },
        authorityAddForm: {},
        authorityEditIndex: 0,
        authorityEditForm: {},
        authorityPlaceholder: {
          name: '请输入菜单名称',
          path: '请输入菜单路径',
          icon: '请输入矢量图标',
          sortId: '请输入菜单排序，如0、1、2',
          parentId: '请输入父菜单ID。顶级菜单为0',
          valid: '1'
        },
        authorityList: [],
        formLabelWidth: '100px'
      }
    },
    methods: {
      addAuthority () {
        this.authorityAddForm = {}
        this.dialog.authorityAddVisible = true
      },
      toAddAuthority () {
        this.loading = true
        axiosClient({
          method: 'post',
          url: '/authority/add_one_authority',
          data: this.authorityAddForm
        }).then(response => {
          this.dialog.authorityAddVisible = false
          this.loading = false
          if (response.data.success) {
            let authorityId = JSON.parse(response.data.data)
            this.authorityAddForm.id = authorityId
            this.authorityList.push(this.authorityAddForm)
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.dialog.authorityAddVisible = false
          this.loading = false
          this.$message.error('axiosAddOneAuthority: ' + error.message)
        })
      },
      showEditDialog (index, authority) {
        this.authorityEditIndex = index
        this.authorityEditForm = JSON.parse(JSON.stringify(authority))
        this.dialog.authorityEditVisible = true
      },
      toEditAuthority () {
        this.dialog.authorityEditVisible = false
        this.loading = true
        axiosClient({
          method: 'post',
          url: 'authority/edit_authority',
          data: this.authorityEditForm
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.$set(this.authorityList, this.authorityEditIndex, this.authorityEditForm)
            this.$message.success('修改权限菜单成功！')
            return
          }
          // 添加失败
          this.$message.error('修改权限菜单失败!')
        }).catch(error => {
          this.loading = false
          this.$message.error('axiosEditAuthority: ' + error.message)
        })
      },
      changeAuthorityValid (index, authority) {
        this.loading = true
        let toAuthority = JSON.parse(JSON.stringify(authority))
        axiosClient({
          method: 'post',
          url: 'authority/change_authority_valid',
          data: authority
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.$set(this.authorityList, index, toAuthority)
            this.$message.success('更新状态成功')
            return
          }
          // 更新失败 状态恢复
          toAuthority.valid = toAuthority.valid === 0 ? 1 : 0
          this.$set(this.authorityList, index, toAuthority)
          this.$message.error('更新状态失败!')
        }).catch(error => {
          // 更新失败 状态恢复
          toAuthority.valid = toAuthority.valid === 0 ? 1 : 0
          this.$set(this.authorityList, index, toAuthority)
          this.dialog.authorityAddVisible = false
          this.loading = false
          this.$message.error('axiosAddOneAuthority: ' + error.message)
        })
      }
    },
    mounted () {
      this.loading = true
      axiosClient({
        method: 'post',
        url: 'authority/get_all_authority'
      }).then(response => {
        this.loading = false
        if (response.data.success) {
          let authorityList = JSON.parse(response.data.data)
          if (authorityList) {
            this.authorityList = authorityList
          }
          return
        }
        this.$message.error('请求返回异常!')
      }).catch(error => {
        this.loading = false
        this.$message.error('axiosGetAllAuthority: ' + error.message)
      })
    },
    filters: {}
  }
</script>

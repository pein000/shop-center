<template>
  <div class="gateway-wrap" v-loading="loading">
    <el-row>
      <h3>角色管理</h3>
    </el-row>
    <el-row :span="24">
      <el-col class="btn-add">
        <el-button type="success" @click="dialog.roleAddVisible = true">添加</el-button>
      </el-col>
    </el-row>
    <el-row>
      <el-col :span="24">
        <el-table
          :data="roleList"
          style="width: 100%"
          stripe>
          <el-table-column
            prop="id"
            label="ID"
            width="200">
          </el-table-column>
          <el-table-column
            prop="name"
            label="角色名称"
            width="240">
          </el-table-column>
          <el-table-column
            prop="description"
            label="角色描述"
            width="240">
          </el-table-column>
          <el-table-column
            prop="authorityVoList"
            label="角色权限"
            width="240">
            <template slot-scope="scope">
              <span v-for="(item, index) in scope.row.authorityVoList"><el-tag type="primary">{{ item.name
                }}</el-tag></span>
            </template>
          </el-table-column>
          <el-table-column
            prop="valid"
            label="是否有效"
            width="200">
            <template slot-scope="scope">
              <el-switch v-model="scope.row.valid" on-text="启用" off-text="禁用"
                         :off-value="0" :on-value="1" @change="changeRoleValid(scope.$index, scope.row)"
                         on-color="#13ce66" off-color="#ff4949">
              </el-switch>
            </template>
          </el-table-column>
          <el-table-column label="操作">
            <template slot-scope="scope">
              <el-button @click="showEditDialog(scope.$index, scope.row)" type="text" size="small">编辑</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>

    <!--添加的弹出框-->
    <el-dialog title="添加角色" :visible.sync="dialog.roleAddVisible">
      <el-form :model="roleAddForm">
        <el-form-item label="角色名称" :label-width="formLabelWidth">
          <el-input v-model="roleAddForm.name" :placeholder="rolePlaceholder.name"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="角色描述" :label-width="formLabelWidth">
          <el-input v-model="roleAddForm.description" :placeholder="rolePlaceholder.description"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="角色权限" :label-width="formLabelWidth">
          <el-tree show-checkbox highlight-current style="max-height: 300px;overflow: auto"
                   ref="authorityAddTreeRef"
                   default-expand-all
                   :data="authorityTree.allList"
                   check-strictly
                   node-key="authorityId" :props="authorityTree.props">
          </el-tree>
        </el-form-item>
        <el-form-item label="是否有效" :label-width="formLabelWidth">
          <el-switch v-model="roleAddForm.valid" on-text="启用" off-text="禁用"
                     :off-value="0" :on-value="1"
                     on-color="#13ce66" off-color="#ff4949">
          </el-switch>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.roleAddVisible = false">取 消</el-button>
        <el-button type="primary" @click="toAddRole()">确 定</el-button>
      </div>
    </el-dialog>

    <!--编辑的弹出框-->
    <el-dialog title="编辑角色" :visible.sync="dialog.roleEditVisible">
      <el-form :model="roleEditForm">
        <el-form-item label="角色名称" :label-width="formLabelWidth">
          <el-input v-model="roleEditForm.name" :placeholder="rolePlaceholder.name"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="角色描述" :label-width="formLabelWidth">
          <el-input v-model="roleEditForm.description" :placeholder="rolePlaceholder.description"
                    auto-complete="off"></el-input>
        </el-form-item>
        <el-form-item label="角色权限" :label-width="formLabelWidth">
          <el-tree show-checkbox highlight-current style="max-height: 300px;overflow: auto"
                   ref="authorityTreeRef"
                   default-expand-all
                   @check-change="handleCheckChange"
                   :data="authorityTree.allList"
                   check-strictly
                   node-key="authorityId" :props="authorityTree.props">
          </el-tree>
        </el-form-item>
        <el-form-item label="是否有效" :label-width="formLabelWidth">
          <el-switch v-model="roleEditForm.valid" on-text="启用" off-text="禁用"
                     :off-value="0" :on-value="1"
                     on-color="#13ce66" off-color="#ff4949">
          </el-switch>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialog.roleEditVisible = false">取 消</el-button>
        <el-button type="primary" @click="toEditRole()">确 定</el-button>
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
          roleAddVisible: false,
          roleEditVisible: false
        },
        roleAddForm: {},
        roleEditIndex: 0,
        roleEditForm: {},
        authorityTree: {
          allList: [],
          props: {},
          checkKeyList: []
        },
        authorityList: [],
        rolePlaceholder: {
          name: '呼叫角色',
          description: '用于呼叫电话、查询通话等',
          menuIds: '1',
          valid: '1'
        },
        roleList: [],
        formLabelWidth: '100px'
      }
    },
    methods: {
      toAddRole () {
        debugger
        this.loading = true
        let addCheckList = this.$refs.authorityAddTreeRef.getCheckedKeys()
        this.roleAddForm.menuIds = addCheckList.join()
        axiosClient({
          url: 'role/add_one_role',
          method: 'post',
          data: this.roleAddForm
        }).then(response => {
          debugger
          this.dialog.roleAddVisible = false
          this.loading = false
          if (response.data.success) {
            this.roleAddForm = JSON.parse(response.data.data)
            this.roleList.push(this.roleAddForm)
            return
          }
          this.$message.error('请求返回异常!')
        }).catch(error => {
          this.dialog.roleAddVisible = false
          this.loading = false
          this.$message.error('axiosAddOnerole: ' + error.message)
        })
      },
      renderAuthorityTree () {
        // 渲染权限树
        // 1 查询所有的权限,转换成el-tree的格式[{id:,label:,children:}]
        debugger
        let treeList = []
        this.authorityList.map(authority => {
          let oneTree = {}
          oneTree.authorityId = authority.id
          oneTree.label = authority.name
          oneTree.children = []
          // 子树，则找到treeList，添加到treeList的children中
          if (authority.parentId !== 0) {
            treeList.map(parentNode => {
              // 为其子树
              if (parentNode.authorityId === authority.parentId) {
                parentNode.children.push(oneTree)
              }
            })
            return
          }
          treeList.push(oneTree)
        })
        this.authorityTree.allList = treeList
      },
      showEditDialog (index, role) {
        this.roleEditIndex = index
        this.roleEditForm = JSON.parse(JSON.stringify(role))
        this.dialog.roleEditVisible = true

        // 2 渲染选择的树节点 将authorityId存入数组
        let checkNodeList = []
        if (role.authorityVoList) {
          checkNodeList = role.authorityVoList.map(callAuthority => {
            return callAuthority.id
          })
        }
        this.$nextTick(() => {
          this.$refs.authorityTreeRef.setCheckedKeys(checkNodeList)
        })
      },
      handleCheckChange () {
        this.authorityTree.checkKeyList = this.$refs.authorityTreeRef.getCheckedKeys()
      },
      toEditRole () {
        this.dialog.roleEditVisible = false
        this.loading = true
        this.roleEditForm.menuIds = this.authorityTree.checkKeyList.join()
        this.roleEditForm.authorityVoList = []
        axiosClient({
          url: 'role/edit_role',
          method: 'post',
          data: this.roleEditForm
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            this.roleList = JSON.parse(response.data.data)
            this.$message.success('修改角色成功！')
            return
          }
          // 添加失败
          this.$message.error('修改角色失败!')
        }).catch(error => {
          this.loading = false
          this.$message.error('axiosEditRole: ' + error.message)
        })
      },
      changeRoleValid (index, role) {
        this.loading = true
        let toRole = JSON.parse(JSON.stringify(role))
        let authorityVoList = toRole.authorityVoList
        toRole.authorityVoList = []
        axiosClient({
          url: 'role/change_authority_valid',
          method: 'post',
          data: toRole
        }).then(response => {
          this.loading = false
          if (response.data.success) {
            toRole.authorityVoList = authorityVoList
            this.$set(this.roleList, index, toRole)
            this.$message.success('更新状态成功！')
            return
          }
          // 失败，更新回之前状态
          toRole.valid = toRole.valid === 0 ? 1 : 0
          toRole.authorityVoList = authorityVoList
          this.$set(this.roleList, index, toRole)
          this.$message.error('更新状态失败!')
        }).catch(error => {
          // 失败，更新回之前状态
          toRole.valid = toRole.valid === 0 ? 1 : 0
          toRole.authorityVoList = authorityVoList
          this.$set(this.roleList, index, toRole)
          this.dialog.authorityAddVisible = false
          this.loading = false
          this.$message.error('axiosChangeRoleValid: ' + error.message)
        })
      }
    },
    mounted () {
      this.loading = true
      axiosClient({
        url: 'role/get_all_role',
        method: 'post'
      }).then(response => {
        this.loading = false
        if (response.data.success) {
          let roleList = JSON.parse(response.data.data)
          if (roleList) {
            this.roleList = roleList
          }
          return
        }
        this.$message.error('请求返回异常!')
      }).catch(error => {
        this.loading = false
        this.$message.error('axiosGetAllRole: ' + error.message)
      })

      // 查询所有的权限 为渲染权限树用
      axiosClient({
        url: 'authority/get_all_authority',
        method: 'post'
      }).then(response => {
        this.loading = false
        if (response.data.success) {
          let authorityList = JSON.parse(response.data.data)
          if (authorityList) {
            this.authorityList = authorityList
            // 1 选择权限树，所有节点,为后续权限树做数据准备
            this.renderAuthorityTree()
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

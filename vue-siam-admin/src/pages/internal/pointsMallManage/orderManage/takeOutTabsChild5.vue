// 全部订单
<template>
	<section>
		<!--工具条-->
		<el-col :span="24" class="toolbar" style="padding-bottom: 0px;">
			<el-form :inline="true" :model="searchMsg">
				<el-form-item>
					<el-input v-model="searchMsg.orderNo" placeholder="请输入订单编号搜索" clearable></el-input>
				</el-form-item>     
				<el-form-item>
					<el-input v-model="searchMsg.contactPhone" placeholder="请输入联系电话搜索" clearable></el-input>
				</el-form-item>            
				<!-- <el-form-item>
					<el-input v-model="searchMsg.contactRealname" placeholder="请输入联系人姓名搜索" clearable></el-input>
				</el-form-item>
				<el-form-item>
					<el-input v-model="searchMsg.fullReductionRuleDescription" placeholder="请输入满减规则名称搜索" clearable></el-input>
				</el-form-item>     
				<el-form-item>
					<el-input v-model="searchMsg.couponsDescription" placeholder="请输入优惠卷名称搜索" clearable></el-input>
				</el-form-item>     
				<el-form-item>
					<el-input v-model="searchMsg.contactStreet" placeholder="请输入收货地址搜索" clearable></el-input>
				</el-form-item> -->
				<el-form-item label="">
					<el-date-picker
					v-model="searchMsg.createTime"
					type="daterange"
					align="right"
					unlink-panels
					range-separator="至"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
					:picker-options="pickerOptions">
					</el-date-picker>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="getList(1)">查询</el-button>
					<el-button type="primary" @click="exportExcel">导出</el-button>
				</el-form-item>
			</el-form>
		</el-col>
		<!--列表-->
		<el-table :data="list" highlight-current-row v-loading="listLoading" style="width: 100%;" :cell-style="cellStyle" :header-cell-style="headerCellStyle" @selection-change="handleSelectionChange01">
			<!-- <el-table-column type="index" label="序号" width="50">
				<template scope="scope">
					<span>{{(searchMsg.pageNo - 1) * searchMsg.pageSize + scope.$index + 1}}</span>
				</template>		
			</el-table-column>       -->
			<el-table-column type="selection" width="55"></el-table-column>
        <el-table-column type="expand">
      <template slot-scope="props">
      	<!-- 内层为用户列表数组 -->
        <el-table :data="props.row.orderDetailList" style="width: 100%">
         <el-table-column label="商品主图" prop="mainImage">
				<template slot-scope="scope">
					<img :src="$http.publicUrl(scope.row.mainImage)" width="50" height="50">
				</template>
			</el-table-column>
      		<el-table-column prop="goodsName" label="商品名称"></el-table-column>
      		<el-table-column prop="specList" label="商品规格" :formatter="formatSpecList"></el-table-column>
			<el-table-column prop="price" label="价格" :formatter="addUnit"></el-table-column>
      		<el-table-column prop="number" label="购买数量"  :formatter="formatNumber"></el-table-column>
      		<el-table-column prop="subtotal" label="小计" :formatter="addUnit"></el-table-column>
        </el-table>
      </template>
    </el-table-column>
      <el-table-column prop="orderNo" label="订单编号"></el-table-column>
      <el-table-column prop="description" label="订单描述"></el-table-column>
      <el-table-column prop="goodsTotalPrice" label="订单总额">
				<template scope="scope">
					<span>{{scope.row.goodsTotalPrice + scope.row.deliveryFee}}元</span>
				</template>      
      </el-table-column>     
       <el-table-column prop="paymentMode" label="支付方式">
				<template scope="scope">
					<span v-if="scope.row.paymentMode == 1">微信支付</span>
                    <span v-else-if="scope.row.paymentMode == 2">平台余额</span>
                    <span v-else-if="scope.row.paymentMode == 3">平台积分</span>
               </template>						
			</el-table-column>	    
      <el-table-column prop="actualPrice" label="实付款" :formatter="addUnit"></el-table-column>
      <el-table-column prop="goodsTotalQuantity" label="商品总数量">
				<template scope="scope">
					<span>{{scope.row.goodsTotalQuantity}}件</span>
				</template>    
      </el-table-column>
      <el-table-column prop="remark" label="备注"></el-table-column>      
      <el-table-column prop="contactRealname" label="联系人姓名" width="120"></el-table-column>
			<el-table-column prop="contactPhone" label="联系电话" width="120"></el-table-column>
      <el-table-column prop="contactProvince" label="派送地址" width="190">
				<template slot-scope="scope">
					{{scope.row.contactProvince}} - {{scope.row.contactCity}} - {{scope.row.contactArea}} - {{scope.row.contactStreet}} - {{scope.row.contactHouseNumber}}
				</template>
      </el-table-column>			      
      <el-table-column prop="status" label="订单状态" width="100" :formatter="formatOrder"></el-table-column>
			<el-table-column prop="createTime" label="下单时间" :formatter="formatTime" width="190"></el-table-column>
			 <el-table-column label="操作" fixed="right">
				<template slot-scope="scope">
					<el-button size="small" @click="gotoOtherPage('view', scope.row)">查看详情</el-button>
					<el-button size="small" v-if="scope.row.status == 7 || scope.row.status == 8 || scope.row.status == 9" @click="viewReFund(scope.row)">退款信息</el-button>
					<el-button size="small" v-if="scope.row.status == 4 || scope.row.status == 5 || scope.row.status == 6" @click="handleReFund(scope.$index, scope.row)">退款</el-button>
					<!-- <el-button size="small" v-if="scope.row.status == 0" @click="handleEdit(scope.row)">发货</el-button> -->
					<!-- <el-button size="small" v-if="scope.row.status == 4" @click="openDialog(scope.row.id)">申诉处理</el-button> -->
					<!-- <el-button size="small" v-if="scope.row.status == 4" @click="openDialog(scope.row.id, 1)">退款</el-button> -->
					<!-- <el-button type="danger" size="small" @click="handleDel(scope.row.id)">删除</el-button> -->
				</template>
			</el-table-column> 
		</el-table>

		<!--工具条-->
		<el-col :span="24" class="toolbar">
			<el-pagination
				@size-change="handleSizeChange"
				@current-change="handleCurrentChange"
				:page-sizes="[10, 20, 50, 100]"
				:page-size="searchMsg.pageSize"
				layout="total, sizes, prev, pager, next, jumper"
				:total="total"
				style="float:right;">
			</el-pagination>
		</el-col>

		<!--编辑界面-->
		<el-dialog :title="dialogTitle" :visible.sync="editFormVisible" @close="editFormClose" :close-on-click-modal="false">
			<el-form size="small" :model="editForm" class="editForm" label-width="80px" style="width: 80%;">
        <el-form-item prop="dealadvise" label="处理意见">
          <el-input type="textarea"  placeholder="处理意见" v-model="editForm.dealadvise"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button @click="dealOption">保存</el-button>
        </el-form-item>
			</el-form>
			<!-- <div slot="footer" class="dialog-footer">
				<el-button @click.native="editFormVisible = false">关闭</el-button>
			</div> -->
		</el-dialog>





		<!--处理dialog-->
		<el-dialog title="退款信息" :visible.sync="viewRefundFormVisible" :close-on-click-modal="false">
			<el-table :data="viewRefundNoEdit.orderRefundGoodsList" style="width: 100%">
				<el-table-column label="商品主图" prop="mainImage">
					<template slot-scope="scope">
						<img :src="$http.publicUrl(scope.row.mainImage)" width="50" height="50">
					</template>
				</el-table-column>
				<el-table-column prop="goodsName" label="商品名称"></el-table-column>
				<el-table-column prop="specList" label="商品规格" :formatter="formatSpecList"></el-table-column>
				<el-table-column prop="price" label="价格" :formatter="addUnit"></el-table-column>
				<el-table-column prop="number" label="购买数量" :formatter="formatNumber"></el-table-column>
				<el-table-column prop="subtotal" label="小计" :formatter="addUnit"></el-table-column>
			</el-table>

			<br/>
			<el-form :model="viewRefundNoEdit" label-width="150px" ref="viewRefundNoEdit">

        <el-form-item prop="type" label="退款类型：">
          <template>
            <span v-if="viewRefundNoEdit.type == 1">未发货订单申请退款</span>
            <span v-if="viewRefundNoEdit.type == 2">已发货订单申请售后-仅退款</span>
            <span v-if="viewRefundNoEdit.type == 3">已发货订单申请售后-退货退款</span>
          </template>
        </el-form-item>	
        
        <el-form-item prop="refundWay" label="退款方式：">
          <template>
            <span v-if="viewRefundNoEdit.refundWay == 1">全额退款</span>
            <span v-if="viewRefundNoEdit.refundWay == 2">部分退款</span>
          </template>
        </el-form-item>	
        
        <el-form-item prop="refundReason" label="退款原因：">
          <template>
            <span v-if="viewRefundNoEdit.refundReason == 1">订单信息拍错（规格/尺码/颜色等）</span>
            <span v-if="viewRefundNoEdit.refundReason == 2">我不想要了</span>
            <span v-if="viewRefundNoEdit.refundReason == 3">地址/电话信息填写错误</span>
            <span v-if="viewRefundNoEdit.refundReason == 4">没用/少用优惠</span>
            <span v-if="viewRefundNoEdit.refundReason == 5">缺货</span>
            <span v-if="viewRefundNoEdit.refundReason == 31">缺货</span>
            <span v-if="viewRefundNoEdit.refundReason == 32">协商一致退款</span>
            <span v-if="viewRefundNoEdit.refundReason == 33">未按约定时间发货</span>
            <span v-if="viewRefundNoEdit.refundReason == 34">排错/多拍/不想要</span>
            <span v-if="viewRefundNoEdit.refundReason == 35">其他</span>
            <span v-if="viewRefundNoEdit.refundReason == 61">效果不好/不喜欢</span>
            <span v-if="viewRefundNoEdit.refundReason == 62">材质不符</span>
            <span v-if="viewRefundNoEdit.refundReason == 63">尺寸不符</span>
            <span v-if="viewRefundNoEdit.refundReason == 64">外观破损</span>
            <span v-if="viewRefundNoEdit.refundReason == 65">颜色/款式图案与描述不符</span>
            <span v-if="viewRefundNoEdit.refundReason == 66">物流问题</span>
            <span v-if="viewRefundNoEdit.refundReason == 67">和预期不符</span>
            <span v-if="viewRefundNoEdit.refundReason == 68">服务承诺/态度</span>
            <span v-if="viewRefundNoEdit.refundReason == 69">质量问题</span>
            <span v-if="viewRefundNoEdit.refundReason == 70">其他</span>                        
          </template>
        </el-form-item>

        <el-form-item label="退款原因详细描述：" prop="refundReasonDescription">{{viewRefundNoEdit.refundReasonDescription}}</el-form-item>

        <el-form-item label="退款金额：" prop="refundAmount">{{viewRefundNoEdit.refundAmount}}元</el-form-item>
        
        <el-form-item prop="status" label="退款状态：">
          <template>
            <span v-if="viewRefundNoEdit.status == 1">退款申请已提交</span>
            <span v-if="viewRefundNoEdit.status == 2">等待商家处理</span>
            <span v-if="viewRefundNoEdit.status == 3">商家拒绝退款</span>
            <span v-if="viewRefundNoEdit.status == 4">等待平台处理</span>
            <span v-if="viewRefundNoEdit.status == 5">平台拒绝退款，退款已关闭</span>
            <span v-if="viewRefundNoEdit.status == 6">退款已关闭</span>
            <span v-if="viewRefundNoEdit.status == 7">退款成功</span>
          </template>
        </el-form-item>

        <el-form-item label="退款账户：" prop="refundAccount">
          {{viewRefundNoEdit.refundAccount == 1 ? '微信' : 
              (viewRefundNoEdit.refundAccount == 2 ? '支付宝' : 
                (viewRefundNoEdit.refundAccount == 3 ? '平台余额' : '平台积分'))}}
        </el-form-item>

			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click.native="viewRefundFormVisible = false">关闭</el-button>
			</div>
		</el-dialog>
  
		<!--处理dialog-->
		<el-dialog title="退款" :visible.sync="refundFormVisible" :close-on-click-modal="false">

			<el-table :data="refundNoEdit.orderDetailList" style="width: 100%" @selection-change="handleSelectionChange">
				<el-table-column type="selection" width="55"></el-table-column>
				<el-table-column label="商品主图" prop="mainImage">
					<template slot-scope="scope">
						<img :src="$http.publicUrl(scope.row.mainImage)" width="50" height="50">
					</template>
				</el-table-column>
				<el-table-column prop="goodsName" label="商品名称"></el-table-column>
				<el-table-column prop="specList" label="商品规格" :formatter="formatSpecList"></el-table-column>
				<el-table-column prop="price" label="价格" :formatter="addUnit"></el-table-column>
				<el-table-column prop="number" label="购买数量" :formatter="formatNumber"></el-table-column>
				<el-table-column prop="subtotal" label="小计" :formatter="addUnit"></el-table-column>
				<el-table-column prop="refundQuantity" label="退款数量" :formatter="addUnit">
					<template slot-scope="scope">
						<el-input type="number" v-model="scope.row.refundQuantity" min="1"></el-input>
					</template>
				</el-table-column>
			</el-table>

			<br/>
			<el-form :model="refundNoEdit" label-width="150px" ref="refundNoEdit">
				<el-form-item label="是否自定义退款金额" prop="isCustomRefundAmount">
					<el-radio-group v-model="refundNoEdit.isCustomRefundAmount" size="medium">
						<el-radio-button label="1">是</el-radio-button>
						<el-radio-button label="0">否</el-radio-button>
					</el-radio-group>
				</el-form-item>

				<el-form-item label="退款金额" prop="customRefundAmount" v-if="refundNoEdit.isCustomRefundAmount == 1">
					<el-input type="number" v-model="refundNoEdit.customRefundAmount" placeholder="退款金额"></el-input>
				</el-form-item>

			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click.native="refundFormVisible = false">取消</el-button>
				<el-button type="primary" size="small" @click.native="refundNoEditSubmit">提交</el-button>
			</div>



		</el-dialog>

	</section>
</template>
<script>
	export default {
		data() {
			return {
				pickerOptions: {
					shortcuts: [{
						text: '最近一周',
							onClick(picker) {
							const end = new Date();
							let start = new Date();
							start.setTime(end.getTime() - 1000 * 60 * 60 * 24 * 7);
							picker.$emit('pick', [start, end]);
						}
					}, {
						text: '最近两周',
							onClick(picker) {
							const end = new Date();
							let start = new Date();
							start.setTime(end.getTime() - 1000 * 60 * 60 * 24 * 14);
							picker.$emit('pick', [start, end]);
						}
					}, {
						text: '最近一月',
						onClick(picker) {
							const end = new Date();
							let start = new Date();
							start.setTime(end.getTime() - 1000 * 60 * 60 * 24 * 30);
							picker.$emit('pick', [start, end]);
						}
					}, {
						text: '最近三月',
						onClick(picker) {
							const end = new Date();
							let start = new Date();
							start.setTime(end.getTime() - 1000 * 60 * 60 * 24 * 30 * 3);
							picker.$emit('pick', [start, end]);
						}
					}, {
						text: '最近半年',
						onClick(picker) {
							const end = new Date();
							let start = new Date();
							start.setTime(end.getTime() - 1000 * 60 * 60 * 24 * 180);
							picker.$emit('pick', [start, end]);
						}
					}, {
						text: '最近一年',
						onClick(picker) {
							const end = new Date();
							let start = new Date();
							start.setTime(end.getTime() - 1000 * 60 * 60 * 24 * 30 * 12);
							picker.$emit('pick', [start, end]);
						}
					}, {
						text: '最近两年',
						onClick(picker) {
							const end = new Date();
							let start = new Date();
							start.setTime(end.getTime() - 1000 * 60 * 60 * 24 * 30 * 24);
							picker.$emit('pick', [start, end]);
						}
					}, {
						text: '最近三年',
						onClick(picker) {
							const end = new Date();
							let start = new Date();
							start.setTime(end.getTime() - 1000 * 60 * 60 * 24 * 30 * 36);
							picker.$emit('pick', [start, end]);
						}
					}]
				},			
					
				viewRefundFormVisible: false,//检查处理界面是否显示
				viewRefundNoEdit: {},

				refundFormVisible: false,//检查处理界面是否显示
				refundNoEdit: {
					isCustomRefundAmount: 0
				},
				multipleSelection01: [],
				multipleSelection: [],

				searchMsg: {
					pageNo: 1,
					pageSize: 20
				},
				list: [],
				total: 0,
				listLoading: false,
				sels: [],//列表选中列
				editFormVisible: false,//编辑界面是否显示
				//编辑界面数据
				editForm: {},
				searchData:[],
				dealtype: '',
				dealId: '',
				dialogTitle: '申诉处理',
				//轮询
				timer: null
			}
		},
		methods: {
			exportExcel: function () { // 导出excel
				let vue = this
				let url = '';

				if(this.multipleSelection01.length == 0){
					vue.$message({
						showClose: true,
						message: '请选择要关联的商品',
						type: 'error'
					});
					return false							
				}
				
				// else if(this.multipleSelection.length > 6){
				// 	vue.$message({
				// 		showClose: true,
				// 		message: '最多选择6件商品',
				// 		type: 'error'
				// 	});
				// 	return false							
				// }

				//生成商品id数组
				let ids = "";
				for(let i = 0; i < this.multipleSelection01.length; i++){
					if(ids == ""){
						ids += this.multipleSelection01[i].id;
					}else{
						ids += "," + this.multipleSelection01[i].id;
					}				
				}

				console.log("ids = " + ids);

				// window.location.href = vue.$http.getUrl() + '/rest/merchant/order/export?ids='+ids+"&token="+sessionStorage.getItem("token");
				window.location.href = vue.$http.getUrl() + '/rest/admin/pointsMall/order/export?ids='+ids;

				// url = '/rest/merchant/order/export?ids='+ids;
				// vue.$http.get(vue, url, param,
				// 	(vue, data) => {
				// 		vue.$message({
				// 			showClose: true,
				// 			message: data.message,
				// 			type: 'success'
				// 		});				
				// 	}, (error, data) => {
				// 		vue.$message({
				// 			showClose: true,
				// 			message: data.message,
				// 			type: 'error'
				// 		});
				// 	}
				// )
			},		
			handleSelectionChange01(val) {
				this.multipleSelection01 = val;
				console.log(this.multipleSelection01);
			},
			handleSelectionChange(val) {
				this.multipleSelection = val;
				console.log(this.multipleSelection);
			},
			handleReFund: function (index, row) {
				this.refundFormVisible = true;
				this.refundNoEdit.id = row.id;
				// this.$refs[remarkNoEdit].resetFields();
				// this.$data = this.$options.data();
				
				this.refundNoEdit.orderDetailList = row.orderDetailList;

				//会导致输入框的输入变迟钝，只有当失焦的时候输入才会生效
				this.refundNoEdit.orderDetailList.forEach(item => {  
					if (item.refundQuantity === undefined || item.refundQuantity === null) {  
						item.refundQuantity = 1; // 设置默认值
					}
				});  

				// alert(this.refundNoEdit.isCustomRefundAmount)
			},
			refundNoEditSubmit: function () {
				this.$refs.refundNoEdit.validate((valid) => {
					if (valid) {// 编辑
						let vue = this;
						let param = Object.assign({}, this.refundNoEdit);

						if(this.multipleSelection.length == 0){
							vue.$message({
								showClose: true,
								message: '请选择要关联的商品',
								type: 'error'
							});
							return false							
						}

						//生成商品id数组
						var orderRefundGoodsList = [];
						for(let i = 0; i < this.multipleSelection.length; i++){
							var orderRefundGoods = {};
							orderRefundGoods.orderDetailId = this.multipleSelection[i].id;
							orderRefundGoods.number = this.multipleSelection[i].number;
							orderRefundGoodsList[i] = orderRefundGoods;
						}
						
						delete param.orderDetailList
						param.orderRefundGoodsList = orderRefundGoodsList;
						param.orderRefund = {};
						param.orderRefund.refundReasonDescription = "平台管理员手动退款";
						//todo - 退款金额暂时不填，由后端自己计算

						let url = '/rest/admin/pointsMall/order/applyAfterSalesDelivered/onlyRefund';
						vue.$http.post(vue, url, param,
							(vue, data) => {
								// this.editLoading = false;
								if (data.success) {
									vue.$message({
										showClose: true,
										message: data.message,
										type: 'success'
									});
									vue.getList()
									vue.refundFormVisible = false;
								}
							}, (error, data) => {
								// vue.logisticsNoFormVisible = false;
								vue.$message({
									showClose: true,
									message: data.message,
									type: 'error'
								});
							}
						)
					}
				});
			},

			viewReFund: function (row) {
				let vue = this;
						let param = {};			
						param.id = row.id;

						let url = '/rest/admin/pointsMall/order/selectRefundInfo';
						vue.$http.post(vue, url, param,
							(vue, data) => {
								// this.editLoading = false;
								if(data.success){
					this.viewRefundFormVisible = true;
					this.viewRefundNoEdit = data.data.orderRefund;
					this.viewRefundNoEdit.orderRefundGoodsList = data.data.orderRefundGoodsList;
								}
							}, (error, data) => {				
								vue.checkFormVisible = false;
								vue.$message({
									showClose: true,
									message: data.message,
									type: 'error'
								});
							}
						)
			},

			cellStyle({row, column, rowIndex, columnIndex}){
				return "text-align:center";
			},
			headerCellStyle({row, rowIndex}){
				return "text-align:center";
			},      
			gotoOtherPage(type, row) {
				if(type === 'view') {
					this.$router.push({path:'pointsMall_orderDetail', query:{id: row.id}})
				}
			},
      dealOption() {
        let vue = this
        let url = ''
        let param = {
          id: vue.dealId,
          dealadvise: vue.editForm.dealadvise
        }
        vue.dealtype ? url = '/rest/admin/pointsMall/order/updateOrderByBack' : url = '/rest/admin/pointsMall/order/updateByDealadvise'
        vue.$http.post( vue, url, param,
          (vue, data) => {
            vue.$message({
              showClose: true,
              message: data.message,
              type: 'success'
            });
            vue.editFormVisible = false
            vue.getList()
          }, (error, data) => {
            vue.$message({
              showClose: true,
              message: data.message,
              type: 'error'
            });
          }
        )
      },
      openDialog(id, type = 0) {
        this.editFormVisible = true
        this.dealId = id
        this.dealtype = type
        type ? this.dialogTitle = '退款' : '申诉处理'
      },
      editFormClose() {
        this.editForm = {}
      },
      addStand() { // 新增规格
        let vue = this
        let param = Object.assign({}, vue.editForm)
        let regEn = /^[1-9]\d*$/;
        if (!regEn.test(param.sort)) {
          vue.$message({
            showClose: true,
            message: '输入正整数序号',
            type: 'error'
          });
          return false
        }
        if (!param.stand) {
          vue.$message({
            showClose: true,
            message: '请输入规格',
            type: 'error'
          });
          return false
        }
        vue.$http.post( vue, '/rest/admin/pointsMall/stand/update', param,
          (vue, data) => {
            vue.$message({
              showClose: true,
              message: data.message,
              type: 'success'
            });
            vue.editFormVisible = false
            vue.getList()
          }, (error, data) => {
            vue.$message({
              showClose: true,
              message: data.message,
              type: 'error'
            });
          }
        )
      },
      addUnit(row, column) { // 添加单位
        return (row[column.property] || 0) + '元'
      },
      formatShoppingWay(row, column) { // 添加单位
        return row.shoppingWay == 1 ? '自取' : row.shoppingWay == 2 ? '发货' : '-';
      },           
      formatDescription(row, column) { // 添加单位
        //let replaceReg = new RegExp("&nbsp;", 'g');
        //return row.description.replace(/1/g, " ");
        if(row.description!=undefined){
          return row.description.replace(/&nbsp;/g, " ")
        }else{
          return "-";
        }
      },      
		formatTime(row, column) {
			let date = new Date(row[column.property]);
			return this.$utils.formatDate(date, 'yyyy-MM-dd hh:mm');
		},
      formatOrder (row, column) { // 0-待发货 1-待收货 2已完成 3-已取消 4-申诉中 5-已退款 6-申诉已完成
        let status = row[column.property] 
        switch (status) {
          case 1:
            return '未付款'
            break;
          case 4:
              return '待发货'
            break;
          case 5:
            return '已发货'
            break;
          case 6:
            return '已完成'
            break;
          case 7:
            return '售后处理中'
            break;
          case 8:
            return '已退款'
            break;
          case 9:
            return '售后处理完成'
            break;         
          case 10:
            return '已取消(未支付)'
            break;                              
        }
      },
		handleSizeChange(val) {
			this.searchMsg.pageSize = val;
			this.getList();
		},      
		handleCurrentChange(val) {
			this.searchMsg.pageNo = val;
			this.getList();
		},
      getList(pageNoParam) { // 获取列表
		if(pageNoParam){
		this.searchMsg.pageNo = pageNoParam;
		} // 获取订单列表
		let vue = this
		let param = Object.assign({}, vue.searchMsg)

		//处理开始日期、结束日期
		if(vue.searchMsg.createTime){
			let startDate = vue.searchMsg.createTime[0];
			let endDate = vue.searchMsg.createTime[1];
			param.startCreateTime = this.$utils.formatDate(new Date(startDate), 'yyyy/MM/dd hh:mm:ss');
			param.endCreateTime = this.$utils.formatDate(new Date(endDate), 'yyyy/MM/dd hh:mm:ss');
			delete param.createTime;
		}

        //查询所有发货订单        
        vue.listLoading = true;
				vue.$http.post(vue, '/rest/admin/pointsMall/order/listWithDetail', param,
					(vue, data) => {
						vue.list = data.data.records
						vue.total = data.data.total
						vue.listLoading = false;
					},(error, data)=> {
						vue.listLoading = false;
						vue.$message({
							showClose: true,
							message: data.message,
							type: 'error'
						});
					}
				)
			},
			handleDel (id) { // 删除
				this.$confirm('确认删除该记录吗?', '提示', {
					type: 'warning'
				}).then(() => {
					// this.listLoading = true;
				let vue = this;
				vue.$http.post(vue, '/rest/admin/pointsMall/stand/deleteById', {id},
					function(vue, data) {
            vue.$message({
              showClose: true,
              message: data.message,
              type: 'success'
            });
            vue.getList()
					}, function(error, data) {
            vue.$message({
              showClose: true,
              message: data.message,
              type: 'error'
            });
					}
				)
					// this.listLoading = false;
				}).catch(() => {});
			},
			handleEdit (row) { // 显示编辑界面
        let vue = this;
        let param = {
          orderid: row.id,
          status: 1
        }
				vue.$http.post(vue, '/rest/admin/pointsMall/order/updateOrderState', param,
					function(vue, data) {
            vue.$message({
              showClose: true,
              message: data.message,
              type: 'success'
            });
            vue.getList()
					}, function(error, data) {
            vue.$message({
              showClose: true,
              message: data.message,
              type: 'error'
            });
					}
				)
      }
		},
		mounted() {
      this.getList();
      //每隔一分钟轮询一次
      this.timer = setInterval(this.getList, 60*1000);
      //开启订单自动打印定时器
      this.$orderPrint.init();      
    },
    beforeDestroy(){
      //清除定时任务，否则切换到其他页面，这定时任务依旧会执行
      clearInterval(this.timer);
    }
	}

</script>

<style scoped>
.el-button+.el-button {
  margin-top: 5px;
  margin-left: 0;
}
.editForm .el-input {
  width: 300px;
}
</style>
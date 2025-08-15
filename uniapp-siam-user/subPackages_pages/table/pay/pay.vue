<template>
	<view class="safe-area">
		<view class="top-detail" v-if="tipReward">
			<view class="current-tips" @tap.stop.prevent="customerServiceWechat">
				{{ tipReward }}
			</view>
		</view>
		<view class="ask-for-delivery-detail">
			<view id="page-top-view" class="flex_start" style="display: flex;">
				<view :class="selectCurrent.shopManagementMode==2?'shop_info_view':'shop_info_view shop_info_view_2'"
					:data-index="selfOutActiveIndex">
					<block v-if="selfOutActiveIndex!=2&&shopInfo.shop.id">
						<view class="flex_start">
							<view class="out_of_range one_row">{{shopInfo.shop.name}}</view>
						</view>
						<view class="distance_m" v-if="shopInfo.shop.id">
							{{shopInfo.shop.area}}{{shopInfo.shop.street}}
						</view>
					</block>
					<block v-if="selfOutActiveIndex==2&&deliveryAndSelfTaking">
						<view class="flex_between">
							<view class="out_of_range one_row" v-if="deliveryAndSelfTaking.deliveryAddress">
								{{ deliveryAndSelfTaking.deliveryAddress.province }}{{ deliveryAndSelfTaking.deliveryAddress.city }}{{ deliveryAndSelfTaking.deliveryAddress.area }}{{ deliveryAndSelfTaking.deliveryAddress.street }}
							</view>
							<view v-else style="color: #8f8f8f;">请选择配送地址</view>
							<van-icon name="arrow" />
						</view>
						<view class="distance_m" v-if="deliveryAndSelfTaking.deliveryAddress">
							{{ deliveryAndSelfTaking.deliveryAddress.phone }}
							{{ deliveryAndSelfTaking.deliveryAddress.realname }}
						</view>
					</block>
				</view>
				<view class="flex_between self_out_button" @tap="openSupport"
					v-if="selfOutItems.length>0&&selectCurrent.shopManagementMode==2">
					<view class="flex_center theme-color" style="width: 100%;">
						⇋{{selfOutItems[selfOutActiveIndex].name}}
					</view>
				</view>
			</view>
		</view>
		<view class="shopping-commodity-details">
			<view v-if="shopInfo" class="display_flex_between" style="padding: 10rpx 0;">
				<view>
					{{ shopInfo.shop.name }}
				</view>
				<view id="table_name" v-if="diningTable.tableName">
					<text>🔔</text>
					<text style="margin-left: 20rpx;">{{diningTable.tableName}}</text>
				</view>
			</view>
			<view class="view-line"></view>
			<view class="commodity-name-price-detail" v-for="(item, index) in orderDetail.orderDetailList" :key="index">
				<view class="commodity-name-types">
					<view class="commodity-name">{{ item.goodsName }}</view>
					<view class="commodity-types">{{ item.restructure }}</view>
				</view>

				<view class="commodity-totalnum-price">
					<view class="commodity-totalnum">x{{ item.number }}</view>
					<view class="commodity-price">￥{{ item.totalPrice }}</view>
				</view>
			</view>
			<view class="commodity-name-price-detail">
				<view class="commodity-name-types">
					<view class="commodity-name">包装费</view>
					<view class="commodity-types commodity-delivery-tip theme-color">商品包装费</view>
				</view>
				<view class="commodity-totalnum-price">
					<view></view>
					<view class="commodity-price">￥{{ orderDetail.packingCharges }}</view>
				</view>
			</view>
			<view class="commodity-name-price-detail" v-if="deliveryAndSelfTaking&&selfOutActiveIndex == 2">
				<view class="commodity-name-types">
					<view class="commodity-name">配送费</view>
				</view>
				<view class="commodity-totalnum-price">
					<view></view>
					<view class="display_flex_between commodity-price">
						<view v-if="deliveryAndSelfTaking.isReducedDeliveryPrice" class="fullPriceReductionClass">
							￥{{ deliveryAndSelfTaking.reducedDeliveryTotalPrice }}</view>
						<view style="margin-left: 20rpx;">￥{{ deliveryAndSelfTaking.feeData }}</view>
					</view>
				</view>
			</view>
			<view class="view-line"></view>
			<view class="total-money-view">
				<text class="money-icon commodity-price">总计：</text>
				<view
					:class="orderDetail.fullPriceReductionIsHidden || orderDetail.couponsIsHidden || deliveryAndSelfTaking.isThereADiscount ? 'fullPriceReductionClass' : ''">
					<text class="commodity-price">￥{{ orderDetail.actualPrice }}</text>
				</view>
				<text class="commodity-price"
					v-if="orderDetail.fullPriceReductionIsHidden || orderDetail.couponsIsHidden || deliveryAndSelfTaking.isThereADiscount"
					:decode="true">
					&nbsp;&nbsp;&nbsp;￥{{ orderDetail.fullPriceReduction }}
				</text>
			</view>
		</view>
		<view class="pay-mode-view margin-border-radius">
			<view>支付方式</view>
			<view class="choose-pay-mode">
				<radio-group class="radio-group-address" @change="radioChangeAddress">
					<block v-for="(item, index) in paymentModes" :key="index">
						<label
							:class="'radio-label-payment flex_center ' + (item.checked ? 'payment-checked' : 'payment-not-checked')"
							v-if="item.show">
							<radio :value="index" :checked="item.checked" class="pay_radio" />
							<van-icon :name="item.icon" />
							<text :decode="true">&nbsp;{{ item.text }}</text>
							<text :decode="true" class="actionItem__desc" v-if="item.desc">&nbsp;{{ item.desc }}</text>
						</label>
					</block>

				</radio-group>
			</view>
		</view>
		<view class="ask-for-remarks-view">
			<view class="view-line" v-if="radioIndex == 0"></view>
			<view class="remarks-view">
				<view class="remarks-title-input-num">
					<view class="remarks-title">特殊备注要求</view>
					<view class="remarks-input-num">{{ inputLength }}/30</view>
				</view>
				<textarea class="textarea-remarks" @input="remarksInput" maxlength="30" placeholder="输入其他特殊备注要求（可不填）"
					placeholder-class="textarea-placeholder"></textarea>
			</view>
		</view>
		<view class="safe-area go-pay-view">
			<view class="go-pay-money">
				<view class="more-pay">
					<view>还需支付</view>
				</view>
				<view class="total-money"
					v-if="!orderDetail.fullPriceReductionIsHidden && !orderDetail.couponsIsHidden && !deliveryAndSelfTaking.isThereADiscount">
					￥{{ orderDetail.actualPrice }}
				</view>
				<view class="total-money" v-else>￥{{ orderDetail.fullPriceReduction }}</view>
			</view>
			<view class="go-pay theme-bg" hover-class="hover-class-public"
				@tap="parseEventDynamicCode($event, isForgetThePassword ? 'showPwdLayer' : 'getRequestSubscribeMessage')">
				去支付
			</view>
		</view>
		<van-dialog use-slot :show="showPayPwdInput" :showConfirmButton="false" :showCancelButton="false" z-index='1'>
			<view class="flex_between content_box">
				<view></view>
				<view>输入支付密码</view>
				<van-icon name="cross" @tap="balancePayFail" />
			</view>
			// #ifdef APP-PLUS||H5
			<!-- 密码输入框 -->
			<view class="content_box" style="padding: 0 0;">
				<view class="password_dialog_tip" style="padding: 0 16px;"><text>使用会员卡余额支付需要验证身份，验证通过后才可进行支付。</text>
				</view>
				<van-password-input :value="pwdVal" :focused="payFocus" @focus="payFocus = true" />
				<view class="theme-color password_dialog_forget_pwd" @tap.stop.prevent="forgetThePassword">忘记密码</view>
			</view>
			// #endif
			// #ifdef MP-WEIXIN||MP-ALIPAY
			<view class="content_box" style="padding: 0 16px;">
				<view class="password_dialog_tip"><text>使用会员卡余额支付需要验证身份，验证通过后才可进行支付。</text></view>
				<view class="password_dialog_row" @tap="getFocus">
					<view class="password_dialog_item_input" v-for="(item, i) in 6" :key="i">
						<text v-if="pwdVal.length > i"></text>
					</view>
				</view>
				<view class="theme-color password_dialog_forget_pwd" @tap.stop.prevent="forgetThePassword">忘记密码</view>
				<input class="password_dialog_input_control" password type="number" :focus="payFocus"
					:hold-keyboard="true" :value="pwdVal" @input="inputPwd" maxlength="6"
					:adjust-position="adjustPosition" cursor-spacing="100" :auto-focus="payFocus" inputmode="numeric" />
			</view>
			// #endif

		</van-dialog>
		<van-overlay :show="isVipDialogShow" z-index="1">
			<view class="flex_column content_box" style="margin-top: 50px;">
				<image
					:src="'https://siam-hangzhou.oss-cn-hangzhou.aliyuncs.com/data/images/business/vip_recharge_guide.png?v=' + timestamp"
					mode="widthFix" class="now-order-image" @tap="goToRecharge"></image>
				<van-icon name="clear" @tap="close" style="font-size: 40px;color: wheat;" />
			</view>
		</van-overlay>
		// #ifdef APP-PLUS||H5
		<van-number-keyboard :show="payFocus" @blur="payFocus = false" @input="inputPwd" @delete="deletePwd" />
		// #endif
		<van-action-sheet :show="showSelfOutItems" :actions="selfOutItems" @select="chooseSupport" cancel-text="取消"
			@cancel="closeDialog" @close="closeDialog" z-index="999"></van-action-sheet>
	</view>
</template>

<script>
	import https from '../../../utils/http';
	import authService from '../../../utils/auth';
	import {
		Base64
	} from 'js-base64';
	import toastService from '../../../utils/toast.service';
	import systemStatus from '../../../utils/system-status';
	import dateHelper from '../../../utils/date-helper';
	import utilHelper from '../../../utils/util';
	let app = null;
	var wxNotifyTemplates = [];
	export default {
		data() {
			return {
				time: '10:00',
				isChoose: false,
				//是否选择派送方式
				isFirstShop: false,
				//是否选择的是门店
				isFirstAddress: false,
				inputLength: 0,
				deliveryData: {},
				remarks: '',
				showSelfOutItems:false,
				selfOutItems: [],
				selfOutActiveIndex: 0,
				currentTab: 0,
				reducedDeliveryPrice: 0,
				title: '请选择支付方式',
				paymentModes: [{
						checked: false,
						value: 1,
						text: '微信支付',
						icon: 'wechat-pay',
						show: true
					},
					{
						checked: true,
						value: 2,
						text: '平台余额',
						icon: 'balance-pay',
						show: true
					}
				],
				paymentModeIndex: 1,
				showPayPwdInput: false,
				//是否展示密码输入层
				pwdVal: '',
				//输入的密码
				payFocus: false,
				//文本框焦点
				adjustPosition: false,
				holdKeyboard: true,
				isVipDialogShow: false,
				deliveryAndSelfTaking: {
					isReducedDeliveryPrice: false,
					deliveryAddress: {
						province: '',
						city: '',
						area: '',
						street: '',
						phone: '',
						realname: '',
						sex: 0
					},
					currentTab: '',
					reducedDeliveryTotalPrice: 0,
					feeData: 0,
					isThereADiscount: '',
				},
				orderDetail: {
					actualPrice: 0,
					fullPriceReduction: 0,
					couponsIsHidden: false,
					orderDetailList: [],
					packingCharges: 0,
					fullPriceReductionIsHidden: false,
					fullReductionRuleName: '',
					initShopInfo: {}
				},
				payType: '',
				initData: '',
				isJs: false,
				timestamp: '',
				userInfo: '',
				dialogShow: false,
				shopAddress: {
					shop: {
						name: '',
						province: '',
						city: '',
						area: '',
						street: ''
					}
				},
				afterDiscount: {
					couponsName: false,
					price: ''
				},
				tipReward: '',
				isPayJson: '',
				balanceId: '',
				balanceOrderNo: '',
				balanceActualPrice: '',
				balanceOpenId: '',
				phoneNumber: 0,
				radioIndex: 0,
				maskClosable: '',
				i: '',
				buttons: '',
				extClass: '',
				initShopInfo: {
					id: ''
				},
				shopInfo: {
					shop: {
						name: ''
					}
				},
				fullPriceReduction: 0,
				selectCurrent: {},
				diningTable:{}
			};
		},
		/**
		 * 生命周期函数--监听页面加载
		 */
		onLoad: function(options) {
			app = getApp();
			//this.onLoadInitLoad(options);
		},
		/**
		 * 生命周期函数--监听页面初次渲染完成
		 */
		onReady: function() {
			console.log('onReady');

		},
		/**
		 * 生命周期函数--监听页面显示
		 */
		onShow: function() {

			if (this.showPayPwdInput) {
				this.showPwdLayer();
			}
			this.getLoginMemberInfo();
			//console.log(this.orderDetail)
			if (app.globalData.loginUserInfo.isRequestWxNotify) {
				this.getWxNotifyTemplate();
			}
			this.getTimestamp();
			var _this = this;
			setTimeout(function timeout() {
				_this.onLoadOptions();
			}, 500);
		},
		/**
		 * 生命周期函数--监听页面隐藏
		 */
		onHide: function() {},
		/**
		 * 生命周期函数--监听页面卸载
		 */
		onUnload: function() {},
		/**
		 * 页面相关事件处理函数--监听用户下拉动作
		 */
		onPullDownRefresh: function() {},
		/**
		 * 页面上拉触底事件的处理函数
		 */
		onReachBottom: function() {},
		/**
		 * 用户点击右上角分享
		 */
		onShareAppMessage: function() {},
		methods: {
			onLoadInitLoad(options) {

			},
			onLoadOptions(options) {
				var _this = this;
				this.deliveryAndSelfTaking = app.globalData.deliveryAndSelfTaking;
				console.log("app.globalData.deliveryAndSelfTaking========", app.globalData.deliveryAndSelfTaking);
				let orderDetail = app.globalData.deliveryAndSelfTaking.orderDetail;
				console.log("orderDetail========", orderDetail);
				this.selfOutActiveIndex = this.selfOutActiveIndex ? this.selfOutActiveIndex : orderDetail
					.selfOutActiveIndex;
				app.globalData.deliveryAndSelfTaking.feeData = 0;
				this.orderDetail = orderDetail;
				this.payType = orderDetail.payType;
				this.selfOutActiveIndex = app.globalData.deliveryAndSelfTaking.selfOutActiveIndex;
				this.selfOutItems = orderDetail.selfOutItems;
				this.diningTable = orderDetail.diningTable;
				this.selectCurrentInfo();
				this.getShopInfo(orderDetail.shopInfo);
			},
			selectCurrentInfo(e) {
				app.globalData.selectCurrentInfo().then(result => {
					this.selectCurrent = result;
				});
			},
			confirmSelectDeliveryFee(addressid, shopId) {
				var _this = this;
				return new Promise((fulfill, reject) => {
					https.request('/rest/common/selectDeliveryFee', {
						deliveryAddressId: addressid,
						shopId: shopId
					}).then((result) => {
						console.log(result);
						if (result.success) {
							fulfill(result);
						}
					});
				});
			},
			getTimestamp() {
				var timestamp = dateHelper.getTimestamp();
				console.log(timestamp);
				this.timestamp = timestamp;
			},
			getLoginMemberInfo: function(e) {
				toastService.showLoading();
				https.request('/rest/member/getLoginMemberInfo', {}).then((result) => {
					if (result.success) {
						result.data.typeVipText = systemStatus.typeVipText(result.data.vipType);
						result.data.statusVipText = systemStatus.statusVipText(result.data.vipStatus);
						result.data.vipStartTime = dateHelper.formatDate(result.data.vipStartTime);
						result.data.vipEndTime = dateHelper.formatDate(result.data.vipEndTime);
						this.setData({
							userInfo: result.data
						});

					}
				});
			},

			closeDialog: function() {
				this.dialogShow = false;
			},

			close() {
				this.isVipDialogShow = false;
				toastService.showLoading();
				var _this = this;
				https.request('/rest/member/order/insert', _this.isPayJson).then((result) => {
					toastService.hideLoading();
					if (result.success) {
						// toastService.showLoading("正在支付...", true);
						//console.log(result.data)
						_this.toPay4Applet(result.data.id, result.data.orderNo, result.data.actualPrice);
					}
				});
			},

			btnClick(e) {
				console.log(e);
				this.closeDialog();
			},

			radioChangeAddress(e) {
				console.log(e);
				var that = this;
				var paymentModeIndex = e.detail.value;
				authService.getOpenId().then((openId) => {
					console.log(openId);
					that.closeDialog();
					let paymentModes = that.paymentModes;
					if (e.detail.value == 1) {
						console.log(that.userInfo.paymentPassword);
						if (!that.userInfo.paymentPassword) {
							uni.navigateTo({
								url: '/subPackages_pages/mine/security/index/index'
							});
							return;
						}
						if (!paymentModes[e.detail.value].isBindTap) {
							toastService.showToast(paymentModes[e.detail.value].desc);
							return;
						}
					}
					for (let key in paymentModes) {
						paymentModes[key].checked = false;
					}
					paymentModes[e.detail.value].checked = true;
					that.setData({
						paymentModes: paymentModes,
						paymentModeIndex: e.detail.value
					});
				});
			},

			choosePayModeTap() {
				let paymentModes = this.paymentModes;
				let paymentModeIndex = this.paymentModeIndex;
				let actualPrice = !this.orderDetail.fullPriceReduction ?
					this.orderDetail.actualPrice :
					this.orderDetail.fullPriceReduction;
				console.log('this.orderDetail=', this.orderDetail);
				console.log('余额=', this.userInfo.balance);
				console.log('需支付金额=', actualPrice);
				if (paymentModes[paymentModeIndex].value == 2) {
					paymentModes[paymentModeIndex].desc = '';
					paymentModes[paymentModeIndex].isBindTap = true;
					if (actualPrice > this.userInfo.balance) {
						paymentModes[paymentModeIndex].desc = '余额不足';
						paymentModes[paymentModeIndex].isBindTap = false;
					}
					if (!this.userInfo.paymentPassword) {
						paymentModes[paymentModeIndex].desc = '未设置支付密码,去设置';
						paymentModes[paymentModeIndex].isBindTap = false;
					}
				}
				toastService.hideLoading();
				this.paymentModes = paymentModes;
			},

			remarksInput(e) {
				this.setData({
					inputLength: e.detail.value.length,
					remarks: e.detail.value
				});
			},
			getShopInfo(shopId) {
				app.globalData.getShopInfo(shopId).then(result=>{
					if(result){
						this.shopInfo = result.data;
						this.reducedDeliveryPrice = result.data.shop.reducedDeliveryPrice;
					}
				});
			},

			onCoupon() {
				let afterDiscount = this.afterDiscount;
				afterDiscount.fullPriceReduction = this.orderDetail.fullPriceReduction;
				afterDiscount.actualPrice = this.orderDetail.actualPrice;
				afterDiscount.fullPriceReductionIsHidden = this.orderDetail.fullPriceReductionIsHidden;
				afterDiscount.orderDetailList = this.orderDetail.orderDetailList;
				afterDiscount.fullPriceReductionAfter = this.orderDetail.fullPriceReductionAfter;
				afterDiscount.shopId = this.orderDetail.shopId;
				afterDiscount.limitedPrice = this.orderDetail.limitedPrice;
				afterDiscount.fullReductionRuleName = this.orderDetail.fullReductionRuleName;
				afterDiscount.fullReductionRuleId = this.orderDetail.fullReductionRuleId;
				afterDiscount.packingCharges = this.orderDetail.packingCharges;
				afterDiscount.feeData = this.deliveryAndSelfTaking.feeData;
				afterDiscount.type = 1;
				//console.log(afterDiscount)
				uni.navigateTo({
					url: '/subPackages_pages/mine/coupons/coupons?prevData=' + JSON.stringify(afterDiscount)
				});
			},
			selectCommissionReward(data) {
				console.log(this);
				https.request('/rest/member/order/selectCommissionReward', {
					actualPrice: !data.fullPriceReductionIsHidden && !data.couponsIsHidden ? data
						.actualPrice : data.fullPriceReduction
				}).then((result) => {
					if (result.success) {
						this.tipReward = result.data;
					}
				});
			},
			getWxNotifyTemplate() {
				https.request('/rest/wxNotifyTemplate/orderModule/list').then((result) => {
					if (result.success) {
						console.log('订单模块的模板id===>' + result.data);
						wxNotifyTemplates = result.data;
					}
				});
			},

			updateIsRequestWxNotify() {
				https.request('/rest/member/updateIsRequestWxNotify').then((result) => {
					if (result.success) {
						console.log('修改用户的是否需要请求授权服务通知状态为否成功');
					}
				});
			},

			getRequestSubscribeMessage() {
				let self = this;
				console.log('用户的是否需要请求授权服务通知====>' + app.globalData.loginUserInfo.isRequestWxNotify);
				if (this.paymentModeIndex == 1) {
					console.log(this.userInfo.paymentPassword);
					if (!this.userInfo.paymentPassword) {
						uni.navigateTo({
							url: '/subPackages_pages/mine/security/index/index'
						});
						return;
					}
				}
				// #ifdef APP-PLUS||H5
				self.weChatPayTap();
				// #endif
				// #ifdef MP-WEIXIN||MP-ALIPAY
				if (app.globalData.loginUserInfo.isRequestWxNotify) {
					uni.requestSubscribeMessage({
						tmplIds: wxNotifyTemplates,
						success(res) {
							console.log('订单模块的模板授权成功');
							console.log(res);
							self.weChatPayTap();
							self.updateIsRequestWxNotify();
						},
						fail(error) {
							console.log('订单模块的模板授权失败');
							console.log(error);
							self.weChatPayTap();
						}
					});
					return;
				}
				self.weChatPayTap();
				// #endif
			},

			weChatPayTap() {
				authService.checkIsLogin().then((result) => {
					if (result) {
						//判断店铺是否打烊
						let startTime = this.shopInfo.shop.startTime;
						let endTime = this.shopInfo.shop.endTime;
						let isOperating = this.shopInfo.shop.isOperating;
						app.globalData.getIsBusiness(startTime, endTime, isOperating).then((result) => {
							if (!result) {
								return;
							}
							var data = {};
							if (this.selfOutActiveIndex == 1) {
								if (this.shopInfo.shop == null) {
									toastService.showToast('请选择门店地址');
									return;
								}
								data.shopId = this.shopInfo.shop.id;
							}
							if (this.selfOutActiveIndex == 1) {
								if (this.deliveryAndSelfTaking.deliveryAddress == null) {
									toastService.showToast('请选择配送地址');
									return;
								}
								data.deliveryAddressId = this.deliveryAndSelfTaking.deliveryAddress
									.id;
								data.deliveryFee = this.deliveryAndSelfTaking.feeData;
							}
							var list = this.orderDetail.orderDetailList;
							var orderDetailList = [];
							data.shoppingCartIdList = [];
							var payType = app.globalData.deliveryAndSelfTaking.payType;
							for (var key in list) {
								orderDetailList.push({
									goodsId: list[key].goodsId,
									goodsName: list[key].goodsName,
									specList: list[key].specList,
									number: list[key].number
								});
								if (payType == 'car') {
									data.shoppingCartIdList.push(list[key].id);
								}
							}
							//console.log(this.orderDetail)
							data.orderDetailListStr = JSON.stringify(orderDetailList);
							data.actualPrice =
								this.orderDetail.fullPriceReductionIsHidden || this.orderDetail
								.couponsIsHidden || this
								.deliveryAndSelfTaking.isThereADiscount ?
								this.orderDetail.fullPriceReduction :
								this.orderDetail.actualPrice;
							//data.actualPrice = data.actualPrice + this.orderDetail.feeData;
							data.remark = this.remarks;
							data.shoppingWay = this.selfOutActiveIndex == 0 ? 1 : 2;
							data.shopId = this.shopInfo.shop.shopId;
							//console.log(data)
							if (this.orderDetail.couponsIsHidden) {
								data.couponsId = this.afterDiscount.couponsId;
								data.couponsMemberRelationId = this.afterDiscount.id;
								data.couponsDescription = this.afterDiscount.couponsName;
							}
							//console.log(this.orderDetail)
							if (this.orderDetail.fullReductionRuleId) {
								data.fullReductionRuleId = this.orderDetail.fullReductionRuleId;
								data.fullReductionRuleDescription = this.orderDetail
									.fullReductionRuleName;
							}
							var _this = this;
							//获取订单的配送方式
							let orderMode = this.selfOutItems[this.selfOutActiveIndex].name;
							if (this.userInfo.type == 1) {
								this.isVipDialogShow = true;
								this.isPayJson = data;
							} else {
								toastService.showLoading();
								https.request('/rest/member/order/insert', data).then((result) => {
									toastService.hideLoading();
									if (result.success) {
										_this.toPay4Applet(result.data.id, result.data.orderNo,
											result.data.actualPrice);
									}
								});
							}
						});
						return;
					}
					app.globalData.checkIsAuth('scope.userInfo');
				});
			},

			toPay4Applet(id, orderNo, actualPrice) {
				toastService.showLoading('正在加载...', true);
				var _this = this;
				authService.getOpenId().then((openId) => {
					if (this.paymentModes[this.paymentModeIndex].value == 1) {
						this.weChatPay(id, orderNo, actualPrice, openId);
					}
					if (this.paymentModes[this.paymentModeIndex].value == 2) {
						toastService.hideLoading();
						_this.$nextTick(() => {
							_this.showPayPwdInput = true;
							_this.getFocus();
						});
						this.balanceId = id;
						this.balanceOrderNo = orderNo;
						this.balanceActualPrice = actualPrice;
						this.balanceOpenId = openId;
					}
				});
			},

			weChatPay(id, orderNo, actualPrice, openId) {
				https.request('/rest/member/wxPay/toPay4Applet', {
					openid: openId,
					type: 1,
					paymentMode: 1,
					out_trade_no: orderNo,
					total_fee: this.orderDetail.fullPriceReductionIsHidden ? this.orderDetail
						.fullPriceReduction : actualPrice
				}).then((result) => {
					toastService.hideLoading();
					if (result.success) {
						//console.log(result)
						uni.requestPayment({
							appId: result.data.appid,
							timeStamp: result.data.timeStamp,
							nonceStr: result.data.nonceStr,
							package: result.data.package,
							signType: 'MD5',
							paySign: result.data.paySign,
							success(res) {
								toastService.showSuccess('支付成功', true);
								let timeout = setTimeout(() => {
									uni.redirectTo({
										url: '/subPackages_pages/order/detail/detail?id=' + id
									});
									clearTimeout(timeout);
								}, 1000);
							},
							fail(res) {
								toastService.showError('支付失败', true);
								let timeout = setTimeout(() => {
									uni.redirectTo({
										url: '/subPackages_pages/order/detail/detail?id=' + id
									});
									clearTimeout(timeout);
								}, 1000);
							}
						});
					}
				});
			},
			deletePwd(e) {
				if (this.pwdVal.length === 0) {
					return;
				}
				const lastIndex = this.pwdVal.length - 1;
				this.pwdVal = this.pwdVal.substring(0, lastIndex) + "";
			},
			inputPwd: function(e) {
				// #ifdef APP-PLUS||H5
				this.pwdVal = this.pwdVal + e;
				// #endif
				// #ifdef MP-WEIXIN||MP-ALIPAY
				this.pwdVal = e.detail.value;
				// #endif
				if (this.pwdVal.length >= 6) {
					toastService.showLoading('正在加载...');
					this.balancePay();
				}
			},

			/**
			 * 获取焦点
			 */
			getFocus: function() {
				var _this = this;
				this.payFocus = false;
				//this.showPayPwdInput = true;
				this.$nextTick(() => {
					console.log("点击获取焦点");
					// #ifdef APP-PLUS||H5
					_this.payFocus = true;
					// #endif
					// #ifdef MP-WEIXIN||MP-ALIPAY
					setTimeout(() => {
						_this.payFocus = true;
					}, 100);
					// #endif
				})
			},

			balancePay() {
				var password = Base64.encode(this.pwdVal);
				this.pwdVal = '';
				this.payFocus = true;
				https.request('/rest/member/platformPay/byBalance', {
					openid: this.balanceOpenId,
					type: 1,
					paymentMode: 2,
					paymentPassword: password,
					out_trade_no: this.balanceOrderNo,
					total_fee: this.orderDetail.fullPriceReductionIsHidden ? this.orderDetail
						.fullPriceReduction : this
						.balanceActualPrice
				}).then((result) => {
					toastService.hideLoading();
					if (result.success) {
						toastService.showSuccess('支付成功', true);
						this.hidePwdLayer();
						let timeout = setTimeout(() => {
							uni.redirectTo({
								url: '../../order/detail/detail?id=' + this.balanceId
							});
							clearTimeout(timeout);
						}, 1000);
					}
				});
			},

			bindtouchend(e) {
				console.log('触摸结束');
				this.showPwdLayer();
			},

			balancePayFail() {
				this.hidePwdLayer();
				toastService.showError('支付失败', true);
				let timeout = setTimeout(() => {
					uni.redirectTo({
						url: '../../order/detail/detail?id=' + this.balanceId
					});
					clearTimeout(timeout);
				}, 1000);
			},

			hidePwdLayer() {
				this.showPayPwdInput = false;
				this.payFocus = false;
				this.pwdVal = '';

			},

			showPwdLayer() {
				this.showPayPwdInput = true;
				this.payFocus = true;
				this.pwdVal = '';


				// this.setData({
				// 	showPayPwdInput: true,
				// 	payFocus: true,
				// 	pwdVal: ''
				// });
			},

			/**
			 * 隐藏支付密码输入层
			 */
			forgetThePassword: function() {
				uni.navigateTo({
					url: '../../mine/security/index/index'
				});
			},
			//获取满减规则
			getFullReductionRule(orderDetail) {
				var _this = this;
				toastService.showLoading();
				https.request('/rest/fullReductionRule/list', {
					pageNo: -1,
					pageSize: 1,
					shopId: orderDetail.shopId
				}).then((result) => {
					toastService.hideLoading();
					if (result.success) {
						console.log('getFullReductionRule', app.globalData.deliveryAndSelfTaking.orderDetail);
						var orderDetailList = orderDetail.orderDetailList;
						var fullPriceReduction = orderDetail.fullPriceReduction;
						//获取配送费，配送费不作为满减条件
						// var packingCharges = 0;
						// var totalNum = 0;
						// var totalPrice = 0;
						// orderDetailList.forEach((result, index) => {
						// 	totalNum = totalNum + result.number;
						// 	result.goodsPrices = utilHelper.toFixed(Number(result.goodsPrice) * result
						// 		.number, 2);
						// 	totalPrice = totalPrice + (result.price * result.number); //初始化被选中的商品的总金额
						// 	result.disable = result.goodsStatus == 1 || result.goodsStatus == 3 || result
						// 		.goodsStatus == 4 ? true : false;
						// 	packingCharges =
						// 		result.goodsStatus == 1 || result.goodsStatus == 3 || result.goodsStatus ==
						// 		4 ?
						// 		packingCharges :
						// 		packingCharges + result.packingCharges * result.number;
						// });
						// totalPrice = utilHelper.toFixed(totalPrice + packingCharges, 2);
						var fullReductionRulePrice = 0;
						for (let i = 0; i < result.data.records.length; i++) {
							//总价格减去配送费大于满减金额则进行满减操作
							if (fullPriceReduction >= result.data.records[i].limitedPrice) {
								orderDetail.fullPriceReduction = utilHelper.toFixed(fullPriceReduction - result
									.data.records[i]
									.reducedPrice, 2);
								orderDetail.fullReductionRuleName = result.data.records[i].name;
								orderDetail.fullReductionRuleId = result.data.records[i].id;
								orderDetail.fullPriceReductionIsHidden = true;
								orderDetail.reducedPrice = result.data.records[i].reducedPrice;
							}
						}
						//console.log('计算满减金额', totalPrice);
						this.$nextTick(() => {
							_this.getPsf(orderDetail);
						});
					}
				});
			},
			getPsf(orderDetail) {
				var _this = this;
				app.globalData.deliveryAndSelfTaking.feeData = 0;
				app.globalData.deliveryAndSelfTaking.reducedDeliveryTotalPrice = 0;
				app.globalData.deliveryAndSelfTaking.isReducedDeliveryPrice = false;
				var orderDetailList = orderDetail.orderDetailList;
				var packingCharges = 0;
				var totalNum = 0;
				var totalPrice = 0;
				var fullPriceReduction = orderDetail.fullPriceReduction;

				orderDetailList.forEach((result, index) => {
					totalNum = totalNum + result.number;
					result.goodsPrices = utilHelper.toFixed(Number(result.goodsPrice) * result
						.number, 2);
					totalPrice = totalPrice + (result.price * result.number); //初始化被选中的商品的总金额
					result.disable = result.goodsStatus == 1 || result.goodsStatus == 3 || result
						.goodsStatus == 4 ? true : false;
					packingCharges =
						result.goodsStatus == 1 || result.goodsStatus == 3 || result.goodsStatus ==
						4 ?
						packingCharges :
						packingCharges + result.packingCharges * result.number;
				});
				totalPrice = utilHelper.toFixed(totalPrice, 2);
				console.log('计算满减金额', totalPrice);
				var isStartDeliveryPrice = false;
				var priceDifference = 0;
				var startDeliveryPrice = app.globalData.deliveryAndSelfTaking.orderDetail.shopInfo.startDeliveryPrice;
				if (totalPrice + packingCharges >= startDeliveryPrice) {
					isStartDeliveryPrice = true;
				}
				var actualPrice = utilHelper.toFixed(totalPrice + packingCharges, 2);
				if (app.globalData.deliveryAndSelfTaking.selfOutActiveIndex == 0) {
					app.globalData.deliveryAndSelfTaking.orderDetail.fullPriceReduction = fullPriceReduction;
					app.globalData.deliveryAndSelfTaking.orderDetail.actualPrice = actualPrice;
					this.deliveryAndSelfTaking = app.globalData.deliveryAndSelfTaking;
					this.orderDetail = app.globalData.deliveryAndSelfTaking.orderDetail;
					console.log('this.orderDetail', this.orderDetail);
				}
				if (app.globalData.deliveryAndSelfTaking.selfOutActiveIndex == 1) {
					var addressid = app.globalData.deliveryAndSelfTaking.deliveryAddress.id;
					var shopId = app.globalData.deliveryAndSelfTaking.orderDetail.shopId;
					_this.confirmSelectDeliveryFee(addressid, shopId).then(result => {
						console.log("查询用户地址配送费=", result);
						let isReducedDeliveryPrice = false;
						let deliveryFee = Number(result.data);
						let feeData = deliveryFee;
						let reducedDeliveryTotalPrice = deliveryFee;
						console.log('用户地址配送费' + reducedDeliveryTotalPrice);
						if (_this.reducedDeliveryPrice >= reducedDeliveryTotalPrice) {
							feeData = 0;
						} else {
							feeData = feeData - _this.reducedDeliveryPrice;
						}
						console.log('用户最终支付的配送费' + feeData);
						if (reducedDeliveryTotalPrice != Number(feeData)) {
							isReducedDeliveryPrice = true;
						}
						console.log('isReducedDeliveryPrice=' + isReducedDeliveryPrice);
						console.log('app.globalData.deliveryAndSelfTaking.feeData=' + app.globalData
							.deliveryAndSelfTaking.feeData);
						console.log('feeData=' + feeData);
						app.globalData.deliveryAndSelfTaking.feeData = Number(feeData);
						app.globalData.deliveryAndSelfTaking.reducedDeliveryTotalPrice = Number(deliveryFee);
						app.globalData.deliveryAndSelfTaking.isReducedDeliveryPrice = isReducedDeliveryPrice;
						_this.setData({
							"deliveryAndSelfTaking.feeData": Number(feeData),
							"deliveryAndSelfTaking.reducedDeliveryTotalPrice": Number(deliveryFee),
							"deliveryAndSelfTaking.isReducedDeliveryPrice": isReducedDeliveryPrice
						})
						// this.deliveryAndSelfTaking.feeData = Number(feeData);
						// this.deliveryAndSelfTaking.reducedDeliveryTotalPrice = Number(deliveryFee);
						// this.deliveryAndSelfTaking.isReducedDeliveryPrice = isReducedDeliveryPrice;
						var actualPrice = utilHelper.toFixed(totalPrice + packingCharges, 2) + feeData;
						fullPriceReduction = utilHelper.toFixed(fullPriceReduction, 2) + feeData;
						app.globalData.deliveryAndSelfTaking.orderDetail.actualPrice = actualPrice;
						app.globalData.deliveryAndSelfTaking.orderDetail.fullPriceReduction = utilHelper.toFixed(
							fullPriceReduction, 2);
						console.log('app.globalData.deliveryAndSelfTaking=', app.globalData.deliveryAndSelfTaking);
						//_this.deliveryAndSelfTaking = app.globalData.deliveryAndSelfTaking;
						_this.orderDetail = app.globalData.deliveryAndSelfTaking.orderDetail;
						console.log(1111111111111111111111)
						console.log("deliveryAndSelfTaking=", _this.deliveryAndSelfTaking)
					})
				}
				setTimeout((time) => {
					_this.choosePayModeTap();
					clearTimeout(time);
				}, 1000);
			},

			goToRecharge(e) {
				this.setData({
					isVipDialogShow: false
				});
				uni.navigateTo({
					url: '/subPackages_pages/mine/member/recharge/recharge'
				});
			},

			customerServiceWechat() {
				console.log('占位：函数 customerServiceWechat 未声明');
			},

			goToPay() {
				console.log('占位：函数 goToPay 未声明');
			},

			trueFun() {
				console.log('占位：函数 true 未声明');
			},
			selfTap(e) {
				console.log(e);
				var index = e.currentTarget.dataset.index;
				var selfOutActiveIndex = this.selfOutActiveIndex;
				console.log("选择地址======", this.deliveryAndSelfTaking);
				var chooseId = this.deliveryAndSelfTaking.deliveryAddress ? this.deliveryAndSelfTaking
					.deliveryAddress.id :
					'';
				var chooseId = selfOutActiveIndex == 1 ? chooseId : '';
				var shopId = selfOutActiveIndex == 0 ? this.shopInfo.shop.id : app.globalData.deliveryAndSelfTaking
					.orderDetail.shopId;
				app.globalData.deliveryAndSelfTaking.chooseId = chooseId;
				app.globalData.deliveryAndSelfTaking.selfOutActiveIndex = selfOutActiveIndex;
				app.globalData.deliveryAndSelfTaking.pageType = 'pay';
				app.globalData.deliveryAndSelfTaking.chooseIndex = index;
				app.globalData.deliveryAndSelfTaking.ifChooseBack = false;
				app.globalData.deliveryAndSelfTaking.ifChoosePayBack = false;
				uni.navigateTo({
					url: `/subPackages_pages/address/choose/choose`
				})
			},
			openSupport(e) {
				var selfOutActiveIndex = this.selfOutActiveIndex;
				var selfOutItems = this.selfOutItems;
				var shopInfo = this.shopInfo;
				selfOutItems[0].show = shopInfo.shop.isSupportDinein; //堂食
				selfOutItems[1].show = shopInfo.shop.isSupportPickup; //自提
				selfOutItems[2].show = !shopInfo.shop.isSupportDelivery; //外送
				this.selfOutItems = selfOutItems;
				console.log(this.selfOutItems)
				this.showSelfOutItems = true;
			},
			chooseSupport(e) {
				console.log(e);
				var value = e.detail.value;
				this.selfOutActiveIndex = value;
				this.showSelfOutItems = false;
			},
			closeDialog: function() {
				this.showSelfOutItems = false;
			},
		}
	};
</script>
<style>
	page {
		background: #f5f5f5;
		padding-bottom: 120rpx;
	}

	.top-tips-view {
		background: white;
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 32rpx;
		font-weight: bold;
		line-height: 100rpx;
	}

	.probably-time-view {
		margin-left: 20rpx;
	}

	/* 单选框样式--自取配送 */

	.radio-group-view {
		display: flex;
		align-items: center;
		width: 25%;
	}

	.radio-group {
		width: 100%;
		display: flex;
		justify-content: center;
		align-items: center;
		flex-wrap: wrap;
		padding: 5rpx;
		border-radius: 50rpx;
		/* height: 66rpx; */
	}

	.radio-group-label {
		width: 46%;
		padding: 2%;
		font-size: 28rpx;
		border-radius: 50rpx;
		display: flex;
		justify-content: center;
		align-items: center;
		/* height: 60rpx; */
	}

	.not-active {
		color: white;
	}

	.ask-for-delivery-detail {
		margin: 20rpx;
		padding: 20rpx;
		background: white;
		border-radius: 15rpx;
	}

	.ask-for-delivery-title {
		font-size: 24rpx;
		font-weight: bold;
		line-height: 60rpx;
	}

	.ask-for-delivery {
		display: flex;
	}

	.ask-for-delivery-address {
		width: 75%;
	}

	.ask-for-delivery-house {
		width: 100%;
		font-size: 28rpx;
		display: flex;
		align-items: center;
	}

	.dizhi-phone-icon {
		width: 5%;
		height: auto;
	}

	.right-class {
		width: 90%;
	}

	.ask-for-delivery-address-detail {
		font-size: 28rpx;
		height: 40rpx;
		line-height: 40rpx;
		color: #7f7f7f;
		display: flex;
		align-items: center;
	}

	.ask-for-delivery-view {
		width: 90%;
	}

	.shopping-commodity-details {
		margin: 20rpx;
		padding: 20rpx;
		background: white;
		border-radius: 15rpx;
	}

	.commodity-name-price-detail {
		padding: 10rpx 0;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.commodity-name-types {
		width: 70%;
	}

	.commodity-name {
		font-size: 28rpx;
		font-weight: bold;
	}

	.commodity-types {
		font-size: 24rpx;
	}

	.commodity-totalnum {
		font-size: 30rpx;
	}

	.commodity-price {
		font-size: 28rpx;
		font-weight: bold;
	}

	.commodity-totalnum-price {
		width: 30%;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.total-money-view {
		width: 100%;
		line-height: 40rpx;
		margin-top: 20rpx;
		display: flex;
		align-items: center;
		justify-content: flex-end;
	}

	.total-title {
		font-size: 28rpx;
	}

	.total-money {
		font-size: 32rpx;
		font-weight: bold;
		margin-left: 20rpx;
		width: 40%;
	}

	.icon-wechat-pay {
		width: 50rpx;
		height: auto;
		margin-right: 20rpx;
	}

	.pay-mode-view {
		display: flex;
		align-items: center;
		justify-content: space-between;
		background: white;
		margin: 20rpx;
		padding: 20rpx;
		font-size: 30rpx;
		border-radius: 15rpx;
	}

	.choose-pay-mode {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.coupon-mode {
		width: 80%;
	}

	.ask-for-remarks-view {
		background: white;
		margin: 20rpx;
		padding: 20rpx;
		border-radius: 15rpx;
	}

	.choose-ask-for {
		display: flex;
		align-items: center;
		justify-content: space-between;
		line-height: 100rpx;
		font-size: 30rpx;
	}

	.remarks-title-input-num {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.remarks-title {
		font-size: 30rpx;
		line-height: 100rpx;
	}

	.remarks-input-num {
		font-size: 28rpx;
	}

	/* .remarks-view {
  padding-bottom: 120rpx;
} */

	.textarea-remarks {
		width: 94%;
		padding: 20rpx;
		background: #f5f5f5;
		border-radius: 10rpx;
		height: 120rpx;
		font-size: 28rpx;
		z-index: 0;
	}

	.iconwechat_pay {
		color: #09bb07;
		font-size: 40rpx;
	}

	.iconyue {
		color: #f0dcab;
		font-size: 40rpx;
	}

	.go-pay-view {
		position: fixed;
		bottom: 0;
		width: 100%;
		line-height: 100rpx;
		display: flex;
		align-items: center;
		background: white;
		box-shadow: -2px 0px 5px 0.5px rgba(0, 0, 0, 0.1);
		font-size: 36rpx;
		z-index: 1;
		border-top: 0.5rpx solid #f5f5f5;
	}

	.go-pay-money {
		padding: 0 20rpx;
		width: 70%;
		background: white;
		display: flex;
	}

	.more-pay {
		font-size: 32rpx;
	}

	.go-pay {
		width: 30%;
		color: white;
		text-align: center;
		font-size: 32rpx;
	}

	cover-view {
		line-height: 100rpx;
	}

	/*radio 选项框大小  */

	radio .wx-radio-input {
		width: 35rpx;
		height: 35rpx;
		border-radius: 50%;
		border-color: #ededed;
	}

	.ask-for-label {
		display: flex;
		align-items: center;
	}

	.ask-for-radio-group {
		width: 60%;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.ra-group-label {
		display: flex;
		align-items: center;
		padding: 10rpx;
	}

	.full-reduction-view {
		font-size: 24rpx;
		font-weight: bold;
		padding: 0 10rpx;
		margin: 0 5rpx;
		border-radius: 10rpx;
	}

	.fullPriceReductionClass {
		color: gainsboro;
		text-decoration: line-through;
	}

	.pay-mode-title {
		width: 20%;
		font-size: 28rpx;
	}

	.after-discount {
		font-size: 28rpx;
		font-weight: bold;
		text-align: end;
		width: 100%;
		font-size: 28rpx;
	}

	.swiper-tab {
		width: 100%;
		text-align: center;
		height: 88rpx;
		line-height: 88rpx;
		display: flex;
		flex-flow: row;
		justify-content: space-between;
		background: #fff;
		z-index: 1;
		border-bottom: 1rpx solid #ededed;
	}

	.swiper-tab-item {
		width: 50%;
	}

	.swiper-box {
		display: block;
		width: 100%;
		height: 100%;
		overflow: hidden;
	}

	.swiper-items {
		height: 100%;
	}

	.scroll-views {
		height: 100%;
		background: #fff;
	}

	.bindSlideChange {
		padding-top: 20rpx;
	}

	.space-between-class {
		width: 100%;
	}

	.bindSlideChange-class {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.currentTab1-view {
		margin-bottom: 20rpx;
	}

	.currentTab1-title {
		font-size: 26rpx;
		color: #7f7f7f;
	}

	.time-phone-view {
		border-top: 1rpx solid #f5f5f5;
		padding: 20rpx 0;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.time-phone-item {
		font-size: 24rpx;
	}

	.time-phone-content {
		width: 100%;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.time-phone-title {
		color: #7f7f7f;
	}

	.deliveryAddress-info {
		margin-bottom: 20rpx;
	}

	.dayue-time {
		display: flex;
		align-items: center;
		justify-content: space-between;
		margin-top: 20rpx;
		font-size: 26rpx;
	}

	.dayue-time-songda-view {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.ask-for-delivery-house-view {
		display: flex;
		align-items: center;
		justify-content: space-between;
		margin-bottom: 20rpx;
	}

	.payment-checked {
		background: linear-gradient(to right, #f2e1b5, #ebd198);
	}

	.payment-not-checked {
		background: #f0f0f0;
	}

	.radio-label-payment {
		padding: 8rpx 10rpx;
		font-size: 26rpx;
		border-radius: 18rpx;
		margin: 5rpx 0;
	}

	.pay_radio {
		display: none;
	}

	.radio-label-payment.flex_center.payment-checked .iconyue {
		color: black;
	}

	.actionItem__desc {
		font-size: 22rpx;
		color: red;
	}

	.current-tips {
		padding: 20rpx;
		font-size: 38rpx;
		border-radius: 10rpx;
		font-weight: bold;
		color: red;
	}

	.top-detail {
		margin: 20rpx;
		background-color: white;
		border-radius: 10rpx;
	}

	.weui-dialog.extClassIsVip {
		background-color: rgba(255, 255, 255, 0);
	}

	.weui-dialog.extClassIsVip .weui-dialog__bd {
		padding: 0;
	}

	.close-view-class .iconfont.icon55 {
		font-size: 62rpx;
		color: gainsboro;
	}

	.self_out_button {
		background: #ededed;
		border-radius: 50rpx;
		height: 2rem;
		line-height: 2rem;
		width: 30%;
		padding: 5rpx;
	}

	.self_button {
		font-size: 24rpx;
		width: 50%;
		text-align: center;
		padding: 0 10rpx;
	}

	.self_out_active {
		color: white;
		padding: 0 10rpx;
		border-radius: 50rpx;
	}

	.shop_info_view {
		font-size: 32rpx;
		width: 70%;
	}

	.shop_info_view_2 {
		width: 100%;
	}

	.distance_m {
		font-size: 28rpx;
		color: var(--tab-text-color, #646566);
		margin-top: 10rpx;
	}
</style>
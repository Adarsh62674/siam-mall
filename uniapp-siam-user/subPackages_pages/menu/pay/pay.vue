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
					@tap="selfTap" :data-index="selfOutActiveIndex">
					<view v-if="!shopInfo.shop.id&&selfOutActiveValue!=2&&!isLoading" class="flex_start"
						style="font-size: 30rpx;">
						<view style="color: #8f8f8f;">选择门店</view>
						<van-icon name="arrow" />
					</view>
					<block v-if="!shopInfo.shop.id&&isLoading">
						<van-loading custom-class="loading_box_class">加载中...</van-loading>
					</block>
					<block v-if="selfOutActiveValue!=2&&shopInfo.shop.id">
						<view class="flex_start">
							<view class="out_of_range one_row">{{shopInfo.shop.name}}</view>
							<van-icon name="arrow" />
						</view>
						<view class="distance_m" v-if="shopInfo.shop.id">
							{{shopInfo.shop.area}}{{shopInfo.shop.street}}
						</view>
					</block>
					<block v-if="selfOutActiveValue==2&&deliveryAddress.id">
						<view class="flex_between">
							<view class="out_of_range one_row" v-if="deliveryAddress">
								{{ deliveryAddress.province }}{{ deliveryAddress.city }}{{ deliveryAddress.area }}{{ deliveryAddress.street }}
							</view>
							<view v-else style="color: #8f8f8f;">请选择配送地址</view>
							<van-icon name="arrow" />
						</view>
						<view class="distance_m" v-if="deliveryAddress">
							{{ deliveryAddress.phone }}
							{{ deliveryAddress.realname }}
						</view>

					</block>
				</view>
				<view class="flex_between self_out_button" @tap="openSupport"
					v-if="selfOutItems.length>0&&selectCurrent.shopManagementMode==2">
					<view class="flex_center theme-color" style="width: 100%;">
						⇋ {{selfOutItems[selfOutActiveIndex].name}}
					</view>
				</view>
				<!-- <view class="flex_between self_out_button"
					v-if="selfOutItems.length>0&&selectCurrent.shopManagementMode==2">
					<view v-for="(item,index) in selfOutItems" @tap="selfTap" :data-index="item.index"
						:class="selfOutActiveIndex==index?'self_out_active self_button theme-bg':'self_button'">
						{{item.text}}
					</view>
				</view> -->
			</view>
		</view>
		<view class="shopping-commodity-details">
			<view v-if="shopInfo" class="display_flex_between" style="padding-bottom: 20rpx;">
				<view>
					{{ shopInfo.shop.name }}
				</view>
				<view id="table_name" v-if="selfOutActiveValue==0&&diningTable.tableName">
					<text>🔔</text>
					<text style="margin-left: 20rpx;" class="theme-color">{{diningTable.tableName}}</text>
				</view>
			</view>
			<!-- <view class="view-line"></view>
			<view
				v-if="orderDetail.continueOrderInfo.orderDetailList.length>0&&diningTable.tableId&&selfOutActiveValue==0"
				class="display_flex_between" style="padding: 20rpx 0;">
				<view class="theme-color">
					存在未支付订单
				</view>
				<view id="table_name" class="distance_m">
					<text>查看订单</text>
					<van-icon name="arrow" />
				</view>
			</view> 
			<view class="view-line" v-if="orderDetail.continueOrderInfo.orderDetailList.length>0"></view>-->
			<view style="margin: 20rpx 0;">
				<view class="commodity-name-price-detail" v-for="(item, index) in orderDetail.orderDetailList"
					:key="index">
					<view class="commodity-name-types">
						<view class="commodity-name">{{ item.goodsName }}</view>
						<view class="commodity-types">{{ item.restructure }}</view>
					</view>

					<view class="commodity-totalnum-price">
						<view class="commodity-totalnum">x{{ item.number }}</view>
						<view class="commodity-price">￥{{ item.totalPrice }}</view>
					</view>
				</view>
			</view>
			<view style="margin: 20rpx 0;">
				<view class="commodity-name-price-detail" v-if="selfOutActiveValue != 0">
					<view class="commodity-name-types">
						<view class="commodity-name">包装费</view>
						<view class="commodity-types commodity-delivery-tip theme-color">商品包装费</view>
					</view>
					<view class="commodity-totalnum-price">
						<view></view>
						<view class="commodity-price">￥{{ orderDetail.packingCharges }}</view>
					</view>
				</view>
				<view class="commodity-name-price-detail" v-if="deliveryAddress.id&&selfOutActiveValue == 2">
					<view class="commodity-name-types">
						<view class="commodity-name">配送费</view>
					</view>
					<view class="commodity-totalnum-price">
						<view></view>
						<view class="display_flex_between commodity-price">
							<view v-if="deliveryAddress.isReducedDeliveryPrice" class="fullPriceReductionClass">
								￥{{ deliveryAddress.reducedDeliveryTotalPrice }}</view>
							<view style="margin-left: 20rpx;">￥{{ deliveryAddress.feeData }}</view>
						</view>
					</view>
				</view>
				<view class="commodity-name-price-detail" v-if="orderDetail.fullPriceReductionIsHidden">
					<view class="commodity-name-types">
						<view class="commodity-name">满减</view>
					</view>
					<view class="commodity-totalnum-price">
						<view></view>
						<view class="commodity-price full-reduction-view theme-color-border">
							{{ orderDetail.fullReductionRuleName }}
						</view>
					</view>
				</view>
			</view>
			<view class="view-line"></view>
			<view class="total-money-view">
				<text class="money-icon commodity-price">总计：</text>
				<view :class="orderDetail.fullPriceReductionIsHidden || 
					orderDetail.couponsIsHidden || deliveryAddress.isThereADiscount ? 'fullPriceReductionClass' : ''">
					<text class="commodity-price">￥{{ orderDetail.actualPrice }}</text>
				</view>
				<text class="commodity-price" v-if="orderDetail.fullPriceReductionIsHidden || 
					orderDetail.couponsIsHidden || deliveryAddress.isThereADiscount" :decode="true">
					&nbsp;&nbsp;&nbsp;￥{{ orderDetail.fullPriceReduction }}
				</text>
			</view>
		</view>
		<view class="pay-mode-view" v-if="selfOutActiveValue!=0">
			<view class="pay-mode-title">优惠券</view>
			<view class="choose-pay-mode coupon-mode"
				@tap="parseEventDynamicCode($event, afterDiscount ? 'onCoupon' : '')">
				<view class="theme-color after-discount flex_end" v-if="afterDiscount">
					<view class="out_of_range tow_row">
						<text>{{ afterDiscount.couponsName ? afterDiscount.couponsName : '未使用优惠券 ' }}</text>
						<text :decode="true" class="">&nbsp;&nbsp;已优惠{{ afterDiscount.price }}元</text>
					</view>
				</view>
				<view class="theme-color after-discount" v-else>
					<text>无可用优惠券</text>
				</view>
				<van-icon name="arrow" />
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
				<view class="total-money" v-if="!orderDetail.fullPriceReductionIsHidden && 
					!orderDetail.couponsIsHidden && !deliveryAddress.isThereADiscount">
					￥{{ orderDetail.actualPrice }}
				</view>
				<view class="total-money" v-else>￥{{ orderDetail.fullPriceReduction }}</view>
			</view>
			<view :class="(deliveryAddress.isStartDeliveryPrice ? 'theme-bg' : 'shopping-cart-bg') + ' go-pay'" @tap="
			        parseEventDynamicCode(
			            $event,
			            orderDetail.orderDetailList.length <= 0 ||
			                !deliveryAddress.isStartDeliveryPrice ||
			                shopInfo.isOutofDeliveryRange ||
			                !shopInfo.isOperatingOfShop ||
			                !shopInfo.shop.isOperating
			                ? ''
			                : isForgetThePassword ? 'showPwdLayer' : 'getRequestSubscribeMessage'
			        )
			    " v-if="selfOutActiveValue==2">
				{{ deliveryAddress.isStartDeliveryPrice ? '去支付' : '差 ￥' + orderDetail.priceDifference + ' 起送' }}
			</view>
			<view v-else class="go-pay theme-bg">
				<view v-if="selfOutActiveValue==0&&!diningTable.tableId" @tap="scanTableCode">扫餐桌码就餐</view>
				<view v-else @tap="parseEventDynamicCode(
			            $event,
			            orderDetail.orderDetailList.length <= 0 
			                ? ''
			                : isForgetThePassword ? 'showPwdLayer' : 'getRequestSubscribeMessage'
			        )">{{orderDetail.orderDetailList.length <= 0?'未选择商品':'去支付'}}</view>
			</view>
			<!-- <view class="go-pay theme-bg" hover-class="hover-class-public"
				@tap="parseEventDynamicCode($event, isForgetThePassword ? 'showPwdLayer' : 'getRequestSubscribeMessage')">
				{{ isStartDeliveryPrice ? '去支付' : '差 ￥' + priceDifference + ' 起送' }}
			</view> -->
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
				<van-icon name="clear" @tap="orderCreate" style="font-size: 40px;color: wheat;" />
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
	import stringService from '../../../utils/string-service';
	import orderJs from '/utils/commonJS/order.js';

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
				showSelfOutItems: false,
				selfOutItems: [],
				selfOutActiveIndex: 1,
				selfOutActiveValue: 1,
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
				deliveryAddress: {
					province: '',
					city: '',
					area: '',
					street: '',
					phone: '',
					realname: '',
					sex: 0,
					isReducedDeliveryPrice: false,
					reducedDeliveryTotalPrice: 0,
					feeData: 0,
					isThereADiscount: '',
					isStartDeliveryPrice: false
				},
				currentTab: '',
				orderDetail: {
					actualPrice: 0,
					orderDetailList: [],
					packingCharges: 0,
					continueOrderInfo: {
						orderDetailList: []
					},
					priceDifference: 0,
					fullPriceReduction: 0,
					couponsIsHidden: false,
					fullPriceReductionIsHidden: false,
					fullReductionRuleName: ''
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
					price: 0
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
				shopInfo: {
					shop: {
						name: ''
					}
				},
				fullPriceReduction: 0,
				selectCurrent: {},
				diningTable: {},
				isLoading: true,
				scanTableCodeInfo: {
					scanType: '',
					result: '',
					isScan: false,
					options: {}
				},
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
			if (this.scanTableCodeInfo.isScan) {
				if (!'tableId' in this.scanTableCodeInfo.options) {
					toastService.showToast("餐桌二维码错误");
				}
				this.scanTableCodeInfo.isScan = false;
				return;
			}
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
		onUnload: function() {

		},
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
			onLoadOptions(options) {
				var _this = this;
				var deliveryAndSelfTaking = app.globalData.deliveryAndSelfTaking;
				console.log("deliveryAndSelfTaking=====", deliveryAndSelfTaking)
				var selfOutActiveIndex = deliveryAndSelfTaking.selfOutActiveIndex;
				var selfOutActiveValue = deliveryAndSelfTaking.selfOutActiveValue;
				let diningTable = deliveryAndSelfTaking.diningTable;
				var shopId = deliveryAndSelfTaking.shopInfo.shop.id;
				if (stringService.isEmpty(shopId)) {
					uni.switchTab({
						url: `/pages/menu/index/index`
					})
				}
				console.log(deliveryAndSelfTaking);
				if (!stringService.isEmpty(shopId)) {
					app.globalData.selectCurrentInfo().then(result => {
						this.selectCurrent = result;
						this.shopDetail(shopId, diningTable.tableId);
					});

				}
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
						this.userInfo = result.data;
					}
				});
			},
			closeDialog: function() {
				this.dialogShow = false;
				this.showSelfOutItems = false;
			},
			orderCreate() {
				this.isVipDialogShow = false;
				toastService.showLoading();
				var _this = this;
				var data = this.isPayJson;
				console.log("订单入参=", data);
				var continueOrderInfo = app.globalData.deliveryAndSelfTaking.continueOrderInfo;
				var checkoutMode = this.shopInfo.shop.checkoutMode;
				console.log("continueOrderInfo11111=", continueOrderInfo, checkoutMode, this
					.selfOutActiveValue);
				console.log("checkoutMode=shopInfo=selfOutActiveValue", checkoutMode, this
					.shopInfo, this.selfOutActiveValue);
				if (this.selfOutActiveValue == 0 && checkoutMode == 2) {
					if (('id' in continueOrderInfo) && !stringService.isEmpty(continueOrderInfo.id)) {
						orderJs.orderAddDish(data).then(result => {
							if (result.success) {
								uni.redirectTo({
									url: `/subPackages_pages/order/detail/detail?id=${result.data.id}&selectedTableld=${result.data.tableId}`
								});
							}
						});
					} else {
						orderJs.orderInsert(data).then(result => {
							if (result.success) {
								uni.redirectTo({
									url: `/subPackages_pages/order/detail/detail?id=${result.data.id}&selectedTableld=${result.data.tableId}`
								});
							}
						});
					}
				}
				if (this.selfOutActiveValue != 0 || checkoutMode == 1) {
					orderJs.orderInsert(data).then(result => {
						if (result.success) {
							this.toPay4Applet(result.data.id, result.data.orderNo,
								result.data.actualPrice);
						}
					});
				}
			},
			radioChangeAddress(e) {
				console.log(e);
				var that = this;
				var paymentModeIndex = e.detail.value;
				authService.getOpenId().then((openId) => {
					console.log(openId);
					that.closeDialog();
					let paymentModes = that.paymentModes;
					// if (e.detail.value == 0) {
					// 	toastService.showToast('暂不支持微信支付，请选择余额支付/积分支付');
					// 	return;
					// }
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
			orderDetailListInfo(orderDetail) {
				return new Promise((fulfil, reject) => {
					var packingCharges = 0;
					var totalNum = 0;
					var totalPrice = 0;
					var orderDetailList = orderDetail.orderDetailList;
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
							packingCharges + (result.packingCharges * result.number);
					});
					packingCharges = this.selfOutActiveValue != 0 || stringService.isEmpty(this.diningTable
						.tableId) ? packingCharges : 0;
					totalPrice = utilHelper.toFixed(totalPrice + packingCharges, 2);
					orderDetail.actualPrice = totalPrice;
					orderDetail.fullPriceReduction = totalPrice;
					orderDetail.packingCharges = packingCharges;
					fulfil(orderDetail);
				});

			},
			choosePayModeTap(orderDetail) {
				let paymentModes = this.paymentModes;
				let paymentModeIndex = this.paymentModeIndex;
				let actualPrice = !orderDetail.fullPriceReduction ?
					orderDetail.actualPrice :
					orderDetail.fullPriceReduction;
				console.log('this.orderDetail=', orderDetail);
				console.log('余额=', this.userInfo.balance);
				console.log('需支付金额=', actualPrice);
				console.log('需支付金额=', actualPrice);
				if (paymentModes[paymentModeIndex].value == 2) {
					paymentModes[paymentModeIndex].desc = '';
					paymentModes[paymentModeIndex].isBindTap = true;
					if (!this.userInfo.paymentPassword) {
						paymentModes[paymentModeIndex].desc = '未设置支付密码,去设置';
						paymentModes[paymentModeIndex].isBindTap = false;
					}
					if (actualPrice > this.userInfo.balance) {
						paymentModes[paymentModeIndex].desc = '余额不足';
						paymentModes[paymentModeIndex].isBindTap = false;
						paymentModeIndex = 1;
					}
				}
				toastService.hideLoading();
				this.paymentModeIndex = paymentModeIndex;
				this.paymentModes = paymentModes;
				this.orderDetail = orderDetail;
				app.globalData.deliveryAndSelfTaking.orderDetail = this.orderDetail;
			},
			remarksInput(e) {
				this.setData({
					inputLength: e.detail.value.length,
					remarks: e.detail.value
				});
			},
			shopDetail(shopId, tableId) {
				var shopInfo = {
					id: shopId,
					tableId: tableId
				}
				app.globalData.getShopInfo(shopId).then((result) => {
					if (result) {
						this.shopInfo = result;
						this.getLocalCartList(shopId, tableId).then((
							isCart) => {
							if (isCart) {
								//this.getShoppingCartList(shopId, tableId);
							}
						});
					}
				});
			},
			getLocalCartList(shopId, tableId) {
				var _this = this;
				return new Promise((fulfill, reject) => {
					_this.getShoppingCartList(shopId, tableId).then((result) => {
						if (!result) {
							return
						}
						if (!stringService.isEmpty(tableId)) {
							if (this.shopInfo.shop.checkoutMode == 2) {
								this.selectUnpaidDineInByTableId(shopId, tableId).then(
									continueOrderInfo => {
										this.orderDetail.continueOrderInfo = continueOrderInfo;
									});
							}
						} else {
							fulfill(false);
						}
					})
				});
			},
			getShoppingCartList(shopId, tableId) {
				var _this = this;
				this.shoppingCartList = [];
				return new Promise((fulfill, reject) => {
					orderJs.memberShoppingCartList(shopId, tableId).then((result) => {
						var shoppingCart = result;
						var deliveryAndSelfTaking = app.globalData.deliveryAndSelfTaking;
						var shopInfo = deliveryAndSelfTaking.shopInfo;
						var isStartDeliveryPrice = false;
						var startDeliveryPrice = shopInfo.shop.startDeliveryPrice;
						var shopId = shopInfo.shop.id;
						var orderDetailList = shoppingCart.orderDetailList;
						var tableId = deliveryAndSelfTaking.diningTable.tableId;
						var continueOrderInfo = deliveryAndSelfTaking.continueOrderInfo;
						var orderDetail = {};
						orderDetail.orderDetailList = orderDetailList;
						orderDetail.actualPrice = shoppingCart.totalPrice;
						orderDetail.fullPriceReduction = shoppingCart.totalPrice;
						orderDetail.reducedPrice = 0;
						orderDetail.packingCharges = shoppingCart.packingCharges;
						orderDetail.continueOrderInfo = continueOrderInfo;
						orderDetail.shopId = shopId;

						this.shopId = shopInfo.shop.id;
						this.shopInfo = shopInfo;
						this.selfOutActiveIndex = deliveryAndSelfTaking.selfOutActiveIndex;
						this.selfOutActiveValue = deliveryAndSelfTaking.selfOutActiveValue;
						this.selfOutItems = deliveryAndSelfTaking.selfOutItems;
						this.diningTable = deliveryAndSelfTaking.diningTable;
						this.deliveryAddress = deliveryAndSelfTaking.deliveryAddress;
						this.orderDetail = orderDetail;

						this.selfOutItems.forEach((item, itemIndex) => {
							item.checked = (itemIndex == this.selfOutActiveIndex);
						});

						console.log("this.selfOutActiveValue=", this.selfOutActiveValue);
						if (this.selfOutActiveValue != 0) {
							this.selectCommissionReward(orderDetail);
							this.getCouponsMemberRelation(orderDetail);
						} else {
							setTimeout((time) => {
								_this.choosePayModeTap(orderDetail);
								_this.isLoading = false;
								clearTimeout(time);
							}, 1000);
						}
						fulfill(shoppingCart);
					});
				});
			},
			getCouponsMemberRelation(orderDetail) {
				var _this = this;
				orderJs.couponsMemberRelationList(orderDetail).then((result) => {
					if (result.success) {
						let afterDiscounts = [];
						result.data.records.forEach((res) => {
							//判断优惠券是否过期和是否已经使用
							//判断当前优惠券是折扣还是满减券,1等于折扣,2等于满减
							if (res.couponsMemberRelationMap.preferentialType == 1) {
								if (res.shopList.length <= 0) {
									return;
								}
								res.shopList.forEach((shop, shopIndex) => {
									if (shop.id == orderDetail.shopId) {
										//遍历当前订单的商品
										orderDetail.orderDetailList.forEach((order,
											orderIndex) => {
											//source  优惠券发放来源 1=商家中心 2=平台管理端
											//如果是商家中心发放的优惠券，则需要判断关联商品
											//平台管理端发放的优惠券，则无需判断关联商品，所有商品皆可使用
											console.log(order.price);
											let orderPrice = order.price;
											let unitPrice = utilHelper.toFixed(
												orderPrice -
												orderPrice * res
												.couponsMemberRelationMap
												.discountAmount, 2);
											if (res.couponsMemberRelationMap
												.source == 1) {
												res.goodsList.forEach((goods) => {
													//判断当前订单的商品是否等于优惠券绑定的优惠商品
													//等于则进行优惠
													if (order.goodsId == goods
														.id) {
														afterDiscounts.push({
															id: res
																.couponsMemberRelationMap
																.id,
															price: res
																.couponsMemberRelationMap
																.discountAmount !=
																0 ?
																unitPrice :
																unitPrice,
															goodsId: order
																.goodsId,
															couponsId: res
																.couponsMemberRelationMap
																.couponsId,
															couponsName: res
																.couponsMemberRelationMap
																.couponsName,
															preferentialType: systemStatus
																.preferentialTypeText(
																	res
																	.couponsMemberRelationMap
																	.preferentialType
																),
															isExpired: res
																.couponsMemberRelationMap
																.isExpired,
															isUsed: res
																.couponsMemberRelationMap
																.isUsed,
															isValid: res
																.couponsMemberRelationMap
																.isValid
														});
													}
												});
												return;
											}
											afterDiscounts.push({
												id: res
													.couponsMemberRelationMap
													.id,
												price: res
													.couponsMemberRelationMap
													.discountAmount != 0 ?
													unitPrice : unitPrice,
												goodsId: order.goodsId,
												couponsId: res
													.couponsMemberRelationMap
													.couponsId,
												couponsName: res
													.couponsMemberRelationMap
													.couponsName,
												preferentialType: systemStatus
													.preferentialTypeText(
														res
														.couponsMemberRelationMap
														.preferentialType),
												isExpired: res
													.couponsMemberRelationMap
													.isExpired,
												isUsed: res
													.couponsMemberRelationMap
													.isUsed,
												isValid: res
													.couponsMemberRelationMap
													.isValid
											});
										});
									}
								});
							}
							//判断如果是优惠券满减的话这就进行优惠券的总价满减
							//console.log(res)
							if (res.couponsMemberRelationMap.preferentialType == 2) {
								if (orderDetail.fullPriceReduction) {
									if (orderDetail.fullPriceReduction >= res
										.couponsMemberRelationMap
										.limitedPrice) {
										//console.log(res.couponsMemberRelationMap.limitedPrice)
										afterDiscounts.push({
											id: res.couponsMemberRelationMap.id,
											couponsId: res.couponsMemberRelationMap
												.couponsId,
											price: utilHelper.toFixed(orderDetail
													.fullPriceReduction,
													2) - res.couponsMemberRelationMap
												.reducedPrice,
											couponsName: res.couponsMemberRelationMap
												.couponsName,
											preferentialType: systemStatus
												.preferentialTypeText(res
													.couponsMemberRelationMap
													.preferentialType),
											isExpired: res.couponsMemberRelationMap
												.isExpired,
											isUsed: res.couponsMemberRelationMap.isUsed,
											isValid: res.couponsMemberRelationMap.isValid
										});
									}
									return;
								}
								if (orderDetail.actualPrice >= res.couponsMemberRelationMap
									.limitedPrice) {
									afterDiscounts.push({
										id: res.couponsMemberRelationMap.id,
										couponsId: res.couponsMemberRelationMap.couponsId,
										price: orderDetail.actualPrice - res
											.couponsMemberRelationMap
											.reducedPrice,
										couponsName: res.couponsMemberRelationMap
											.couponsName,
										preferentialType: systemStatus
											.preferentialTypeText(res
												.couponsMemberRelationMap.preferentialType
											),
										isExpired: res.couponsMemberRelationMap.isExpired,
										isUsed: res.couponsMemberRelationMap.isUsed,
										isValid: res.couponsMemberRelationMap.isValid
									});
								}
							}
						});
						//获取配送费，配送费不作为满减条件
						this.orderDetailListInfo(orderDetail).then((result) => {
							console.log("计算满减金额=", result.actualPrice);
							//如果优惠券的使用张数大于0张
							let fullPriceReduction = result.fullPriceReduction;
							var afterDiscountPrice = 0;
							var afterDiscountList;
							var couponsIsHidden = false;
							if (afterDiscounts.length > 0) {
								//遍历所有可以使用优惠券的商品，并计算出最大的优惠券
								afterDiscounts.forEach((afterDiscount) => {
									var price = afterDiscount.price;
									if (Number(price) >= afterDiscountPrice) {
										afterDiscountPrice = price;
										afterDiscountList = afterDiscount;
									}
								});
								fullPriceReduction = fullPriceReduction - afterDiscountPrice;
								couponsIsHidden = true;
							}
							this.afterDiscount = afterDiscountList;
							orderDetail.couponsIsHidden = couponsIsHidden;
							orderDetail.fullPriceReduction = utilHelper.toFixed(fullPriceReduction <= 0 ?
								0 : fullPriceReduction, 2);
							this.$nextTick(() => {
								_this.getShopCartFullReductionRule(result);
							});
						})
					}
				});
			},
			onCoupon() {
				let afterDiscount = this.afterDiscount;
				afterDiscount.fullPriceReduction = this.orderDetail.fullPriceReduction;
				afterDiscount.actualPrice = this.orderDetail.actualPrice;
				afterDiscount.fullPriceReductionIsHidden = this.orderDetail
					.fullPriceReductionIsHidden;
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
			selectCommissionReward(orderDetail) {
				console.log("selectCommissionReward=", orderDetail)
				https.request('/rest/member/order/selectCommissionReward', {
					actualPrice: !orderDetail.fullPriceReductionIsHidden && !orderDetail
						.couponsIsHidden ? orderDetail.actualPrice : orderDetail.fullPriceReduction
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
				} else {
					self.weChatPayTap();
				}
				// #endif
			},
			weChatPayTap() {
				authService.checkIsLogin().then((result) => {
					if (!result) {
						app.globalData.checkIsAuth('scope.userInfo');
						return;
					}
					console.log(11111111111111111111);
					//判断店铺是否打烊
					let startTime = this.shopInfo.shop.startTime;
					let endTime = this.shopInfo.shop.endTime;
					let isOperating = this.shopInfo.shop.isOperating;
					app.globalData.getIsBusiness(startTime, endTime, isOperating).then((result) => {
						if (!result) {
							return;
						}
						var data = {};
						if (this.shopInfo.shop == null) {
							toastService.showToast('请选择门店地址');
							return;
						}
						var actualPrice = 0;
						if (this.selfOutActiveValue == 2) {
							if (this.deliveryAddress == null) {
								toastService.showToast('请选择配送地址');
								return;
							}
							data.deliveryAddressId = this.deliveryAddress.id;
							data.deliveryFee = this.deliveryAddress.feeData;
							actualPrice = actualPrice + data.deliveryFee;
							console.log("配送费计算金额=", String(actualPrice))
						}
						var list = this.orderDetail.orderDetailList;
						var orderDetailList = [];
						data.shoppingCartIdList = [];
						var payType = app.globalData.deliveryAndSelfTaking.payType;
						var packingCharges = 0;
						list.forEach((item, index) => {
							packingCharges = packingCharges + (item.packingCharges * item.number);
							orderDetailList.push({
								goodsId: item.goodsId,
								goodsName: item.goodsName,
								specList: item.specList,
								number: item.number
							});
							actualPrice = actualPrice + (item.price * item.number)
							if (payType == 'car') {
								data.shoppingCartIdList.push(item.id);
							}
						})
						console.log("计算金额=", String(actualPrice))
						actualPrice = actualPrice + packingCharges;
						console.log("订单包装费=", packingCharges, "包装费计算金额=", String(actualPrice))
						data.orderDetailListStr = JSON.stringify(orderDetailList);
						data.remark = this.remarks;
						data.shoppingWay = this.selfOutActiveValue;
						data.shopId = this.orderDetail.shopId;
						if (this.selfOutActiveValue != 0 && this.orderDetail.couponsIsHidden) {
							data.couponsId = this.afterDiscount.couponsId;
							data.couponsMemberRelationId = this.afterDiscount.id;
							data.couponsDescription = this.afterDiscount.couponsName;
							actualPrice = actualPrice - this.afterDiscount.price;
							console.log("优惠券计算金额=", String(actualPrice))
						}
						if (this.selfOutActiveValue != 0 && this.orderDetail.fullReductionRuleId) {
							data.fullReductionRuleId = this.orderDetail.fullReductionRuleId;
							data.fullReductionRuleDescription = this.orderDetail
								.fullReductionRuleName;
							actualPrice = actualPrice - (!this.orderDetail.fullPriceReductionIsHidden ?
								this.orderDetail.fullPriceReduction : 0);
							console.log("店铺满减计算金额=", String(actualPrice))
							actualPrice = actualPrice - this.orderDetail.reducedPrice;
							console.log("店铺满减计算金额=", String(actualPrice))
						}
						if (this.selfOutActiveValue == 0 && this.diningTable.tableId) {
							data.tableId = this.diningTable.tableId;
							data.tableNo = this.diningTable.tableNo;
							data.tableName = this.diningTable.tableName;
							actualPrice = actualPrice - packingCharges;
							console.log("餐桌码计算金额=", String(actualPrice))
						}
						data.actualPrice = actualPrice;
						console.log("订单入参=", JSON.stringify(data));
						if (this.paymentModes[this.paymentModeIndex].value == 2) {
							if (!this.userInfo.paymentPassword) {
								uni.navigateTo({
									url: '/subPackages_pages/mine/security/index/index'
								});
								return;
							}
							if (actualPrice > this.userInfo.balance) {
								toastService.showToast("余额不足");
								return;
							}
						}

						//获取订单的配送方式
						if (this.userInfo.type == 1) {
							this.isVipDialogShow = true;
							this.isPayJson = data;
						} else {
							this.isPayJson = data;
							this.orderCreate();
						}
					});
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
						this.$nextTick(() => {
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
										url: '/subPackages_pages/order/detail/detail?id=' +
											id
									});
									clearTimeout(timeout);
								}, 1000);
							},
							fail(res) {
								toastService.showError('支付失败', true);
								let timeout = setTimeout(() => {
									uni.redirectTo({
										url: '/subPackages_pages/order/detail/detail?id=' +
											id
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
				setTimeout(timeout => {
					console.log("点击获取焦点");
					_this.payFocus = true;
				}, 500);
			},
			balancePay() {
				var password = Base64.encode(this.pwdVal);
				this.pwdVal = '';
				this.payFocus = true;
				var data = {
					openid: this.balanceOpenId,
					type: 1,
					paymentMode: 2,
					paymentPassword: password,
					out_trade_no: this.balanceOrderNo,
					total_fee: this.orderDetail.fullPriceReductionIsHidden ? this.orderDetail.fullPriceReduction : this
						.balanceActualPrice
				}
				console.log("下单入参=", data);
				https.request('/rest/member/platformPay/byBalance', data).then((result) => {
					toastService.hideLoading();
					if (result.success) {
						toastService.showSuccess('支付成功', true);
						this.hidePwdLayer();
						let timeout = setTimeout(() => {
							uni.redirectTo({
								url: '/subPackages_pages/order/detail/detail?id=' + this.balanceId
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
			getShopCartFullReductionRule(orderDetail) {
				var _this = this;
				var shopId = orderDetail.shopId;
				var totalPrice = orderDetail.fullPriceReduction;
				orderJs.getShopCartFullReductionRule(shopId, totalPrice).then((result) => {
					for (let key in result) {
						orderDetail[key] = result[key];
					}
					this.$nextTick(() => {
						_this.getDeliveryFee(orderDetail);
					});
				});
			},
			getDeliveryFee(orderDetail) {
				var _this = this;
				app.globalData.deliveryAndSelfTaking.deliveryAddress.feeData = 0;
				app.globalData.deliveryAndSelfTaking.deliveryAddress.reducedDeliveryTotalPrice = 0;
				app.globalData.deliveryAndSelfTaking.deliveryAddress.isReducedDeliveryPrice = false;
				var packingCharges = orderDetail.packingCharges;
				var totalNum = orderDetail.totalNum;
				var totalPrice = orderDetail.actualPrice;
				var orderDetailList = orderDetail.orderDetailList;
				var fullPriceReduction = orderDetail.fullPriceReduction;
				var deliveryAndSelfTaking = app.globalData.deliveryAndSelfTaking;
				var shopInfo = this.shopInfo;

				//计算实际价格（应收金额)
				if (this.selfOutActiveValue != 2) {
					this.$nextTick(() => {
						this.choosePayModeTap(orderDetail);
					});
				}
				if (this.selfOutActiveValue == 2) {
					var deliveryAddress = deliveryAndSelfTaking.deliveryAddress;
					var addressid = deliveryAddress.id;
					var shopId = shopInfo.shop.id;
					var isStartDeliveryPrice = false;
					var startDeliveryPrice = shopInfo.shop.startDeliveryPrice;
					var priceDifference = startDeliveryPrice - (totalPrice + packingCharges);
					if (totalPrice + packingCharges >= startDeliveryPrice) {
						isStartDeliveryPrice = true;
					}
					console.log("confirmSelectDeliveryFeeisStartDeliveryPrice=", String(isStartDeliveryPrice));
					var reducedDeliveryPrice = shopInfo.shop.reducedDeliveryPrice;
					orderJs.confirmSelectDeliveryFee(addressid, shopId).then(result => {
						console.log("查询用户地址配送费=", result);
						let deliveryFee = Number(result.data);
						let feeData = deliveryFee;
						let reducedDeliveryTotalPrice = deliveryFee;
						console.log('用户地址配送费', reducedDeliveryTotalPrice);
						//计算配送费优惠
						if (reducedDeliveryPrice >= reducedDeliveryTotalPrice) {
							feeData = 0;
						} else {
							feeData = feeData - reducedDeliveryPrice;
						}
						console.log('用户最终支付的配送费', feeData);
						let isReducedDeliveryPrice = reducedDeliveryTotalPrice != Number(feeData);
						console.log('isReducedDeliveryPrice=', isReducedDeliveryPrice);
						console.log('app.globalData.deliveryAndSelfTaking.feeData=', app.globalData
							.deliveryAndSelfTaking.feeData);
						console.log('feeData=', feeData);
						this.deliveryAddress.isStartDeliveryPrice = isStartDeliveryPrice;
						this.deliveryAddress.isReducedDeliveryPrice = isReducedDeliveryPrice;
						this.deliveryAddress.feeData = Number(feeData);
						this.deliveryAddress.reducedDeliveryTotalPrice = Number(deliveryFee);

						orderDetail.priceDifference = priceDifference;
						orderDetail.actualPrice = totalPrice + feeData;
						orderDetail.fullPriceReduction = utilHelper.toFixed(
							fullPriceReduction, 2) + feeData;
						app.globalData.deliveryAndSelfTaking.orderDetail = orderDetail;
						app.globalData.deliveryAndSelfTaking.deliveryAddress.feeData = this.deliveryAddress
							.feeData;
						app.globalData.deliveryAndSelfTaking.deliveryAddress.reducedDeliveryTotalPrice = this
							.deliveryAddress.reducedDeliveryTotalPrice;
						app.globalData.deliveryAndSelfTaking.deliveryAddress.isReducedDeliveryPrice = this
							.deliveryAddress
							.isReducedDeliveryPrice;
						this.$nextTick(() => {
							console.log('choosePayModeTap=', orderDetail);
							this.choosePayModeTap(orderDetail);
						});
					})
				}
			},
			goToRecharge(e) {
				this.setData({
					isVipDialogShow: false
				});
				uni.navigateTo({
					url: '/subPackages_pages/mine/member/recharge/recharge'
				});
			},
			selfTap(e) {
				console.log(e);
				var selfOutActiveIndex = e.currentTarget.dataset.index;
				this.toChoosePage(selfOutActiveIndex, true);
			},
			toChoosePage(selfOutActiveIndex, toChoose) {
				console.log(selfOutActiveIndex, toChoose)
				if (!toChoose) {
					var tableId = this.diningTable.tableId;
					this.shopDetail(this.shopInfo.shop.id, tableId);
				}
				var deliveryAddress = this.deliveryAddress;
				var selfOutActiveValue = this.selfOutItems[selfOutActiveIndex].value;
				if (!stringService.isEmpty(deliveryAddress.id)) {
					this.selfOutActiveIndex = selfOutActiveIndex;
				}
				app.globalData.deliveryAndSelfTaking.selfOutActiveIndex = selfOutActiveIndex;
				app.globalData.deliveryAndSelfTaking.selfOutActiveValue = selfOutActiveValue;
				if (selfOutActiveValue == 2 && toChoose) {
					app.globalData.deliveryAndSelfTaking.pageType = 'pay';
					app.globalData.deliveryAndSelfTaking.deliveryActiveIndex = selfOutActiveValue != 2 ? 0 : 1;
					uni.navigateTo({
						url: `/subPackages_pages/address/choose/choose`
					});
					toastService.hideLoading();
				};
			},
			openSupport(e) {
				var selfOutActiveIndex = this.selfOutActiveIndex;
				var selfOutItems = this.selfOutItems;
				var shopInfo = this.shopInfo;
				selfOutItems[0].show = shopInfo.shop.isSupportDinein; //堂食
				selfOutItems[1].show = shopInfo.shop.isSupportPickup; //自提
				selfOutItems[2].show = shopInfo.shop.isSupportDelivery; //外送
				this.selfOutItems = selfOutItems;
				this.showSelfOutItems = true;
				app.globalData.deliveryAndSelfTaking.selfOutItems = this.selfOutItems;
				app.globalData.deliveryAndSelfTaking.showSelfOutItems = this.showSelfOutItems;
			},
			chooseSupport(e) {
				console.log(e);
				toastService.showLoading();
				var selfOutActiveIndex = e.detail.index;
				var selfOutActiveValue = e.detail.value;
				var orderDetail = this.orderDetail;
				var tableId = this.diningTable.tableId;
				var deliveryAddress = this.deliveryAddress;
				if (selfOutActiveValue == 0 && stringService.isEmpty(tableId)) {
					// toastService.hideLoading();
					// toastService.showToast("请扫餐桌码就餐");
					this.scanTableCode();
					return
				}

				//this.initDataSelf(selfOutActiveIndex);
				var toChoose = selfOutActiveValue == 2 && stringService.isEmpty(deliveryAddress.id) ? true : false;
				this.toChoosePage(selfOutActiveIndex, toChoose);
			},
			selectUnpaidDineInByTableId: function(shopId, tableId) {
				return new Promise((fulfill, reject) => {
					orderJs.selectUnpaidDineInByTableId(tableId).then(result => {
						if (!result.success) {
							fulfill({});
						}
						if (result.success) {
							var data = result.data;
							fulfill(data);
							// if (this.orderDetail.continueOrderInfo.orderDetailList.length > 0) {
							// 	orderJs.orderBySelectById(data.id).then(continueOrderInfo => {
							// 		fulfill(continueOrderInfo);
							// 	});
							// }
							// if (this.orderDetail.continueOrderInfo.orderDetailList.length == 0) {
							// 	orderJs.orderBySelectById(data.id).then(
							// 		continueOrderInfo => {
							// 			fulfill(continueOrderInfo);
							// 		});
							// }
						}
					});
				});
			},
			scanTableCodeLoad: function(options, res) {
				this.scanTableCodeInfo.isScan = true;
				this.scanTableCodeInfo.options = options;
				this.scanTableCodeInfo.scanType = res.scanType;
				this.scanTableCodeInfo.result = res.result;
				if ((!'tableId' in options) || (!'id' in options)) {
					setTimeout(() => {
						toastService.showToast("餐桌二维码错误");
					}, 1000);
				} else {
					var shopId = this.shopInfo.shop.id;
					if (shopId != options.id) {
						toastService.showToast("餐桌二维码门店错误,请返回菜单页扫码绑定餐桌");
						return
					}
					orderJs.diningTableFindById(options.tableId).then(result => {
						if (result.success) {
							var idList = [];
							this.orderDetail.orderDetailList.forEach((item, index) => {
								idList.push(item.id);
							});
							if (idList.length > 0) {
								orderJs.shoppingCartBindTable(idList, options.tableId).then((bindTable) => {
									if (bindTable) {
										this.$nextTick(() => {
											setTimeout(() => {
												this.shopDetail(result.data.shopId,
													options.tableId);
											}, 500);
										});
									}
								});
							}
						}
					});
				}
			},
			scanTableCode: function() {
				var _this = this;
				this.scanTableCodeInfo.isScan = true;
				// 允许从相机和相册扫码
				uni.scanCode({
					success: function(res) {
						console.log('条码类型：' + res.scanType);
						console.log('条码内容：' + res.result);
						if (res.scanType == 'QR_CODE') {
							var options = stringService.urlToJson(res.result);
							_this.scanTableCodeLoad(options, res);
						}
						if (res.scanType == 'WX_CODE') {

						}
					},
					fail: function(error) {
						console.log(error);
					}
				});
			}
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

	.shopping-cart-bg {
		background: #535257;
	}
</style>
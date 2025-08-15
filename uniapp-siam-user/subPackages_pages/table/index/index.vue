<template>
	<view class="content-class">
		<view id="page-top-view">
			<view style="padding-bottom: 20rpx;background: #f6f6f6;">

				<view class="flex_between public-views" style="background-color: white;">
					<view class="shop_info_view shop_info_view_2" :data-index="selfOutActiveIndex">
						<block v-if="!isLoading&&!diningTable.id">
							<view v-if="!shopInfo.shop.name" @tap="selfTap" :data-index="selfOutActiveIndex"
								class="flex_start">
								<view>请选择门店</view>
								<van-icon name="arrow" />
							</view>
							<view v-if="shopInfo.shop.name" @tap="selfTap" :data-index="selfOutActiveIndex">
								<view class="flex_between">
									<view class="out_of_range one_row">{{shopInfo.shop.name}}</view>
									<van-icon name="arrow" />
								</view>
								<view class="distance_m" v-if="initShopInfo.shopAdditionalVo.deliveryDistanceText">
									距您{{initShopInfo.shopAdditionalVo.deliveryDistanceText}}</view>
							</view>
						</block>
						<block v-if="shopInfo.shop.id&&!isLoading&&diningTable.id">
							<view :data-index="selfOutActiveIndex">
								<view class="flex_between">
									<view class="out_of_range one_row">{{shopInfo.shop.name}}</view>
									<van-icon name="arrow" v-if="!diningTable.id" />
								</view>
							</view>
						</block>
						<block v-if="shopInfo&&isLoading">
							<van-loading custom-class="loading_box_class">加载中...</van-loading>
						</block>
					</view>
					<view class="flex_center self_out_button theme-color" v-if="!isLoading" @tap="openSupport">
						⇋{{selfOutItems[selfOutActiveIndex].name}}
					</view>
				</view>
			</view>
		</view>
		<view id="d_p_s" v-if="shopInfo.id" class="self-adaption position-sticky"
			style="position: sticky;top: -1;z-index: 100;">
			<view class="display_flex_between">
				<view class="swiper-tabs-choice" style="width: 60%;">
					<view class="swiper-tabs-choice-item" v-for="(item,index) in businessModes" :data-current="index"
						@tap="clickTab" hover-class='hover-click-class'>
						<view :class="currentTab==item.modeId?'swiper_table_item_view active':'swiper_table_item_view'"
							:data-current="index" @tap="clickTab">
							{{item.modeName}}
						</view>
					</view>
				</view>
				<view id="table_name" v-if="diningTable.tableName">
					<text>🔔</text>
					<text style="margin-left: 20rpx;">{{diningTable.tableName}}</text>
				</view>
			</view>
		</view>
		<view v-if="menuList.length > 0" id="menu_list" :class="ifScroll ? 'flex_between' : 'flex_between menu_list'">
			<scroll-view :scroll-y="true" :enable-flex="true"
				:style="'height:'+(winHeight-(carHeight?(carHeight):70)-5)+'px;padding-bottom:'+(carHeight?(carHeight):30)+'px;'"
				:scroll-into-view="'left'+activeLeftTab" :scroll-with-animation="true" class="menu_left_scorll">
				<block v-for="(menu, menuIndex) in menuList">
					<view :id="'left'+menuIndex" v-if="menu.goodsList.length>0" @tap="leftTap" :data-index="menuIndex"
						:class="(menuIndex==activeLeftTab)?'menu_left_content theme-bg left_active ':'menu_left_content'">
						<view class="menu_left_name">
							<view class="out_of_range one_row menu_left_name_text ">{{ menu.name }}</view>
						</view>
					</view>
				</block>
			</scroll-view>
			<scroll-view :scroll-y="true" :enable-flex="true"
				:style="'height:'+(winHeight-(carHeight?(carHeight):70)-5)+'px;margin-left:1rpx;background: #f6f6f6;padding-bottom:'+(carHeight?(carHeight):30)+'px;'"
				@scroll="mainScroll" @touchstart="mainTouch" :scroll-into-view="'into'+activeTab"
				:scroll-with-animation="true" id="scroll_right" class="menu_right_scorll">
				<view class="menu_right_scorll_view">
					<view v-for="(menu, menuIndex) in menuList" :id="'into'+menuIndex"
						:class="'vtabs-content-item ' + (menuList.length - 1 == menuIndex ? '' : '')">
						<view class="commodity-type position-sticky" v-if="menu.goodsList.length>0">
							<view class="categoryName-view">{{ menu.name }}</view>
						</view>

						<block v-for="(chil, goodsIndex) in menu.goodsList" :key="goodsIndex">
							<view :class="'commodity-item ' + (chil.goodsStatus == 4 ? 'isEnd' : '')"
								:hover-class="chil.goodsStatus == 4 ? '' : 'hover-class-public'">
								<view class="flex_between commodity-name-view"
									@tap="parseEventDynamicCode($event, chil.goodsStatus == 4 ? '' : 'commodityDetailTap')"
									:data-id="chil.goodsId">
									<image
										:src="chil.mainImage ? chil.mainImage_ : '/static/assets/images/load-image.png'"
										mode="aspectFill" class="commodity-image"></image>
									<view class="sell-out" v-if="chil.goodsStatus == 4">售罄</view>
									<view class="commodity-name-english-view">
										<view class="commodity-name">{{ chil.goodsName }}</view>
										<view class="commodity-english"><text></text></view>
										<view class="flex_between money-view">
											<view>￥{{ chil.goodsPrice }}</view>
											<view class="money-insert-view"
												v-if="!shopInfo.isOutofDeliveryRange && shopInfo.isOperatingOfShop && shopInfo.shop.isOperating">
												<block v-if="chil.number > 0">
													<view class="stepper">
														<view class="flex_center insert-view reduce-class"
															@click.stop="bindMinus" :data-cartId="chil.cartId"
															:data-number="chil.number">
															－
														</view>
														<input disabled type="number" :value="chil.number"
															class="radd-reduce-input" />
														<view
															@click.stop="parseEventDynamicCode($event, chil.goodsStatus != 4 ? 'openSpecifications' : '')"
															class="flex_center insert-view add-class"
															:data-goodsId="chil.goodsId">
															＋
														</view>
													</view>
												</block>
												<block v-else>
													<view
														:class="'insert-view theme-bg ' + (chil.goodsStatus == 4 ? 'isEnd' : '')"
														:data-goodsId="chil.goodsId"
														@click.stop="parseEventDynamicCode($event, chil.goodsStatus != 4 ? 'openSpecifications' : '')">
														＋
													</view>
												</block>
											</view>
										</view>
									</view>
								</view>

							</view>
						</block>
						<view v-if="(menuList.length - 1) == menuIndex" class="more_box">没有更多啦~</view>
					</view>
				</view>
			</scroll-view>
			<view id="menu_scorll_mask" :class="ifScroll ? '' : 'menu_scorll_mask'"></view>

		</view>
		<view class="flex_column shopping-cart-detail" id="shopping-cart-detail">
			<view class="content-fullReductionRuleName">
				{{
		            !shopInfo.isOutofDeliveryRange
		                ? shopInfo.isOperatingOfShop && shopInfo.shop.isOperating
		                    ? fullPriceReductionIsHidden
		                        ? fullReductionRuleName
		                        : '暂无优惠'
		                    : ''
		                : '超出配送范围'
		        }}
			</view>
			<view
				:class="'shopping-cart-content ' + (shopInfo.isOutofDeliveryRange || !shopInfo.isOperatingOfShop || !shopInfo.shop.isOperating ? 'isEnd' : '')">
				<view class="shopping-cart-left" @tap="
		                parseEventDynamicCode($event, !shopInfo.isOutofDeliveryRange && shopInfo.isOperatingOfShop && shopInfo.shop.isOperating ? 'openShoppingCart' : '')
		            ">
					<view>
						<van-icon name="cart"
							:class="'iconfont icongouwuche1 highlight ' + (shoppingCartList.length <= 0 ? 'theme-other-bg' : 'theme-bg')" />
						<view>
							<view class="num" v-if="totalNum > 0">{{ totalNum }}</view>
						</view>
					</view>
					<view>
						<view class="shopping-cart-totalPrice">
							<view :class="fullPriceReductionIsHidden ? 'fullPriceReductionClass' : 'totalPrice'"
								v-if="shoppingCartList.length > 0">
								￥{{ totalPrice }}
							</view>
							<view class="full-price-reduction"
								v-if="fullPriceReductionIsHidden && shoppingCartList.length > 0">
								￥{{ fullPriceReduction }}</view>
							<view class="not-full-price-reduction" v-if="shoppingCartList.length <= 0">暂未选购商品</view>
						</view>
					</view>
				</view>
				<view :class="(isStartDeliveryPrice ? 'theme-bg' : 'shopping-cart-bg') + ' shopping-cart-right'" @tap="
		                parseEventDynamicCode(
		                    $event,
		                    shoppingCartList.length <= 0 ||
		                        !isStartDeliveryPrice ||
		                        shopInfo.isOutofDeliveryRange ||
		                        !shopInfo.isOperatingOfShop ||
		                        !shopInfo.shop.isOperating
		                        ? ''
		                        : 'goToPay'
		                )
		            " v-if="selfOutActiveIndex==2">
					{{ isStartDeliveryPrice ? '去结算' : '差 ￥' + priceDifference + ' 起送' }}
				</view>
				<view v-else class="shopping-cart-right theme-bg">
					<view v-if="selfOutActiveIndex==0&&!diningTable.id" @tap="scanTableCode">扫餐桌码就餐</view>
					<view v-else @tap="parseEventDynamicCode(
		                    $event,
		                    shoppingCartList.length <= 0 
		                        ? ''
		                        : 'goToPay'
		                )">{{shoppingCartList.length <= 0?'未选择商品':'去结算'}}</view>
				</view>
			</view>
		</view>

		<view class="loading_box" v-if="isLoading&&menuList.length==0">
			<van-loading custom-class="loading_box_class" vertical>加载中...</van-loading>
		</view>

		<van-empty v-if="menuList.length <= 0&&!isLoading" description="暂无商品"></van-empty>
		<view class="shopping-cart-detail">
			<van-action-sheet v-model:show="shoppingCartDialog" :show="shoppingCartDialog" title="已选商品"
				@close="closeShoppingCart" @cancel="closeShoppingCart" z-index='2'>
				<view class="content">
					<scroll-view style="height: 55vh" scroll-y>
						<view class="shoppingCart-item" v-for="(item, index) in shoppingCartList" :key="index">
							<view class="goodsName-restructure-view">
								<view class="goodsName out_of_range one_row">{{ item.goodsName }}</view>
								<view class="restructure out_of_range one_row">{{ item.restructure }}</view>
							</view>

							<view class="goodsPrice-number-view">
								<view class="goodsPrice">￥{{ item.price }}</view>
								<view class="stepper">
									<view class="flex_center car_reduce_add reduce-class" @tap="bindMinus"
										:data-cartid="item.id" :data-number="item.number">－</view>
									<input disabled type="number" :value="item.number" class="add-reduce-input" />
									<view @tap="bindPlus" class="flex_center car_reduce_add add-class"
										:data-num="index + ',' + item.number">＋</view>
								</view>
							</view>
						</view>
						<view class="goodsName-packingCharges">
							<text class="goodsName">包装费</text>
							<text class="goodsPrice">￥{{ packingCharges }}</text>
							<text></text>
						</view>
					</scroll-view>
				</view>
			</van-action-sheet>
			<van-action-sheet :show="specificationsDialog" @close="closeSpecifications" @cancel="closeSpecifications"
				title="选择规格">
				<view class="content">
					<view class="goods-info-view">
						<image :src="goodsInfo.mainImage" mode="aspectFill" class="commodity-image"></image>
						<view>
							<view class="goods-info-name">{{ goodsInfo.name }}</view>
							<view class="goods-info-specListString">已选：{{ specListString }}</view>
							<view class="goods-info-price">￥{{ priceAfter }}</view>
						</view>
					</view>
					<scroll-view scroll-y style="height: 50vh">
						<view class="commdity-name-type-view">
							<view class="commdity-name">{{ data.name }}</view>
							<view class="commdity-engname">{{ data.name }}</view>
							<view class="commdity-type-item" v-for="(item, key) in specList" :key="key">
								<view class="commdity-type-name">{{ key }}</view>
								<radio-group class="radio-group" @change="radioChange" :data-firstIndex="key">
									<label :class="
                                                    'group-label theme-border ' +
                                                    (!item.stock ? 'disabled-group-label' : '') +
                                                    ' ' +
                                                    (item.checked ? 'active theme-bg' : 'theme-color-border') +
                                                    ' out_of_range one_row'
                                                " v-for="(item, index) in item" :key="index">
										<radio :value="index" :checked="item.checked" :disabled="!item.stock"
											class="radio" />

										{{ item.name }}
									</label>
								</radio-group>
							</view>
							<view class="loading_box" v-if="specLoading&&specList.length==0">
								<van-loading custom-class="loading_box_class" vertical>加载中...</van-loading>
							</view>
							<van-empty v-if="!specLoading&&specList.length <= 0" description="暂无规格"></van-empty>
						</view>
					</scroll-view>
					<view slot="footer" class="position-sticky-bottom">
						<view class="good-choice-btn theme-bg" @tap="insertShoppingCart">我选好了</view>
					</view>
				</view>
			</van-action-sheet>
			<!-- 普通弹窗 -->
			<!-- <van-action-sheet :show="specificationsDialog" title="标题" @close="">
				<view class="content">内容</view>
			</van-action-sheet> -->
		</view>
	</view>
	<van-action-sheet :show="isActivityDialog" @close="close" @cancel="close" title="优惠活动">
		<view slot="desc">
			<scroll-view style="height: 55vh" scroll-y>
				<view v-if="shopInfo.promotionList.length > 0">
					<text class="dialog-title">优惠：</text>
					<view class="business-discount-info business-info-flex">
						<view class="business-discount out_of_range one_row" @tap="isPromotionTap">
							<view class="theme-color-border business-discount-list" v-if="index <= 5"
								v-for="(rule, index) in shopInfo.promotionList" :key="index">
								{{ rule.name }}
							</view>
						</view>
					</view>
				</view>
				<view class="reduced-delivery-price" v-if="shopInfo.shop.reducedDeliveryPrice">
					<text class="dialog-title">配送费：</text>
					配送费立减{{ shopInfo.shop.reducedDeliveryPrice }}元
				</view>
				<view class="reduced-delivery-price" v-if="shopInfo.shop.announcement">
					{{ shopInfo.shop.announcement }}
				</view>
			</scroll-view>
		</view>
	</van-action-sheet>
	<van-action-sheet :show="isOutofDeliveryRangeDialog" @cancel="close" title="本店超出配送范围">

		<view slot="desc">
			<view class="edit-address-class">建议您更换地址再下单</view>
		</view>
		<view slot="footer">
			<button size="mini" class="edit-address-btn theme-bg" @tap="editAddress"
				style="font-size: 24rpx">更换地址</button>
		</view>
	</van-action-sheet>
	<van-action-sheet :show="showSelfOutItems" :actions="selfOutItems" @select="chooseSupport" cancel-text="取消"
		:title="title" @cancel="closeDialog" @close="closeDialog" z-index="999"></van-action-sheet>
</template>

<script>
	import GlobalConfig from '../../../utils/global-config';
	import https from '../../../utils/http';
	import authService from '../../../utils/auth';
	import toastService from '../../../utils/toast.service';
	import utilHelper from '../../../utils/util';
	import dateHelper from '../../../utils/date-helper';

	let app = null;
	//声明全局变量
	var proListToTop = [];
	var isInitShow = true;
	var totalPrice = 0;
	var totalNum = 0;
	export default {
		data() {
			return {
				initShopInfo: {
					shopAdditionalVo: {

					}
				},
				titleActiveColor: '#004ca0',
				staticImg: '',
				currentActiveIndex: 0,
				menuList: [],
				imageTip: '../../assets/common/icon-internet-error.png',
				indicatorDots: true,
				autoplay: true,
				interval: 5000,
				duration: 1000,
				afterColor: 'white',
				businessModes: [{
						modeName: '商城',
						modeId: 0
					},
					{
						modeName: '商家',
						modeId: 1
					}
				],
				currentTab: 0,
				data: {
					dialog1: false,
					dialog2: false,
					name: ''
				},
				deliveryPrice: 0,
				shoppingCartDialog: false,
				specificationsDialog: false,
				activeTab: 0,
				activeLeftTab: 0,
				rate: 5,
				disabled: true,
				priceDifference: 0,
				isStartDeliveryPrice: false,
				appraiseFocus: false,
				buttons: [],
				appraiseFocus: false,
				showConfirmBar: false,
				shoppingCartList: [],
				isShopDetail: false,
				isActivityDialog: false,
				isOutofDeliveryRangeDialog: false,
				netWorkType: false,
				dialogShow: false,
				maskClosable: false,
				proListToTop: [],
				ifScroll: false,
				shopId: '',
				screenHeight: '',
				leftHeight: '',
				bussinessHeight: '',
				carouselUrls: '',
				toView: '',
				shopInfo: {
					shop: {
						firstPoster: '',
						shopLogoImg: '',
						name: '',
						serviceRating: '',
						reducedDeliveryPrice: '',
						announcement: '',
						isOperating: '',
						shopWithinImgs: [],
						briefIntroduction: false,
						managePrimary: '',
						province: '',
						city: '',
						area: '',
						street: '',
						startTime: '',
						endTime: '',
						id: ''
					},
					promotionList: [],
					isOutofDeliveryRange: '',
					isOperatingOfShop: ''
				},
				fullPriceReduction: '',
				fullReductionRuleName: '',
				fullPriceReductionIsHidden: '',
				appraiseList: '',
				totalNum: '',
				packingCharges: '',
				totalPrice: '',
				appraise: '',
				appraiseId: '',
				userName: '',
				replyId: '',
				replyType: '',
				appraiseIndex: '',
				appraiseJson: '',
				content: '',
				appraiseHeight: '',
				goodsId: '',
				goodsInfo: {
					mainImage: '',
					name: ''
				},
				priceAfter: '',
				specListString: '',
				specList: [],
				specLoading: false,
				pageTopView: '',
				dps: '',
				shoppingCartDetail: '',
				contentHeight: '',
				rule: {
					name: ''
				},
				goodsItem: {
					goodsStatus: 0,
					goodsId: '',
					mainImage: '',
					goodsName: '',
					latelyMonthlySales: '',
					goodsPrice: '',
					number: 0,
					cartId: ''
				},
				menuIndex: 0,
				menu: {
					name: '',
					goodsList: []
				},
				goodsIndex: 0,
				chil: {
					goodsStatus: 0,
					goodsId: '',
					mainImage: false,
					goodsName: '',
					goodsPrice: '',
					number: 0,
					cartId: ''
				},
				noDataTip: '',
				img: '',
				evt: '',
				showSelfOutItems: false,
				selfOutItems: [{
					name: "堂食",
					tap: "dineTap",
					value: 0,
					show: true,
					loading: false
				}, {
					name: "自提",
					tap: "slefTap",
					value: 1,
					show: true,
					loading: false
				}, {
					name: "外送",
					tap: "outTap",
					value: 2,
					show: true,
					loading: false
				}],
				selfOutActiveIndex: 0,
				winHeight: 0,
				topHeight: 0,
				topArr: [],
				isMainScroll: false,
				scrollInto: '',
				topLeftNumer: 0,
				topRightNumer: 0,
				deliveryAndSelfTaking: {
					deliveryAddress: {

					}
				},
				isLoading: true,
				ifChooseBack: false,
				memberInfo: {

				},
				selectCurrent: {},
				tableId: '',
				diningTable: {},
				isScanTableCode: false
			};
		},
		/**
		 * 生命周期函数--监听页面加载
		 */
		onLoad: function(options) {
			console.log("onLoad=", options);
			app = getApp();
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
			//toastService.showToast(app.globalData.deliveryAndSelfTaking.location)
			var _this = this;
			console.log("====================================000======");
			var options = uni.getLaunchOptionsSync().query;
			console.log("====================================000======", options);

			if (!this.isScanTableCode) {
				this.queryOptions = options;
				this.shopId = options.shopId;
				this.staticImg = app.globalData.staticImg;
				this.activeLeftTab = 0;
				this.activeTab = 0;
				this.topArr = [];
				this.isMainScroll = true; //是否主菜单滑动
				this.scrollInto = 'into0';
				this.isLoading = true;
				this.menuList = [];
				if (options.tableId) {
					this.findById(options.tableId);
				}
				if (options.shopId) {
					this.getShoppingCartList(options.shopId);
					this.$nextTick(() => {
						setTimeout(() => {
							this.getShopInfo(options.shopId, tableId);
						}, 500);
					})
				}

				this.$nextTick(() => {
					_this.selfAdaption();
					setTimeout(() => {
						_this.topViewHeight();
						_this.getElementTop();
					}, 1000);
					setTimeout(() => {
						_this.ifScroll = true;
						_this.isLoading = false;
					}, 2000);
				});
			}

		},
		/**
		 * 生命周期函数--监听页面隐藏
		 */
		onHide: function() {
			this.setData({
				dialogShow: false,
				maskClosable: true,
				proListToTop: []
			});
		},
		/**
		 * 生命周期函数--监听页面卸载
		 */
		onUnload: function() {},
		/**
		 * 页面相关事件处理函数--监听用户下拉动作
		 */
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getMenuList();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		/**
		 * 页面上拉触底事件的处理函数
		 */
		onReachBottom: function() {},
		/**
		 * 用户点击右上角分享
		 */
		onShareAppMessage: function() {},

		onPageScroll(e) {

		},
		methods: {
			getUserInfo: function(e) {
				https.request('/rest/member/getLoginMemberInfo', {}).then((result) => {
					if (result.success) {
						this.setData({
							memberInfo: result.data
						})
					}
				});
			},
			findById: function(tableId) {
				https.request_get('/rest/member/diningTable/findById', {
					id: tableId
				}).then((result) => {
					if (result.success) {
						if (result.data.shopId) {
							this.shopId = result.data.shopId;
							this.tableId = tableId;
							this.diningTable = result.data;
							this.$nextTick(() => {
								setTimeout(() => {
									this.shopDetail(result.data.shopId, tableId);
									this.getLocalCartList(tableId).then((isCart) => {
										if (isCart) {
											authService.deleteWxStorage("local_cart");
											//this.getShoppingCartList(result.data.shopId,tableId);
										}
									});
								}, 500);
							});
						}
					}
				});
			},
			selfAdaption() {
				var _this = this;
				let winHeight = 0;
				let height = 0;
				uni.getSystemInfo({
					success: function(res) {
						console.log(res)
						//获取到用户的手机信息
						winHeight = res.windowHeight;
						// 获取需要减去的dom结构的高度信息
						setTimeout(function timeout() {
							uni.createSelectorQuery()
								.in(_this)
								.selectAll('#page-top-view')
								.boundingClientRect(function(rects) {
									console.log("#page-top-view", rects)
									rects.forEach(function(rect, index) {
										height = height + rect.height;
									});
									if (rects.length > 0) {
										_this.winHeight = winHeight - height;
										_this.topHeight = height;
									}
								}).exec();
						}, 1000);

						setTimeout(function timeout() {
							uni.createSelectorQuery()
								.in(_this)
								.selectAll('#shopping-cart-detail')
								.boundingClientRect(function(rects) {
									console.log("#shopping-cart-detail", rects)
									rects.forEach(function(rect, index) {
										height = height + rect.height;
									});
									if (rects.length > 0) {
										_this.carHeight = rects[0].height - 20;
										_this.ifScroll = true;
									}

								}).exec();
						}, 1000);
					}
				});
			},
			closeShoppingCart: function() {
				this.setData({
					shoppingCartDialog: false
				});
			},

			close: function() {
				this.setData({
					shoppingCartDialog: false
				});
			},

			openShoppingCart() {
				var _this = this;
				authService.checkIsLogin().then((result) => {
					if (result) {
						if (this.shoppingCartList.length > 0) {
							this.setData({
								shoppingCartDialog: this.shoppingCartDialog ? false : true
							});
						}
						return;
					}
					_this.checkIsAuth();
				});
			},
			checkIsAuth() {
				app.globalData.checkIsAuth('scope.userInfo');
			},
			// 滑动切换tab
			bindSlideChange: function(e) {
				var that = this;
				that.setData({
					currentTab: e.detail.current
				});
			},

			//点击切换
			clickTab: function(e) {
				var that = this;
				this.setData({
					shoppingCartDialog: false,
					specificationsDialog: false
				});
				if (that.currentTab === e.target.dataset.current) {
					return false;
				} else {
					that.setData({
						currentTab: e.target.dataset.current
					});
				}
			},

			autoHeight() {
				var that = this;
				isInitShow = false;
				const query = uni.createSelectorQuery();
				let windowHeight = app.globalData.systemInfoSync.windowHeight;
				console.log(windowHeight);
				query.selectAll('.swiper-tabs-choice,.content-manjian')
					.boundingClientRect(function(rect) {
						console.log(rect);
						let height = windowHeight > 630 ? rect[0].height - 10 : rect[0].height + 25;
						that.setData({
							winHeight: windowHeight - height,
							leftHeight: windowHeight - height,
							bussinessHeight: windowHeight - height
						});
					}).exec();
			},

			commodityDetailTap(e) {
				console.log(e.currentTarget.dataset.id);
				//app.globalData.deliveryAndSelfTaking.ifChooseBack = false;
				uni.navigateTo({
					url: '/subPackages_pages/table/detail/detail?id=' + e.currentTarget.dataset.id + '&shopId=' +
						this.shopInfo.shop.id +
						"&initShopInfo=" + JSON.stringify(this.initShopInfo)
				});
			},

			scroll(e) {
				//console.log(e)
				//获取当前滑动距离顶部的距离高度
				let scrollTop = e.detail.scrollTop;
				//console.log(scrollTop)
				//获取右侧菜单的高度
				let scrollArr = proListToTop;
				//当距离顶部的高度大于等于右侧菜单的item高度
				let index = 0;
				if (scrollTop >= scrollArr[scrollArr.length - 1]) {
					return;
				} else {
					for (let i = 0; i < scrollArr.length; i++) {
						if (scrollTop >= 0 && scrollTop < scrollArr[0]) {
							index = 0;
						} else if (scrollTop >= scrollArr[i - 1] && scrollTop < scrollArr[i]) {
							index = i;
						} else if (scrollTop <= 0) {}
					}
				}
				this.setData({
					currentActiveIndex: index
				});
			},

			selectMenuTap(e) {
				var index = e.currentTarget.dataset.index;
				console.log(index);
				this.setData({
					toView: 'NAV' + index.toString(),
					currentActiveIndex: index
				});
			},
			getAllRects() {
				// 获取商品数组的位置信息
				let menuHeight = 0;
				uni.createSelectorQuery().in(uni)
					.selectAll('.commodity-item-view')
					.boundingClientRect(function(rects) {
						rects.forEach(function(rect) {
							menuHeight += rect.height;
							proListToTop.push(menuHeight);
						});
						//toastService.hideLoading();
					}).exec();
			},
			shopDetail(shopId, tableId) {
				var shopInfo = {
					id: shopId,
					tableId: tableId
				}
				app.globalData.getShopInfo(shopId).then((result) => {
					if (result) {
						this.shopInfo = result;
						this.getMenuList(shopId);
						if (tableId) {
							this.getShoppingCartList(shopId, tableId);
						}
					}
				});
			},
			getShopInfo(shopInfo) {
				var shopId = shopInfo.id;
				app.globalData.getShopInfo(shopId).then((result) => {
					if (result) {
						this.shopInfo = result;
						this.getMenuList(shopId);
					}
				});
			},
			getMenuList(shopId) {
				var _this = this;
				https.request('/rest/menu/listWithGoods', {
					shopId: shopId
				}).then((result) => {
					if (result.success && result.data) {
						var goodsList = [];
						result.data.forEach((aitem, index) => {
							if (aitem.goodsList.length > 0) {
								aitem.goodsList.forEach((bitem) => {
									bitem.isShopCart = false;
									bitem.mainImage_ = GlobalConfig.ossUrl + bitem.mainImage;
								});
								goodsList.push(aitem);
							}

						});
						console.log(goodsList)
						this.menuList = goodsList;
						setTimeout(() => {
							_this.isLoading = false;
						}, 0);
					}
				});
			},
			getLocalCartList(tableId) {
				var _this = this;
				return new Promise((fulfill, reject) => {
					authService.getWxStorage("local_cart").then((result) => {
						if (result) {
							result.forEach((item, index) => {
								item.tableId = tableId;
								_this.shoppingCartInsert(item,tableId);
							});
							fulfill(true);
						}
					});
				});
			},
			getShoppingCartList(shopId, tableId) {
				var _this = this;
				this.shoppingCartList=[];
				https.request('/rest/member/shoppingCart/list', {
					shopId: shopId,
					pageNo: -1,
					pageSize: 20,
					tableId: tableId
				}).then((result) => {
					if (result.success && result.data) {
						var packingCharges = 0;
						var totalNum = 0;
						var totalPrice = 0;
						this.menuList.forEach((menu, menuIndex) => {
							menu.goodsList.forEach((goods, goodsIndex) => {
								let number = 0;
								this.menuList[menuIndex].goodsList[goodsIndex].number = number;
								result.data.records.forEach((result, carIndex) => {
									if (goods.goodsId == result.goodsId) {
										number = number + result.number;
										this.menuList[menuIndex].goodsList[goodsIndex]
											.isShopCart = true;
										result.menuIndex = menuIndex;
										result.goodsIndex = goodsIndex;
										this.menuList[menuIndex].goodsList[goodsIndex]
											.number =
											number;
										this.menuList[menuIndex].goodsList[goodsIndex]
											.cartId =
											result.id;
									}
								});
							});
						});
						result.data.records.forEach((result, index) => {
							let specList = '';
							for (var key in JSON.parse(result.specList)) {
								specList = (specList ? specList + '/' : specList) + JSON.parse(result
									.specList)[key];
							}
							result.restructure = specList;
							totalNum = totalNum + result.number;
							result.goodsPrices = utilHelper.toFixed(Number(result.goodsPrice) * result
								.number, 2);
							totalPrice += result.price * result.number; //初始化被选中的商品的总金额
							result.disable = result.goodsStatus == 1 || result.goodsStatus == 3 || result
								.goodsStatus == 4 ? true : false;
							packingCharges =
								result.goodsStatus == 1 || result.goodsStatus == 3 || result.goodsStatus ==
								4 ?
								packingCharges :
								packingCharges + result.packingCharges * result.number;
							//console.log(result)
						});

						totalPrice = utilHelper.toFixed(totalPrice, 2);
						var isStartDeliveryPrice = false;
						var priceDifference = 0;
						this.shopInfo.shop.startDeliveryPrice = this.shopInfo.shop.startDeliveryPrice ? this
							.shopInfo.shop.startDeliveryPrice : 0;
						if (totalPrice + packingCharges >= this.shopInfo.shop.startDeliveryPrice) {
							isStartDeliveryPrice = true;
						}
						priceDifference = this.shopInfo.shop.startDeliveryPrice - (totalPrice + packingCharges);
						this.menuList = this.menuList;
						this.totalNum = totalNum;
						this.priceDifference = utilHelper.toFixed(priceDifference, 2);
						this.isStartDeliveryPrice = isStartDeliveryPrice;
						this.shoppingCartList = result.data.records;
						this.packingCharges = packingCharges;
						this.totalPrice = utilHelper.toFixed(totalPrice + packingCharges, 2);
					}
				});
			},
			viewImage: function(event) {
				var imgs = event.currentTarget.dataset.imgs; //获取data-src
				var index = event.currentTarget.dataset.index; //获取data-currentimg
				var src = imgs[index];

				//图片预览
				uni.previewImage({
					current: src,
					// 当前显示图片的http链接
					urls: imgs // 需要预览的图片http链接列表
				});
			},
			openSpecifications(e) {
				this.specificationsDialog = true;
				this.specLoading = true;
				this.goodsId = e.currentTarget.dataset.goodsid;
				this.getCommodityDetails(e.currentTarget.dataset.goodsid);
			},

			closeSpecifications: function() {
				this.getShoppingCartList(this.shopInfo.shop.id);
				this.specificationsDialog = false;
				this.specList = [];
				this.specLoading = false;
			},

			getCommodityDetails(id) {
				https.request('/rest/goods/selectById', {
					id: id,
					position: app.globalData.deliveryAndSelfTaking.location
				}).then((result) => {
					if (result.success && result.data) {
						//获取商品的详细图片，转换以轮播图的数据格式
						//console.log(result.data)
						result.data.mainImage = GlobalConfig.ossUrl + result.data.mainImage;
						this.setData({
							goodsInfo: result.data,
							priceAfter: result.data.price
						});
						this.selectByGoodsId(id);
					}
				});
			},

			selectByGoodsId(goodsId) {
				console.log(this);
				https.request('/rest/goodsSpecificationOption/selectByGoodsId', {
					goodsId: goodsId
				}).then((result) => {
					if (result.success && result.data) {
						// if(!result.data){
						//   return;
						// }
						//重新设置商品的规格等数据的格式
						//let goodsSpecs = {};
						let specList = result.data;
						let price = this.data.price;
						let specListString = '';
						for (let key in specList) {
							let isChecked = true;
							for (let keyof in specList[key]) {
								//拼接查询规格等的json数据格式，查询商品规格等对应的价格
								specList[key][keyof].checked = false;
								//设置每个规格的第一个选项为选中，当库存为0时则选中下一个
								if (specList[key][keyof].stock == 1 && isChecked) {
									specList[key][keyof].checked = true;
									//选中的规格价钱在商品价钱的基础上累加
									price = price + specList[key][keyof].price;
									specListString = (specListString ? specListString + '/' : specListString) +
										specList[key][keyof].name;
									isChecked = false;
								}
							}
						}
						this.setData({
							specListString: specListString,
							specList: JSON.stringify(specList) == '{}' ? [] : specList,
							specLoading: false
						});
					}
				});
			},

			radioChange(e) {
				//获取复选框选中的下标值
				var checkValue = e.detail.value;
				//获取第一级分类的下标值
				let firstIndex = e.currentTarget.dataset.firstindex;
				//获取所有分类信息
				let specList = this.specList;
				//console.log(specList)
				//遍历分类信息给第一级分类为false，提交的时候对应各级分类
				for (var j in specList[firstIndex]) {
					specList[firstIndex][j].checked = false;
				}
				//给选中的第二级分类的checked设置为true
				specList[firstIndex][checkValue].checked = true;
				// for (var i in checkValue) {
				// 	specList[firstIndex][checkValue[i]].checked = true;
				// 	//console.log(specList[firstIndex][checkValue[i]])
				// }

				let price = this.goodsInfo.price;
				let specListString = '';
				for (let key in specList) {
					for (let keyof in specList[key]) {
						console.log(specList[key][keyof].price);
						if (specList[key][keyof].checked) {
							price = price + specList[key][keyof].price;
							specListString = (specListString ? specListString + '/' : specListString) + specList[key][
								keyof
							].name;
						}
					}
				}
				let totalPrice = price * this.commodityNum;
				let fullPriceReduction = 0;
				let fullReductionRuleName = '';
				let fullPriceReductionIsHidden = false;
				let limitedPrice = 0; //console.log(this.data.fullReductionRuleList)
				for (let i = 0; i < this.shopInfo.fullReductionRuleList.length; i++) {
					//console.log(this.data.fullReductionRuleList[i].limitedPrice)
					if (totalPrice >= this.shopInfo.fullReductionRuleList[i].limitedPrice) {
						if (this.shopInfo.fullReductionRuleList[i].limitedPrice > limitedPrice) {
							limitedPrice = this.shopInfo.fullReductionRuleList[i].limitedPrice;
							fullPriceReduction = totalPrice + this.data.packingCharges - this.shopInfo
								.fullReductionRuleList[i].reducedPrice;
							fullReductionRuleName = this.shopInfo.fullReductionRuleList[i].name;
							fullPriceReductionIsHidden = true;
						}
					}
				}
				console.log(specList)
				this.setData({
					specList: specList,
					specListString: specListString,
					priceAfter: price
				});
			},
			insertShoppingCart(e) {
				var _this = this;
				authService.checkIsLogin().then((result) => {
					toastService.showLoading();
					if (result) {
						let goodsSpecs = {};
						let specList = _this.specList;
						for (let key in specList) {
							for (let keyof in specList[key]) {
								//拼接查询规格等的json数据格式，查询商品规格等对应的价格
								if (specList[key][keyof].checked) {
									goodsSpecs[key] = specList[key][keyof].name;
								}
							}
						}
						toastService.hideLoading();
						var data = {
							goodsId: _this.goodsId,
							specList: JSON.stringify(goodsSpecs),
							shopId: _this.shopInfo.shop.id,
							tableId: _this.tableId
						}
						if (_this.selfOutActiveIndex == 0 && !_this.tableId) {
							console.log(authService.getWxStorage("local_cart"))
							authService.getWxStorage("local_cart").then((result) => {
								console.log("local_cart==", result)
								var localCartList = result ? result : [];
								localCartList.push(data);
								authService.setWxStorage("local_cart", localCartList);
								_this.specificationsDialog = false;
								_this.specList = [];
								_this.specLoading = true;
							});
						} else {
							_this.shoppingCartInsert(data,null);
						}
						return;
					}
					_this.specificationsDialog = false;
					toastService.hideLoading();
					app.globalData.checkIsAuth('scope.userInfo');
				});
			},
			shoppingCartInsert(data,tableId) {
				var _this = this;
				https.request('/rest/member/shoppingCart/insert', data).then((result) => {
					console.log(result)
					if (result.success) {
						_this.specificationsDialog = false;
						_this.specList = [];
						_this.specLoading = true;
						_this.getShoppingCartList(_this.shopInfo.shop.id,tableId);
					}
				});
			},
			//事件处理函数
			/*点击减号*/
			bindMinus: function(e) {
				toastService.showLoading();
				var _this = this;
				let cartId = e.currentTarget.dataset.cartid;
				let number = e.currentTarget.dataset.number;
				//点击减号后,当前商品的数量小于1,就进行删除该商品
				//重新计算被选中的商品的总金额
				totalPrice = 0;
				if (number == 1) {
					toastService.hideLoading();
					toastService.showModal(null, '确定不要这个了吗？', function confirm() {
						toastService.showLoading();
						_this.updateNumber(cartId, 1, 0, function callback() {
							totalNum--;
							if (_this.shoppingCartList.length == 1) {
								_this.setData({
									shoppingCartDialog: false
								});
							}
							toastService.hideLoading();
							_this.getShoppingCartList(_this.shopInfo.shop.id);
						});
					});
					return;
				}
				this.updateNumber(cartId, 1, 0, function callback() {
					totalNum--;
					_this.getShoppingCartList(_this.shopInfo.shop.id);
				});
			},

			/*点击加号*/
			bindPlus: function(e) {
				toastService.showLoading();
				var _this = this;
				let numList = e.currentTarget.dataset.num.split(',');
				let items = this.shoppingCartList;
				totalPrice = 0;
				items[numList[0]].number = Number(numList[1]) + 1; //当前商品的数量+1
				if (items[numList[0]].disable) {
					return;
				}
				this.updateNumber(items[numList[0]].id, 1, 1, function callback() {
					toastService.hideLoading();
					//重新计算被选中的商品的总金额
					totalNum++;
					_this.getShoppingCartList(_this.shopInfo.shop.id);
				});
			},
			updateNumber(id, number, type, callbak) {
				authService.checkIsLogin().then((result) => {
					console.log(result);
					if (!result) {
						app.globalData.checkIsAuth('scope.userInfo');
						return;
					}
					https.request('/rest/member/shoppingCart/updateNumber', {
						id: id,
						number: number,
						type: type
					}).then((result) => {
						if (result.success) {
							callbak();
						}
					});
				});
			},
			goToPay() {
				authService.checkIsLogin().then((result) => {
					if (!result) {
						app.globalData.checkIsAuth('scope.userInfo');
						return;
					}
					//判断店铺是否打烊
					let startTime = this.shopInfo.shop.startTime;
					let endTime = this.shopInfo.shop.endTime;
					let isOperating = this.shopInfo.shop.isOperating;
					app.globalData.getIsBusiness(startTime, endTime, isOperating).then((result) => {
						if (!result) {
							return;
						}
						this.toPay();
					});
				});
			},

			toPay() {
				var list = this.shoppingCartList;
				var orderDetail = {};
				orderDetail.actualPrice = this.totalPrice;
				orderDetail.fullPriceReduction = this.totalPrice;
				orderDetail.reducedPrice = 0;
				orderDetail.shopId = this.shopInfo.shop.id;
				orderDetail.initShopInfo = this.shopInfo;
				orderDetail.selfOutActiveIndex = this.selfOutActiveIndex;
				orderDetail.selfOutItems = this.selfOutItems;
				orderDetail.diningTable = this.diningTable;
				orderDetail.orderDetailList = [];
				orderDetail.packingCharges = 0;
				for (var key in list) {
					orderDetail.packingCharges = orderDetail.packingCharges + list[key].packingCharges
					orderDetail.orderDetailList.push({
						goodsId: list[key].goodsId,
						specList: list[key].specList,
						number: list[key].number,
						goodsName: list[key].goodsName,
						restructure: list[key].restructure,
						price: list[key].price,
						id: list[key].id,
						packingCharges: list[key].packingCharges,
						totalPrice: list[key].price * list[key].number
					});
				}
				setTimeout(() => {
					app.globalData.deliveryAndSelfTaking.selfOutActiveIndex = this.selfOutActiveIndex;
					app.globalData.deliveryAndSelfTaking.payType = 'car';
					app.globalData.deliveryAndSelfTaking.orderDetail = orderDetail;
					uni.navigateTo({
						url: '/subPackages_pages/table/pay/pay'
					});
				}, 100);
			},

			gotoShop(e) {
				app.globalData.isRemindNewPeople().then((result) => {
					if (result) {
						this.setData({
							dialogShow: false,
							maskClosable: true
						});
					}
				});
			},

			openConfirm() {
				this.setData({
					dialogShow: true,
					maskClosable: false
				});
			},

			close(e) {
				console.log(e);
				this.setData({
					specificationsDialog: false,
					shoppingCartDialog: false,
					isActivityDialog: false,
					isOutofDeliveryRangeDialog: false
				});
			},

			onTabCLick(e) {
				const index = e.currentTarget.dataset.index;
				console.log('tabClick', index);
				this.activeTab = index;
			},

			isShopDetailTap() {
				this.setData({
					isShopDetail: true
				});
			},
			topViewHeight() {

				var _this = this;
				isInitShow = false;
				const query = uni.createSelectorQuery();

				let windowHeight = app.globalData.systemInfoSync.windowHeight;
				let screenHeight = app.globalData.systemInfoSync.screenHeight;
				let statusBarHeight = app.globalData.systemInfoSync.statusBarHeight * 2;
				console.log(windowHeight);
				query.selectAll('#page-top-view')
					.boundingClientRect(function(rect) {
						console.log(rect);
						_this.setData({
							pageTopView: rect[0].height * 2,
							contentHeight: screenHeight - rect[0].height * 2
						});
					})
					.exec();
				console.log(app.globalData.systemInfoSync);
			},
			selfTap(e) {
				console.log(e);

				var index = e.currentTarget.dataset.index;
				var selfOutActiveIndex = this.selfOutActiveIndex;
				console.log("选择地址======", this.deliveryAndSelfTaking);
				var chooseId = this.deliveryAndSelfTaking.deliveryAddress ? this.deliveryAndSelfTaking.deliveryAddress.id :
					'';
				var chooseId = selfOutActiveIndex == 1 ? chooseId : 0;
				if (!this.memberInfo.id && chooseId == 1) {
					this.checkIsAuth();
					return
				}
				app.globalData.deliveryAndSelfTaking.chooseId = chooseId;
				app.globalData.deliveryAndSelfTaking.selfOutActiveIndex = selfOutActiveIndex;
				app.globalData.deliveryAndSelfTaking.pageType = 'choose';
				app.globalData.deliveryAndSelfTaking.chooseIndex = index;
				app.globalData.deliveryAndSelfTaking.ifChooseBack = false;
				app.globalData.deliveryAndSelfTaking.ifChoosePayBack = false;
				uni.navigateTo({
					url: `/subPackages_pages/address/choose/choose`
				})
			},
			//获取距离顶部的高度
			getScrollTop(selector) {
				var _this = this;
				return new Promise((resolve, reject) => {
					let query = uni.createSelectorQuery().in(_this);
					query.select(selector).boundingClientRect(data => {
						if (data && 'top' in data) {
							resolve(data.top);
						} else if (data && 'top' in data && _this.menuList.length > 0) {
							_this.getElementTop();
						}

					}).exec();
				})
			},
			/* 获取元素顶部信息 */
			async getElementTop() {
				var _this = this;
				/* Promise 对象数组 */
				let p_arr = [];

				/* 遍历数据，创建相应的 Promise 数组数据 */
				console.log("this.topHeight===", this.topHeight);
				for (let i = 0; i < this.menuList.length; i++) {
					const resu = await this.getScrollTop(`#into${i}`)
					p_arr.push(resu - this.topHeight)
				}
				console.log("p_arr====", p_arr)
				/* 主区域滚动容器的顶部距离 */
				this.getScrollTop("#scroll_right").then((res) => {
					console.log(res)
					let top = res;
					// #ifdef H5
					top += 43; //因固定提示块的需求，H5的默认标题栏是44px
					// #endif

					/* 所有节点信息返回后调用该方法 */
					Promise.all(p_arr).then((data) => {
						_this.topArr = data;
					});
				})
			},

			/* 主区域滚动监听 */
			mainScroll(e) {
				console.log(e)
				if (!this.isMainScroll) {
					return;
				}
				console.log(this.topArr);
				if (this.topArr.length > 0) {
					let top = e.detail.scrollTop;
					let index = -1;
					if (top >= this.topArr[this.topArr.length - 1]) {
						index = this.topArr.length - 1;
					} else {
						index = this.topArr.findIndex((item, index) => {
							return this.topArr[index + 1] >= top;
						});
					}
					this.activeLeftTab = (index < 0 ? 0 : index);
				} else {
					this.getElementTop();
				}

			},
			/* 主区域触摸 */
			mainTouch() {
				this.isMainScroll = true;
			},
			/* 左侧导航点击 */
			leftTap(e) {
				let index = e.currentTarget.dataset.index;
				this.isMainScroll = false;
				this.activeLeftTab = Number(index);
				this.activeTab = Number(index);
				this.scrollInto = `into${index}`;
			},
			//回到顶部
			goTop(e) { // 一键回到顶部
				var _this = this;
				this.$nextTick(() => {
					setTimeout(() => {
						_this.setData({
							topRightNumer: 0,
							topLeftNumer: 0,
							activeLeftTab: 0,
							activeTab: 0
						});
						setTimeout(() => {
							_this.getElementTop();

						}, 1000)
					}, 500);

				});
			},
			openSupport(e) {
				var selfOutActiveIndex = this.selfOutActiveIndex;
				var selfOutItems = this.selfOutItems;
				var shopInfo = this.shopInfo;
				selfOutItems[0].show = shopInfo.shop.isSupportDinein; //堂食
				selfOutItems[1].show = shopInfo.shop.isSupportPickup; //自提
				selfOutItems[2].show = shopInfo.shop.isSupportDelivery; //外送
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
			scanTableCode: function() {
				this.isScanTableCode = true;
				// 允许从相机和相册扫码
				uni.scanCode({
					success: function(res) {
						console.log('条码类型：' + res.scanType);
						console.log('条码内容：' + res.result);
					}
				});
			}
		}
	};
</script>
<style>
	.position-sticky {
		background: inherit;
	}

	.content-class {
		width: 100%;
		/* height: 100%;
		overflow: hidden; */
	}

	/* 地址定位 */
	.store-full-name-view {
		box-shadow: -2px 0.5px 5px 0.5px rgba(0, 0, 0, 0.1);
		padding: 15rpx 20rpx;
		margin: 15rpx 20rpx;
		border-radius: 10rpx;
		background: #fff;
	}

	.banner-view {
		margin: 10rpx 20rpx;
		border-radius: 10rpx;
	}

	.place-image {
		width: 10%;
		height: auto;
		padding-right: 20rpx;
	}

	.business-text {
		font-size: 24rpx;
		font-weight: bold;
	}

	.right-class {
		width: 90%;
	}

	.store-full-name-place-view {
		font-size: 26rpx;
		font-weight: bold;
	}

	.distance-phone-username-veiw {
		color: #6b6b6b;
		font-size: 24rpx;
		line-height: 42rpx;
	}

	.tips-view {
		font-size: 24rpx;
		display: flex;
		align-items: center;
	}

	.mbp-view {
		color: #a1a1a1;
	}

	.bar- {
		font-size: 28rpx;
		margin: 0 10rpx;
	}

	/* 单选框样式--自取配送 */
	.radio-group-view {
		display: flex;
		align-items: center;
		justify-content: center;
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
		margin-left: 2rpx;
		/* height: 66rpx; */
	}

	.radio-group-label-radio {
		display: none;
	}

	.radio-group-label {
		width: 46%;
		padding: 2%;
		font-size: 26rpx;
		border-radius: 50rpx;
		display: flex;
		justify-content: center;
		align-items: center;
		/* height: 60rpx; */
	}

	.not-active {
		color: white;
	}

	/* 轮播图样式 */
	swiper {
		width: 100%;
		height: 366rpx;
	}

	.slide-image {
		width: 100%;
		height: 366rpx;
		border-radius: 10rpx;
	}

	.business-view {
		/* position: absolute;
  top: 6%; */
		text-align: center;
		width: 100%;
		margin-top: -20%;
	}

	.business-image {
		width: 160rpx;
		height: 160rpx;
		border: 2rpx solid #f5f5f5;
	}

	.business-info {
		/* margin-top: 40rpx; */
		text-align: center;
		margin-left: 20px;
		margin-right: 20px;
	}

	.business-info-name {
		font-size: 36rpx;
		font-weight: bold;
	}

	.notice-view {
		font-size: 24rpx;
		color: #9b9b9b;
	}

	.business-info-other {
		font-size: 22rpx;
	}

	.swiper-tabs-choice {
		width: 100%;
		text-align: center;
		height: 88rpx;
		line-height: 88rpx;
		display: flex;
		flex-flow: row;
		justify-content: space-between;
		background: #fff;
		z-index: 1;
		border-bottom: 6rpx solid #f5f5f5;
	}

	.swiper-tabs-choice-item {
		width: 50%;
	}

	.swiper-items {
		height: 100%;
	}

	/* 菜单品类样式 */
	.swiper-tab {
		/* width: 24%; */
		text-align: center;
		flex-flow: row;
		justify-content: space-between;
		z-index: -1;
		font-size: 34rpx;
	}

	.swiper-tab-item {
		/* width: 100%; */
		/* color:#969696; */
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 10rpx 15rpx;
		font-size: 28rpx;
		height: 80rpx;
		font-weight: bold;
	}

	.swiper_table_item_view {
		display: flex;
		align-items: center;
		justify-content: center;
		/* border-bottom: 4rpx solid #fff; */
	}

	.swiper-box {
		display: block;
		width: 100%;
		height: 100%;
		overflow: hidden;
	}

	.swiper-active {
		background: white;
		transition: 0.5s;
	}

	.swiper-items {
		height: 100%;
	}

	.selectMenuTap {
		width: 40%;
	}

	.scroll-views {
		height: 100%;
		background: #f5f5f5;
		border-radius: 10rpx;
	}

	.full-reduction-view {
		display: flex;
		align-items: center;
		background: white;
		padding: 10rpx 0rpx;
		height: 34rpx;
	}

	.full-reduction-list {
		font-size: 24rpx;
		font-weight: bold;
		padding: 0 10rpx;
		margin: 0 5rpx;
		border-radius: 10rpx;
	}

	.full-reduction-text {
		color: white;
		margin-left: 20rpx;
		font-size: 28rpx;
		width: 10%;
		text-align: center;
		border-radius: 15rpx;
	}

	.business-discount-list {
		padding: 1rpx 6rpx;
		font-size: 20rpx;
		font-weight: bold;
		border-radius: 10rpx;
		margin-right: 5rpx;
	}

	.other-promotionList {
		width: 27%;
		display: flex;
		align-items: center;
	}

	.business-discount {
		width: 85%;
		padding-bottom: 1rpx;
		margin-bottom: 10rpx;
		display: flex;
		align-items: center;
	}

	.business-info-flex {
		display: flex;
		align-items: center;
		justify-content: space-between;
		font-size: 24rpx;
		color: #717171;
		margin: 10rpx 10rpx 10rpx 0;
	}

	.commodity-menu-view {
		box-shadow: -2px 0.5px 5px 0.5px rgba(0, 0, 0, 0.1);
		height: 100%;
		display: flex;
		justify-content: space-between;
		border-radius: 10rpx;
		padding-bottom: 73px;
	}

	.commodity-detail-view {
		width: 100%;
		/* background: white; */
		border-radius: 10rpx;
	}

	/* 商品信息 */
	.commodity-item-view {
		display: flex;
		flex-direction: column;
		background: white;
		border-radius: 10rpx;
		padding-top: 20rpx;

	}

	.commodity-type {
		padding: 10rpx 20rpx;
		background: white;
		z-index: 1;
		border-radius: 15rpx;
		box-shadow: 0 -1px #fff;
	}

	.categoryName-view {
		/* width: 35%; */
		font-size: 28rpx;
	}

	.font-white {
		color: white;
	}

	.commodity-item {
		display: flex;
		padding: 10rpx 20rpx 10rpx 20rpx;
		align-items: center;
		background-color: white;
		border-radius: 15rpx;
		position: relative;
	}

	.commodity-image {
		width: 170rpx;
		height: 166rpx;
		border-radius: 8rpx;
		margin-right: 10rpx;
	}

	.commodity-name-view {
		width: 100%;
	}

	.line-view {
		background: #b0b0b0;
		width: 100%;
		height: 2rpx;
	}

	.commodity-name {
		font-size: 28rpx;
		color: #969696;
		font-weight: bold;
	}

	.commodity-english {
		font-size: 24rpx;
		color: #b0b0b0;
	}

	.money-view {
		font-size: 30rpx;
		font-weight: bold;
		margin-top: 50rpx;
	}

	.insert-view {
		border-radius: 50%;
		width: 35rpx;
		height: 35rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		line-height: 35rpx;
	}

	.shangjiatuijianjia {
		margin-right: 35rpx;
	}

	.money-insert-view {
		/* position: absolute;
		margin-top: -10%;
		right: 20rpx;
		bottom: 30rpx; */
	}

	.commodity-name-english-view {
		width: 55%;
	}

	#space-view {
		height: 20rpx;
		background: white;
	}

	.now-order-image {
		width: 100%;
		height: 100%;
	}

	/* shopcart 样式 */
	.content-fullReductionRuleName {
		width: 100%;
		background: #fffadc;
		font-size: 24rpx;
		text-align: center;
		position: sticky;
		top: 0;
		z-index: 0;
		opacity: 0.7;
		visibility: visible;
	}

	.shopping-cart-detail {
		position: fixed;
		bottom: 0;
		z-index: 999;
		width: 100%;
		background: white;
	}

	.highlight {
		position: relative;
		top: -10px;
		width: 80rpx;
		line-height: 80rpx;
		text-align: center;
		height: 80rpx;
		margin-left: 20rpx;
		margin-right: 20rpx;
		border-radius: 50%;
		border: 10rpx solid #444444;
	}

	.shopping-cart-content {
		width: 100%;
		display: flex;
		align-items: center;
		background: #535257;
		z-index: 9999;
		height: 54px;
	}

	.shopping-cart-left {
		width: 70%;
		height: 100%;
		display: flex;
		align-items: center;
		background: #505052;
		z-index: 9999;
	}

	.shopping-cart-right {
		width: 30%;
		height: 100%;
		text-align: center;
		color: white;
		z-index: 9999;
		font-size: 30rpx;
		font-weight: bold;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.shopping-cart-bg {
		background: #535257;
	}

	.shopping-cart-desc {
		font-size: 24rpx;
		color: #8c8c8e;
	}

	.shopping-cart-totalPrice {
		display: flex;
		align-items: center;
	}

	.fullPriceReductionClass {
		color: gainsboro;
		text-decoration: line-through;
		margin-right: 20rpx;
	}

	.totalPrice {
		color: white;
		font-weight: bold;
	}

	.full-price-reduction {
		color: white;
		font-weight: bold;
	}

	.not-full-price-reduction {
		font-size: 28rpx;
		color: #8c8c8e;
	}

	.fullPriceReductionIsHidden {
		font-size: 28rpx;
	}

	.content-manjian {
		position: relative;
		top: 0;
		background: #fffadc;
		font-size: 24rpx;
		font-weight: bold;
		text-align: center;
		height: 73px;
		z-index: 9999;
	}

	.num {
		position: absolute;
		top: 5px;
		left: 40px;
		width: 24px;
		height: 24px;
		line-height: 24px;
		text-align: center;
		border-radius: 16px;
		font-size: 9px;
		font-weight: 700;
		color: #fff;
		background: rgb(240, 20, 20);
		box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.4);
	}

	.business-recommend-scroll-view {
		height: 269rpx;
		white-space: nowrap;
	}

	.icon-business-recommend-class {
		width: 255rpx;
		height: 200rpx;
		border-radius: 15rpx 15rpx 0 0;
	}

	.business-recommend-title {
		font-size: 34rpx;
		font-weight: bold;
		margin: 20rpx 20rpx 0 20rpx;
	}

	.business-recommend-scroll-view {
		margin-top: 20rpx;
		padding-bottom: 20rpx;
		background: #fff;
		border-radius: 50rpx;
		height: 100%;
		display: flex;
		align-items: center;
	}

	.business-recommend-scroll-view scroll-view {
		display: block;
		width: 100%;
	}

	.business-recommend-items {
		width: 100%;
		display: flex;
		/* justify-content: space-between; */
	}

	.business-recommend-item {
		width: 255rpx;
		height: auto;
		background: #f5f5f5;
		border-radius: 15rpx;
		margin: 0 10rpx;
	}

	.item-two {
		margin: 0 3.5%;
	}

	.recommend-sell-out {
		position: absolute;
		top: 10%;
		margin-left: 10%;
		height: 100rpx;
		line-height: 100rpx;
		width: 100rpx;
		text-align: center;
		opacity: 0.7;
		border-radius: 50%;
		font-size: 30rpx;
		background: #434343;
		color: white;
	}

	.business-recommend-detail-view {
		width: 255rpx;
		height: auto;
	}

	.fullname-class {
		margin-top: 11rpx;
		font-size: 26rpx;
	}

	.engname-class {
		font-size: 24rpx;
		color: #ccc;
		width: 90%;
	}

	.business-recommend-money-view {
		width: 100%;
		display: flex;
		justify-content: space-between;
		align-items: center;
		padding: 0rpx 15rpx;
	}

	.fullname-stepper {
		margin-bottom: 10rpx;
	}

	.business-recommend-money-view .stepper {
		margin-right: 30rpx;
	}

	.business-recommend-money {
		font-size: 26rpx;
		font-weight: bold;
	}

	.plus-view {
		font-size: 28rpx;
		width: 38rpx;
		height: 38rpx;
		line-height: 38rpx;
		text-align: center;
		border-radius: 50%;
		color: white;
	}

	.settlement-view {
		position: fixed;
		z-index: 999;
		background: white;
		top: 0;
		border-bottom: 6rpx solid #f5f5f5;
	}

	.manjiantop {
		position: absolute;
		top: 0;
	}

	.closeImages {
		position: relative;
		left: 91%;
		top: 4%;
		z-index: 999;
	}

	.close-image-class {
		width: 50rpx;
		height: auto;
	}

	.goods-info-view {
		display: flex;
		padding-bottom: 20rpx;
		padding-left: 20rpx;
	}

	.goods-info-name {
		font-size: 30rpx;
		font-weight: bold;
	}

	.goods-info-specListString {
		color: #6b6b6b;
		font-size: 24rpx;
	}

	.goods-info-price {
		font-weight: bold;
		height: 88rpx;
		line-height: 88rpx;
		font-size: 32rpx;
		color: #e0583b;
	}

	.specifications-scroll-view {
		height: 274px;
	}

	.clearNull {
		font-weight: 700;
		font-size: 15px;
		color: #80858a;
	}

	.specifications-dialog {
		margin-bottom: 0rpx;
	}

	.commdity-name-type-view {
		padding: 20rpx;
		background: #fff;
	}

	.commdity-name {
		font-size: 32rpx;
		font-weight: bold;
		line-height: 50rpx;
	}

	.commdity-engname {
		font-size: 28rpx;
		line-height: 60rpx;
	}

	.commdity-type-item {
		width: 100%;
		height: 100%;
		display: flex;
		justify-content: left;
		align-items: center;
		flex-wrap: wrap;
		padding-bottom: 10rpx;
	}

	.commdity-type-name {
		font-size: 28rpx;
		width: 20%;
	}

	.radio-group {
		width: 70%;
		display: grid;
		grid-template-columns: 1fr 1fr 1fr;
		flex-wrap: wrap;
		padding: 10rpx;
		background: #fff;
		border-radius: 50rpx;
	}

	.group-label {
		padding: 12rpx 1rpx;
		margin: 5rpx 5rpx;
		font-size: 26rpx;
		border-radius: 18rpx;
		text-align: center;
	}

	.disabled-group-label {
		background: #f5f5f5;
		color: #808080;
		border: none;
	}

	.radio {
		display: none;
	}

	.good-choice-view {
		padding: 20rpx;
		border-top: 1prx #808080 solid;
	}

	.good-choice-btn {
		width: 100%;
		text-align: center;
		padding: 20rpx 0;
		border-radius: 15rpx;
		font-size: 28rpx;
		font-weight: bold;
	}

	.shoppingCart-screen-dialog {
		height: 55%;
	}

	.shoppingCart-scroll-view {
		height: 350px;
	}

	.shoppingCart-item {
		display: flex;
		align-items: center;
		justify-content: space-between;
		/* width: 100%; */
		padding: 20rpx 20rpx;
		border-bottom: 1rpx solid #f5f5f5;
	}

	.goodsName-restructure-view {
		width: 50%;
	}

	.goodsName-packingCharges {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 20rpx;
	}

	.goodsName {
		font-size: 28rpx;
	}

	.restructure {
		font-size: 22rpx;
		color: #808080;
	}

	.goodsPrice-number-view {
		width: 50%;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.goodsPrice {
		font-size: 30rpx;
		font-weight: bold;
		color: #f01414;
	}

	/*主容器*/

	.stepper {
		margin-left: 20rpx;
		display: flex;
		align-items: center;
	}

	/*加号和减号*/

	.stepper text {
		width: 45rpx;
		height: 45rpx;
		line-height: 45rpx;
		font-size: 28rpx;
	}

	/* 商家栏样式 */
	.swiper-bussiness {
		text-align: left;
	}

	.swiper-tab-bussiness {
		text-align: left;
	}

	.swiper-bussiness-item {
		background: white;
		margin-bottom: 20rpx;
		padding: 20rpx;
	}

	.swiper-bussiness-info {
		font-size: 28rpx;
		color: #717171;
	}

	.swiper-bussiness-title {
		font-size: 30rpx;
		font-weight: bold;
	}

	.swiper-bussiness-row {
		font-size: 26rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 15rpx 20rpx;
		background: white;
	}

	.swiper-bussiness-row-left {
		width: 20%;
		font-size: 26rpx;
		color: black;
		font-weight: bold;
	}

	.contact-bussiness-text {
		color: #2e87cd;
	}

	.carousel-swiper-item {
		border-radius: 15rpx;
		height: 200rpx;
	}

	.carousel-image {
		width: 100%;
		height: 100%;
	}

	.is-end-item {
		background-color: white;
		padding-bottom: 50px;
	}

	.theme-other-bg {
		background: #353535;
		color: #5f5e63;
	}

	.weui-vtabs-bar__item .weui-vtabs-bar__title {
		white-space: normal;
		text-align: center;
	}

	.evaluate-business-info {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.evaluate-info-left {
		width: 80%;
		margin: 20rpx 0rpx;
		padding: 0 50rpx;
		/* border-right: 1rpx solid #f5f5f5; */
	}

	.evaluate-info-right {
		width: 20%;
		padding: 20rpx;
		text-align: center;
	}

	.business-evaluate {
		display: flex;
		justify-content: space-between;
	}

	.evaluate-total-score {
		color: #f56427;
		font-size: 40rpx;
		margin-right: 25rpx;
	}

	.evaluate-total-star {
		color: #4f4f4f;
		font-size: 24rpx;
	}

	.evaluate-total-num {
		color: #4f4f4f;
		font-size: 35rpx;
	}

	.view-line {
		height: 20rpx;
		background: #f3f3f3;
	}

	.evaluate-items {
		padding: 20rpx;
		margin-bottom: 80rpx;
	}

	.evaluate-item {
		display: flex;
		justify-content: space-between;
		padding-bottom: 30rpx;
		padding-top: 20rpx;
		border-bottom: 1rpx solid #f5f5f5;
	}

	.appraise-reply-items {
		background: #f7f7f7;
		border-radius: 10rpx;
		padding: 10rpx 15rpx;
	}

	.reply-item {
		font-size: 24rpx;
		color: #4f4f4f;
	}

	.evaluate-item-detail {
		width: 90%;
	}

	.evaluate-user-image {
		width: 8%;
		height: 8%;
		border-radius: 50%;
	}

	.evaluate-itemu-username-time {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.username-detail {
		width: 60%;
		font-size: 28rpx;
	}

	.images-url {
		width: 100rpx;
		height: 100rpx;
		margin-right: 10rpx;
	}

	.datetime-detail {
		font-size: 24rpx;
		color: #7d7d7d;
	}

	.pl-dz-class {
		display: flex;
		align-items: center;
		justify-content: space-between;
		text-align: end;
	}

	.appraise-class-pl-dz {
		margin-left: 10rpx;
	}

	.pl-dz-view {
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 26rpx;
		color: #9b9b9b;
	}

	.pl-dz-display {
		display: flex;
		align-items: center;
	}

	.input-pinglun {
		width: 100%;
		padding: 20rpx;
	}

	.userinfo-text {
		font-size: 28rpx;
		text-align: end;
		font-weight: bold;
	}

	.input-appraise {
		width: 92%;
		border: 1rpx solid #8e8e8e;
		padding: 10rpx;
		border-radius: 15rpx;
		margin: 20rpx;
		text-align: start;
		height: 150rpx;
	}

	.pinglun-bottom {
		position: fixed;
		width: 100%;
		bottom: 0;
		background: white;
		border-top: 1rpx solid #f5f5f5;
	}

	.reply-button-view {
		text-align: end;
		padding: 0 20rpx 20rpx 20rpx;
	}

	.extClassShopDetail {
		z-index: 9999;
	}

	.shop-detail-dialog {
		margin-bottom: 20rpx;
	}

	.reduced-delivery-price {
		font-size: 28rpx;
		margin-top: 20rpx;
	}

	.dialog-title {
		font-size: 30rpx;
	}

	.edit-address-class {
		text-align: center;
		height: 50px;
	}

	.edit-address-btn {
		margin: 20rpx 0;
	}

	.icongouwuche1 {
		font-size: 40rpx;
	}

	.iconweibiaoti35-copy {
		font-size: 26rpx;
	}

	.weui-vtabs-bar__content {
		width: 100%;
	}

	.mp-vtabs-class-1 {
		width: 32%;
	}

	.weui-vtabs-bar__item {
		width: 100%;
	}

	#menu_list {
		background: #f6f6f6;
	}

	.menu_list {
		position: relative;
	}

	.menu_scorll_mask {
		position: absolute;
		top: 0;
		height: 100%;
		width: 100%;
		z-index: 100;
	}


	.content {
		padding: 0 16px 16px 16px;
	}

	.van-tabs {
		display: flex;
		justify-content: space-between;
	}

	/* 左侧导航栏 */
	.van-tabs__nav {
		position: relative;
		display: block;
		background-color: #EEEEEE;
		-webkit-user-select: none;
		user-select: none;
	}

	.van-tabs__wrap--scrollable .van-tabs__nav {
		overflow-x: hidden;
		overflow-y: auto;
		-webkit-overflow-scrolling: touch;
	}

	.van-tabs__nav--line.van-tabs__nav--complete {
		padding-right: 0px;
		padding-left: 0px;
		position: fixed;
		left: 0;
	}

	.van-tabs__nav--line.van-tabs__nav--complete {
		padding-right: 0px;
		padding-left: 0px;
	}

	.van-tabs__wrap {
		height: 100%;
		width: auto;
		overflow-y: auto;
	}

	.van-tabs__line {
		display: none;
	}

	.van-tab {
		position: relative;
		height: 50px;
		width: auto;
	}

	.van-tab--active {
		color: red;
		background-color: white;
	}

	.van-tab--active::before {
		position: absolute;
		top: 50%;
		left: 0;
		width: 4px;
		height: 16px;
		background-color: #ee0a24;
		-webkit-transform: translateY(-50%);
		transform: translateY(-50%);
		content: '';
	}

	/* 右侧导航栏 */
	.van-tabs__content {
		background-color: white;
		width: calc(100% - 94px);
		height: 100%;
		overflow-y: auto;
	}

	.van-tabs--line {
		height: 90%;
		display: flex;
		flex-direction: column;
		width: 6rem;
	}

	.van-tabs__wrap {
		height: 90%;
	}

	.van-tabs--line.van-tabs__wrap.van-tabs__wrap--scrollable.wrap-class {
		height: 90%;
	}

	.van-tabs__nav {
		display: flex;
		flex-direction: column;
	}

	.van-tabs .van-tabs--line {
		height: 80vh;
	}

	.van-tabs .van-tabs__scroll {
		height: 80vh;
	}

	.public-views {
		padding: 32rpx;
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

	.menu_left_scorll {
		width: 25vh;
		background: #f6f6f6;
	}

	.menu_right_scorll {
		padding: 0 20rpx;
		background: #f6f6f6;
	}

	.menu_right_scorll_view {
		background: white;
		border-radius: 15rpx;
	}

	.vtabs-content-item {
		border-radius: 15rpx;
	}

	.menu_left_content {
		height: 80rpx;
		line-height: 80rpx;
		text-align: center;
		font-size: 26rpx;
		padding: 0 20rpx;
		box-shadow: 0 -1px #f6f6f6;
	}

	.left_active {
		border: none;
		border-radius: 0 40rpx 40rpx 0;
	}

	.no_login_out_tip {
		font-size: 26rpx;
	}

	#shopping-cart-detail {
		bottom: calc(var(--window-bottom));
	}

	.content {
		/* bottom: calc(var(--window-bottom)); */
	}

	#table_name {
		margin-right: 32rpx;
	}
</style>
import GlobalConfig from '/utils/global-config';
import https from '/utils/http';
import toastService from '/utils/toast.service';
import utilHelper from '/utils/util';
import authService from '/utils/auth';
import JSONbig from 'json-bigint';
var app = getApp();
//订单模块-订单状态
const diningTableFindById = (tableId) => {
	return new Promise((fulfill, reject) => {
		https.request_get('/rest/member/diningTable/findById', {
			id: tableId
		}).then((result) => {

			if (!result.success) {
				toastService.showToast("未查询到餐桌信息");
			}
			if (result.success) {
				result.data.tableId = tableId;
				app.globalData.deliveryAndSelfTaking.diningTable = result.data;
				app.globalData.deliveryAndSelfTaking.selfOutActiveIndex = 0;
				app.globalData.deliveryAndSelfTaking.selfOutActiveValue = 0;
				app.globalData.getShopInfo(result.data.shopId).then((result) => {

				})
			}
			fulfill(result);
		});
	});
};

const shoppingCartBindTable = (idList, tableId) => {
	return new Promise((fulfill, reject) => {
		https.request('/rest/member/shoppingCart/bindTable', {
			idList: idList,
			tableId: tableId
		}).then((result) => {
			console.log(result)
			fulfill(result.success);
		});
	});

}

const selectUnpaidDineInByTableId = (tableId) => {
	var _this = this;
	return new Promise((fulfill, reject) => {
		https.request('/rest/member/order/selectUnpaidDineInByTableId', {
			tableId: tableId
		}).then((result) => {
			if (result.success) {
				app.globalData.deliveryAndSelfTaking.continueOrderInfo = result.data;
			}
			fulfill(result);
		});
	});
}

const orderBySelectByIdShoppingCart = (id, selectedTableld) => {
	return new Promise((fulfil, reject) => {
		orderBySelectById(id, selectedTableld ? selectedTableld : '').then((result) => {
			var shoppingCart = {
				totalNum: 0,
				totalPrice: 0,
				packingCharges: 0,
				records: [],
				orderDetailList: [],
				order: {}
			};
			if (result.success) {
				shoppingCart.records = result.data.orderDetailList;
				shoppingCartInfo(shoppingCart).then(result => {
					shoppingCart = result;
				});
				shoppingCart.order = result.data.order;
				app.globalData.deliveryAndSelfTaking.continueOrderInfo = result.data;
			}
			console.log("shoppingCartshoppingCartshoppingCart", shoppingCart)
			fulfil(shoppingCart);
		});
	});
}

const orderBySelectById = (id, selectedTableld) => {
	return new Promise((fulfil, reject) => {
		https.request('/rest/member/order/selectById', {
			id: id,
			selectedTableld: selectedTableld ? selectedTableld : ''
		}).then((result) => {

			fulfil(result);
		});
	});
}

const memberOrderList = (pageNo, pageSize, tabType, keyWords, selectedTableId) => {
	return new Promise((fulfil, reject) => {
		https.request('/rest/member/order/list', {
			pageNo: pageNo,
			pageSize: pageSize,
			tabType: tabType,
			keyWords: keyWords,
			selectedTableId: selectedTableId ? selectedTableId : ''
		}).then((result) => {

			fulfil(result);
		});
	});
}

const memberShoppingCartList = (shopId, tableId) => {
	return new Promise((fulfill, reject) => {
		https.request('/rest/member/shoppingCart/list', {
			shopId: shopId,
			tableId: tableId ? tableId : '',
			pageNo: -1,
			pageSize: 20
		}).then((result) => {
			var shoppingCart = {
				totalNum: 0,
				totalPrice: 0,
				packingCharges: 0,
				records: [],
				orderDetailList: []
			};
			if (result.success) {
				shoppingCart.records = result.data.records;
				shoppingCartInfo(shoppingCart).then(result => {
					shoppingCart = result;
				});
			}
			console.log("shoppingCartshoppingCart", shoppingCart)
			fulfill(shoppingCart);
		})
	});
}

const shoppingCartInfo = (shoppingCart) => {
	return new Promise((fulfill, reject) => {
		shoppingCart.records.forEach((item, index) => {
			item.restructure = restructure(item.specList);
			shoppingCart.totalNum = shoppingCart.totalNum + item.number;
			item.goodsPrices = utilHelper.toFixed(Number(item.goodsPrice) *
				item.number, 2);
			shoppingCart.totalPrice = utilHelper.toFixed(shoppingCart.totalPrice + (
				item.price *
				item.number), 2) //初始化被选中的商品的总金额
			item.disable = item.goodsStatus == 1 || item.goodsStatus ==
				3 || item.goodsStatus == 4 ? true : false;
			shoppingCart.packingCharges =
				item.goodsStatus == 1 || item.goodsStatus == 3 || item
				.goodsStatus ==
				4 ?
				shoppingCart.packingCharges :
				shoppingCart.packingCharges + (item.packingCharges * item.number);
			shoppingCart.orderDetailList.push({
				goodsId: item.goodsId,
				specList: item.specList,
				number: item.number,
				goodsName: item.goodsName,
				restructure: item.restructure,
				price: item.price,
				id: item.id,
				packingCharges: item.packingCharges,
				totalPrice: item.price * item.number
			});
		});
		fulfill(shoppingCart);
	});
}

const restructure = (specList) => {
	var specListStr = '';
	for (var key in JSON.parse(specList)) {
		specListStr = (specListStr ? specListStr + '/' : specListStr) + JSON.parse(specList)[key];
	}
	return specListStr;
}

const shoppingCartInsert = (data, tableId) => {
	return new Promise((fulfill, reject) => {
		https.request('/rest/member/shoppingCart/insert', data).then((result) => {
			fulfill(result);
		});
	});
}

const shoppingCartUpdateNumber = (id, number, type) => {
	console.log(id, number, type)
	return new Promise((fulfill, reject) => {
		authService.checkIsLogin().then((result) => {
			console.log(result);
			if (!result) {
				app.globalData.checkIsAuth('scope.userInfo');
				fulfill(false);
			}
			if (result) {
				https.request('/rest/member/shoppingCart/updateNumber', {
					id: id,
					number: number,
					type: type
				}).then((result) => {
					fulfill(result.success);
				});
			}
		});
	});
}

const getShopCartFullReductionRule = (shopId, totalPrice) => {
	console.log("getShopCartFullReductionRule=totalPrice=", shopId, totalPrice);
	return new Promise((fulfill, reject) => {
		var fullReduction = {
			fullPriceReduction: 0,
			fullReductionRuleName: "",
			fullPriceReductionIsHidden: false,
			limitedPrice: 0,
			fullReductionRuleId: "",
			fullReductionRuleDescription: "",
			reducedPrice: 0
		};
		https.request('/rest/fullReductionRule/list', {
			pageNo: -1,
			pageSize: 1,
			shopId: shopId
		}).then(result => {
			if (result.success) {
				result.data.records.forEach((item, index) => {
					if (totalPrice >= item.limitedPrice) {
						if (item.limitedPrice > fullReduction.limitedPrice) {
							fullReduction.limitedPrice = item.limitedPrice;
							fullReduction.fullPriceReduction = totalPrice - item
								.reducedPrice;
							fullReduction.reducedPrice = item.reducedPrice;
							fullReduction.fullReductionRuleName = item.name;
							fullReduction.fullPriceReductionIsHidden = true;
							fullReduction.fullReductionRuleId = item.id;
							fullReduction.fullReductionRuleDescription = item.name;
						}
					}
				})
			}
			console.log("getShopCartFullReductionRule==", fullReduction);
			fulfill(fullReduction);
		})
	});
}

const couponsMemberRelationList = (orderDetail) => {
	var _this = this;
	return new Promise((fulfill, reject) => {
		https.request('/rest/member/couponsMemberRelation/list', {
			pageNo: -1,
			pageSize: 20,
			isUsed: 0,
			isExpired: 0,
			isValid: 0
		}).then((result) => {
			fulfill(result);
		});
	});
}

const confirmSelectDeliveryFee = (addressId, shopId) => {
	console.log(shopId,addressId)
	var _this = this;
	return new Promise((fulfill, reject) => {
		https.request('/rest/common/selectDeliveryFee', {
			deliveryAddressId: addressId,
			shopId: shopId
		}).then((result) => {
			console.log("selectDeliveryFee=",result);
			fulfill(result);
		});
	});
}

const orderAddDish = (data) => {
	return new Promise((fulfill, reject) => {
		https.request('/rest/member/order/addDish', data).then((result) => {
			fulfill(result);
		});
	});

}

const orderInsert = (data) => {
	return new Promise((fulfill, reject) => {
		https.request('/rest/member/order/insert', data).then((result) => {
			fulfill(result);
		});
	});
}


export default {
	diningTableFindById: diningTableFindById,
	shoppingCartBindTable: shoppingCartBindTable,
	selectUnpaidDineInByTableId: selectUnpaidDineInByTableId,
	orderBySelectById: orderBySelectById,
	memberShoppingCartList: memberShoppingCartList,
	shoppingCartInsert: shoppingCartInsert,
	shoppingCartUpdateNumber: shoppingCartUpdateNumber,
	getShopCartFullReductionRule: getShopCartFullReductionRule,
	couponsMemberRelationList: couponsMemberRelationList,
	confirmSelectDeliveryFee: confirmSelectDeliveryFee,
	orderAddDish: orderAddDish,
	orderInsert: orderInsert,
	memberOrderList: memberOrderList
};
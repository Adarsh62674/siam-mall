package com.siam.system.modular.package_goods.service_impl.internal;

import com.siam.package_common.constant.Quantity;
import com.siam.package_common.util.DateUtilsExtend;
import com.siam.system.modular.package_goods.model.example.internal.PointsMallGoodsExample;
import com.siam.system.modular.package_goods.model.param.StatisticsParam;
import com.siam.system.modular.package_goods.service.SystemUsageRecordService;
import com.siam.system.modular.package_goods.service.internal.PointsMallGoodsService;
import com.siam.system.modular.package_goods.service.internal.PointsMallShoppingCartService;
import com.siam.system.modular.package_goods.service.internal.PointsMallStatisticsService;
import com.siam.system.modular.package_order.model.example.internal.PointsMallOrderExample;
import com.siam.system.modular.package_order.model.param.internal.PointsMallOrderParam;
import com.siam.system.modular.package_order.service.internal.PointsMallOrderRefundService;
import com.siam.system.modular.package_order.service.internal.PointsMallOrderService;
import com.siam.system.modular.package_user.service.MemberService;
import com.siam.system.modular.package_user.service.MemberTradeRecordService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
public class PointsMallStatisticsServiceImpl implements PointsMallStatisticsService {

    @Autowired
    private MemberTradeRecordService memberTradeRecordService;

    @Autowired
    private SystemUsageRecordService systemUsageRecordService;

    @Autowired
    private PointsMallOrderService pointsMallOrderService;

    @Autowired
    private PointsMallOrderRefundService pointsMallOrderRefundService;

    @Autowired
    private PointsMallShoppingCartService pointsMallShoppingCartService;

    @Autowired
    private PointsMallGoodsService pointsMallGoodsService;

    @Autowired
    private MemberService memberService;

    @Override
    public Map pointsMallTodayStatisticByAdmin(StatisticsParam param) {
        Map resultMap = new HashMap();

        //订单表筛选条件-当前登录商家
        PointsMallOrderParam order = new PointsMallOrderParam();

        //今日支付订单、今日实际收入、今日进店人数、今日加购商品
        order.setStartTime(DateUtilsExtend.getDayBegin());
        order.setEndTime(DateUtilsExtend.getDayEnd());
        int dayCountPaid = pointsMallOrderService.selectCountCompleted(order, order.getStartTime(), order.getEndTime());
        BigDecimal daySumMerchantIncome = pointsMallOrderService.selectSumActualPrice(order, order.getStartTime(), order.getEndTime());
        int todayCountIntoShop = systemUsageRecordService.selectCountIntoPointsMall(DateUtilsExtend.getDayBegin(), DateUtilsExtend.getDayEnd());
        int todayCountShoppingCartGoodsNumber = pointsMallShoppingCartService.selectCountGoodsNumber(null, DateUtilsExtend.getDayBegin(), DateUtilsExtend.getDayEnd());

        //待配送订单(外卖)、已完成订单、待处理退款申请
        PointsMallOrderExample orderExample = new PointsMallOrderExample();
        PointsMallOrderExample.Criteria criteria = orderExample.createCriteria();
        criteria.andStatusEqualTo(Quantity.INT_4);
        int waitDeliverOrderCount = pointsMallOrderService.countByExample(orderExample);

        orderExample = new PointsMallOrderExample();
        criteria = orderExample.createCriteria();
        criteria.andStatusEqualTo(Quantity.INT_6);
        int completedOrderCount = pointsMallOrderService.countByExample(orderExample);

        orderExample = new PointsMallOrderExample();
        criteria = orderExample.createCriteria();
        criteria.andStatusEqualTo(Quantity.INT_7);
        int handleOrderRefundCount = pointsMallOrderService.countByExample(orderExample);

        //商品总览：已下架、已上架、库存售罄、全部商品
        PointsMallGoodsExample goodsExample = new PointsMallGoodsExample();
        goodsExample.createCriteria().andStatusEqualTo(Quantity.INT_3);
        int underShelfGoodsCount = pointsMallGoodsService.countByExample(goodsExample);

        goodsExample = new PointsMallGoodsExample();
        goodsExample.createCriteria().andStatusEqualTo(Quantity.INT_2);
        int onShelfGoodsCount = pointsMallGoodsService.countByExample(goodsExample);

        goodsExample = new PointsMallGoodsExample();
        goodsExample.createCriteria().andStatusEqualTo(Quantity.INT_4);
        int sellOutGoodsCount = pointsMallGoodsService.countByExample(goodsExample);

        goodsExample = new PointsMallGoodsExample();
        goodsExample.createCriteria();
        int allGoodsCount = pointsMallGoodsService.countByExample(goodsExample);

        //指数总览：客单价(成交金额/成交订单数)、下单转化率(下单人数/访问人数)、下单-支付转化率(支付人数/下单人数)、支付转化率(支付人数/访问人数)
        Date startDate = new Date("1970/1/1 00:00:00");
        BigDecimal perCustomerTransaction;
        order.setStartTime(startDate);
        order.setEndTime(DateUtilsExtend.getDayEnd());
        BigDecimal sumActualPrice = pointsMallOrderService.selectSumActualPrice(order, order.getStartTime(), order.getEndTime());
        int countPaid = pointsMallOrderService.selectCountCompleted(order, order.getStartTime(), order.getEndTime());
        if(countPaid == 0){
            perCustomerTransaction = BigDecimal.valueOf(-1);
        }else{
            perCustomerTransaction = sumActualPrice.divide(BigDecimal.valueOf(countPaid), 2, BigDecimal.ROUND_HALF_UP);
        }

        BigDecimal orderConversionRate;
        int countOrderPeoples = pointsMallOrderService.selectCountOrderPeoples(order, order.getStartTime(), order.getEndTime());
        int countIntoShop = systemUsageRecordService.selectCountIntoShop(null, startDate, DateUtilsExtend.getDayEnd());
        if(countIntoShop == 0){
            orderConversionRate = BigDecimal.valueOf(-1);
        }else{
            orderConversionRate = BigDecimal.valueOf(countOrderPeoples).divide(BigDecimal.valueOf(countIntoShop), 2, BigDecimal.ROUND_HALF_UP);
        }

        BigDecimal orderPaymentConversionRate;
        int countPayers = pointsMallOrderService.selectCountPayers(order, order.getStartTime(), order.getEndTime());
        if(countOrderPeoples == 0){
            orderPaymentConversionRate = BigDecimal.valueOf(-1);
        }else{
            orderPaymentConversionRate = BigDecimal.valueOf(countPayers).divide(BigDecimal.valueOf(countOrderPeoples), 2, BigDecimal.ROUND_HALF_UP);
        }

        BigDecimal paymentConversionRate;
        if(countIntoShop == 0){
            paymentConversionRate = BigDecimal.valueOf(-1);
        }else{
            paymentConversionRate = BigDecimal.valueOf(countPayers).divide(BigDecimal.valueOf(countIntoShop), 2, BigDecimal.ROUND_HALF_UP);
        }

        //对百分比做限制，必须控制在0~1之间
        if(orderConversionRate.compareTo(BigDecimal.ONE) > 0){
            orderConversionRate = BigDecimal.ONE;
        }else if(orderConversionRate.compareTo(BigDecimal.ZERO) < 0){
            orderConversionRate = BigDecimal.ZERO;
        }
        if(orderPaymentConversionRate.compareTo(BigDecimal.ONE) > 0){
            orderPaymentConversionRate = BigDecimal.ONE;
        }else if(orderPaymentConversionRate.compareTo(BigDecimal.ZERO) < 0){
            orderPaymentConversionRate = BigDecimal.ZERO;
        }
        if(paymentConversionRate.compareTo(BigDecimal.ONE) > 0){
            paymentConversionRate = BigDecimal.ONE;
        }else if(paymentConversionRate.compareTo(BigDecimal.ZERO) < 0){
            paymentConversionRate = BigDecimal.ZERO;
        }

        resultMap.put("dayCountPaid", dayCountPaid);
        resultMap.put("daySumMerchantIncome", daySumMerchantIncome);
        resultMap.put("todayCountIntoShop", todayCountIntoShop);
        resultMap.put("todayCountShoppingCartGoodsNumber", todayCountShoppingCartGoodsNumber);
        resultMap.put("waitDeliverOrderCount", waitDeliverOrderCount);
        resultMap.put("completedOrderCount", completedOrderCount);
        resultMap.put("handleOrderRefundCount", handleOrderRefundCount);
        resultMap.put("underShelfGoodsCount", underShelfGoodsCount);
        resultMap.put("onShelfGoodsCount", onShelfGoodsCount);
        resultMap.put("sellOutGoodsCount", sellOutGoodsCount);
        resultMap.put("allGoodsCount", allGoodsCount);
        resultMap.put("perCustomerTransaction", perCustomerTransaction);
        resultMap.put("orderConversionRate", orderConversionRate);
        resultMap.put("orderPaymentConversionRate", orderPaymentConversionRate);
        resultMap.put("paymentConversionRate", paymentConversionRate);

        return resultMap;
    }
}
package com.siam.system.modular.package_order.controller.admin.internal;

import cn.hutool.core.collection.CollectionUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.siam.package_common.entity.BasicResult;
import com.siam.package_common.exception.StoneCustomerException;
import com.siam.package_common.model.valid_group.ValidGroupOfAudit;
import com.siam.package_common.model.valid_group.ValidGroupOfId;
import com.siam.system.modular.package_order.entity.Order;
import com.siam.system.modular.package_order.entity.OrderDetail;
import com.siam.system.modular.package_order.entity.internal.PointsMallOrderDetail;
import com.siam.system.modular.package_order.model.param.internal.PointsMallOrderParam;
import com.siam.system.modular.package_order.model.result.internal.OrderResult;
import com.siam.system.modular.package_order.model.result.internal.PointsMallOrderResult;
import com.siam.system.modular.package_order.service.internal.PointsMallOrderDetailService;
import com.siam.system.modular.package_order.service.internal.PointsMallOrderService;
import com.siam.system.modular.package_order.entity.internal.PointsMallOrder;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping(value = "/rest/admin/pointsMall/order")
@Transactional(rollbackFor = Exception.class)
@Api(tags = "后台订单模块相关接口", description = "AdminPointsMallOrderController")
public class AdminPointsMallOrderController {

    @Resource(name = "pointsMallOrderServiceImpl")
    private PointsMallOrderService orderService;

    @Autowired
    private PointsMallOrderDetailService orderDetailService;

    @ApiOperation(value = "订单列表")
    @PostMapping(value = "/list")
    public BasicResult list(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        Page page = orderService.getListByPageWithAsc(param);
        return BasicResult.success(page);
    }

    @ApiOperation(value = "订单列表(附带订单商品详情)")
    @PostMapping(value = "/listWithDetail")
    public BasicResult listWithDetail(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        Page<PointsMallOrderResult> page = orderService.getListByPageWithAsc(param);
        return BasicResult.success(page);
    }

    @ApiOperation("打印小票")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id" ,value="订单商品详情表主键id",required = true,paramType = "query",dataType="int")
    })
    public BasicResult printRceceipts(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        for(String id : param.getIds()){
            orderService.printRceceipts(Long.valueOf(id));
        }
        return BasicResult.success();
    }

    @ApiOperation(value = "查询单个订单信息")
    @PostMapping(value = "/selectById")
    public BasicResult selectById(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        PointsMallOrder dbPointsMallOrder = orderService.getById(param.getId());
        if(dbPointsMallOrder == null){
            throw new StoneCustomerException("该订单不存在");
        }
        return BasicResult.success(dbPointsMallOrder);
    }

    @ApiOperation(value = "批量修改订单的是否已打印状态为已打印")
    @PostMapping(value = "/batchUpdateIsPrintedTrue")
    public BasicResult batchUpdateIsPrintedTrue(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        orderService.batchUpdateIsPrintedTrue(param);
        return BasicResult.success();
    }

    @ApiOperation(value = "今日订单列表")
    @PostMapping(value = "/todayPointsMallOrderList")
    public BasicResult todayPointsMallOrderList(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        Page page = orderService.getListByTodayOrderWithAsc(param);
        return BasicResult.success(page);
    }

    @ApiOperation(value = "查询所有订单标签页的待处理数量")
    @PostMapping(value = "/selectAllTabWaitHandleNum")
    public BasicResult selectAllTabWaitHandleNum(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        Map map = orderService.selectAllTabWaitHandleNum(param);
        return BasicResult.success(map);
    }

    @ApiOperation(value = "查询所有已付款未打印的订单")
    @PostMapping(value = "/waitPrintPointsMallOrderList")
    public BasicResult waitPrintPointsMallOrderList(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        List<PointsMallOrder> pointsMallOrders = orderService.waitPrintPointsMallOrderList(param);
        return BasicResult.success(pointsMallOrders);
    }

    @ApiOperation(value = "订单统计(支付成功订单数量、取消订单数量、退款订单数量，按自取或者外卖分开)")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "startCreateTime", value = "下单开始时间", required = false, paramType = "query", dataType = "Date"),
            @ApiImplicitParam(name = "endCreateTime", value = "下单结束时间", required = false, paramType = "query", dataType = "Date"),
    })
    @PostMapping(value = "/countPointsMallOrder")
    public BasicResult countPointsMallOrder(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        Map count = orderService.countOrder(param);
        return BasicResult.success(count);
    }

    @ApiOperation(value = "售后处理订单列表")
    @PostMapping(value = "/afterSalesList")
    public BasicResult afterSalesList(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        Page<Map<String, Object>> page = orderService.getAfterSalesListByPageWithAsc(param);
        return BasicResult.success(page);
    }

    @ApiOperation(value = "售后处理订单列表")
    @PostMapping(value = "/afterSalesListWithDetail")
    public BasicResult afterSalesListWithDetail(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        Page<Map<String, Object>> page = orderService.getAfterSalesListByPageWithAsc(param);
        return BasicResult.success(page);
    }

    /**
     * 售后处理订单-处理
     *
     * @return
     * @author 暹罗
     */
    @PostMapping(value = "/auditAfterSalesOrder")
    public BasicResult auditAfterSalesOrder(@RequestBody @Validated(value = {ValidGroupOfId.class, ValidGroupOfAudit.class}) PointsMallOrderParam orderParam){
        orderService.auditAfterSalesOrder(orderParam);
        return BasicResult.success();
    }

    /**
     * 查询订单统计数据
     * PS；一次性将所有数据全部查出来，而不是每次选择时间段时来实时请求数据
     */
    @PostMapping(value = "/statistic")
    public BasicResult statisticPointsMallOrder(@RequestBody @Validated(value = {}) PointsMallOrderParam param) throws ParseException {
        Map map = orderService.statistic(param);
        return BasicResult.success(map);
    }

    /**
     * 订单发货
     *
     * @return
     * @author 暹罗
     */
    @PostMapping(value = "/deliver")
    public BasicResult deliver(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        orderService.deliver(param);
        return BasicResult.success();
    }

    /**
     * 修改快递单号
     *
     * @return
     * @author 暹罗
     */
    @PostMapping(value = "/updateLogisticsNo")
    public BasicResult updateLogisticsNo(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        orderService.updateLogisticsNo(param);
        return BasicResult.success();
    }

    /**
     * 修改订单信息
     *
     * @return
     * @author 暹罗
     */
    @PostMapping(value = "/update")
    public BasicResult update(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        orderService.updateByAdmin(param);
        return BasicResult.success();
    }

    /**
     * 未发货/已发货申请售后-仅退款
     *
     * @return
     * @author 暹罗
     */
    @PostMapping(value = "/applyAfterSalesDelivered/onlyRefund")
    public BasicResult onlyRefund(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        orderService.onlyRefundByAdmin(param);
        return BasicResult.success();
    }

    /**
     * 查看订单退款信息
     *
     * @return
     * @author 暹罗
     */
    @PostMapping(value = "/selectRefundInfo")
    public BasicResult selectRefundInfo(@RequestBody @Validated(value = {}) PointsMallOrderParam param){
        Map map = orderService.selectRefundInfo(param);
        return BasicResult.success(map);
    }

    @ApiOperation(value = "导出订单Excel报表")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNo", value = "页码(值为-1不分页)", required = true, paramType = "query", dataType = "int", defaultValue = "1"),
            @ApiImplicitParam(name = "pageSize", value = "页数", required = true, paramType = "query", dataType = "int", defaultValue = "20"),
    })
    @GetMapping(value = "/export")
    public void exportOrder(@RequestParam List<String> ids, HttpServletResponse response) {
        try {
            //获取当前登录用户绑定的门店编号
//            Merchant loginMerchant = merchantSessionManager.getSession(TokenUtil.getToken());

            LambdaQueryWrapper<PointsMallOrder> lambdaQueryWrapper = new LambdaQueryWrapper<>();
            lambdaQueryWrapper.orderByDesc(PointsMallOrder::getCreateTime);
            lambdaQueryWrapper.last("limit 200");
//            lambdaQueryWrapper.eq(Order::getShopId, loginMerchant.getShopId());
            if (CollectionUtil.isNotEmpty(ids)) {
                lambdaQueryWrapper.in(PointsMallOrder::getId, ids);
            }
            List<PointsMallOrder> orderList = orderService.list(lambdaQueryWrapper);

            //查询订单详情
            Map<Long, List<PointsMallOrderDetail>> map = new HashMap<>();
            if (CollectionUtil.isNotEmpty(orderList)) {
                List<Long> orderIdList = orderList.stream().map(PointsMallOrder::getId).collect(Collectors.toList());
                LambdaQueryWrapper<PointsMallOrderDetail> orderDetailLambdaQueryWrapper = new LambdaQueryWrapper<>();
                orderDetailLambdaQueryWrapper.in(PointsMallOrderDetail::getOrderId, orderIdList);
                List<PointsMallOrderDetail> orderDetailList = orderDetailService.list(orderDetailLambdaQueryWrapper);

                //组装到各个订单下
                orderDetailList.forEach(orderDetail -> {
                    if (map.containsKey(orderDetail.getOrderId())) {
                        map.get(orderDetail.getOrderId()).add(orderDetail);
                    } else {
                        List<PointsMallOrderDetail> list = new ArrayList<>();
                        list.add(orderDetail);
                        map.put(orderDetail.getOrderId(), list);
                    }
                });
            }

            List<PointsMallOrderResult> orderResultList = new ArrayList<>();
            orderList.forEach(order -> {
                PointsMallOrderResult orderResult = new PointsMallOrderResult();
                BeanUtils.copyProperties(order, orderResult);
                orderResult.setOrderDetailList(map.get(order.getId()));
                orderResultList.add(orderResult);
            });

            // 生成Excel数据
            XSSFWorkbook workbook = orderService.createExcel(orderResultList);

            // 设置响应体
            String fileName = "订单信息表_" + System.currentTimeMillis() + ".xlsx";
            // 这里必须用ISO8859-1重新编码，否则文件名里面的中文无法解析，会以下划线代替
            fileName = new String(fileName.getBytes(), "ISO8859-1");
            response.setContentType("application/octet-stream;charset=UTF-8"); //这里的编码写啥都可以
            response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
            response.addHeader("Pargam", "no-cache");
            response.addHeader("Cache-Control", "no-cache");

            // 将Excel数据写入输出流
            OutputStream os = response.getOutputStream();
            workbook.write(os);

            // 关闭资源
            os.flush();
            os.close();
            workbook.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
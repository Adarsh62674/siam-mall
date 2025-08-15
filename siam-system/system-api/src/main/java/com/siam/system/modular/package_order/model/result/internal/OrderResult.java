package com.siam.system.modular.package_order.model.result.internal;

import com.siam.system.modular.package_order.entity.Order;
import com.siam.system.modular.package_order.entity.OrderDetail;
import io.swagger.annotations.ApiModel;
import lombok.Data;

import java.util.List;

@Data
@ApiModel(value = "订单表")
public class OrderResult extends Order {

    //订单商品详情列表
    private List<OrderDetail> orderDetailList;

}
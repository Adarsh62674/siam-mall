package com.siam.system.modular.package_order.service.internal;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.siam.system.modular.package_order.entity.OrderDetail;
import com.siam.system.modular.package_order.entity.internal.PointsMallOrderDetail;
import com.siam.system.modular.package_order.model.example.internal.PointsMallOrderDetailExample;

import java.util.List;

public interface PointsMallOrderDetailService extends IService<PointsMallOrderDetail> {

    Page getListByPage(int pageNo, int pageSize, PointsMallOrderDetail orderDetail);

    List<PointsMallOrderDetail> selectByPointsMallOrderId(Long orderId);

}
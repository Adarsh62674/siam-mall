package com.siam.system.modular.package_order.service_impl.internal;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.siam.system.modular.package_order.mapper.internal.PointsMallOrderDetailMapper;
import com.siam.system.modular.package_order.mapper.internal.PointsMallOrderMapper;
import com.siam.system.modular.package_order.service.internal.PointsMallOrderDetailService;
import com.siam.system.modular.package_order.entity.internal.PointsMallOrderDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class PointsMallOrderDetailServiceImpl extends ServiceImpl<PointsMallOrderDetailMapper, PointsMallOrderDetail> implements PointsMallOrderDetailService {

    @Autowired
    private PointsMallOrderDetailMapper orderDetailMapper;

    @Autowired
    private PointsMallOrderMapper orderMapper;

    public Page getListByPage(int pageNo, int pageSize, PointsMallOrderDetail orderDetail) {
        Page<Map<String, Object>> page = orderDetailMapper.getListByPage(new Page(pageNo, pageSize), orderDetail);
        return page;
    }

    @Override
    public List<PointsMallOrderDetail> selectByPointsMallOrderId(Long orderId) {
        return orderDetailMapper.selectByPointsMallOrderId(orderId);
    }


}
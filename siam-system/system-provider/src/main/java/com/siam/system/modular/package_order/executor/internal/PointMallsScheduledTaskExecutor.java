package com.siam.system.modular.package_order.executor.internal;

import com.siam.package_common.annoation.ScheduledTaskAnnotation;
import com.siam.package_common.constant.ScheduledTaskConst;
import com.siam.system.modular.package_goods.service.internal.PointsMallCouponsMemberRelationService;
import com.siam.system.modular.package_order.service.internal.PointsMallOrderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.IOException;

/**
 * 定时任务执行器
 */
@Slf4j
@Component
@Transactional(rollbackFor = Exception.class)
public class PointMallsScheduledTaskExecutor {

    @Resource(name = "pointsMallOrderServiceImpl")
    private PointsMallOrderService pointsMallOrderService;

    @Autowired
    private PointsMallCouponsMemberRelationService mallCouponsMemberRelationService;

    /**
     * 每天凌晨0点20分同步商城-订单物流信息
     */
    @Scheduled(cron = "0 20 0 * * ?")
    /*@Scheduled(cron = "0 49 3 * * ?")*/
    @ScheduledTaskAnnotation(code = ScheduledTaskConst.SYNC_POINTS_MALL_ORDER_LOGISTICS_INFO)
    public void syncPointsMallOrderLogisticsInfo_task() throws IOException {
        pointsMallOrderService.syncOrderLogisticsInfo();

        //检测如果有商城订单支付超过7天(7*24个小时) 且 订单处于已发货状态，则将订单修改为已完成
        pointsMallOrderService.updateByFinishOverdueOrder();
    }

    /**
     * 每天0点检测逾期的优惠卷
     */
    @Scheduled(cron = "0 0 0 * * ?")
    @ScheduledTaskAnnotation(code = ScheduledTaskConst.MALL_CHECK_OVERDUE_COUPONS)
    public void updateByCheckOverdueCoupons_task(){
        mallCouponsMemberRelationService.updateOverdue();
    }
}
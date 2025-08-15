package com.siam.system.modular.package_goods.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.siam.system.modular.package_goods.entity.Setting;
import com.siam.system.modular.package_order.entity.Order;

/**
 *  暹罗
 */
public interface SettingService extends IService<Setting> {

    Page getListByPage(int pageNo, int pageSize, Setting setting);

    /**
     * 查询基础数据设置
     * @author 暹罗
     */
    Setting selectCurrent();
}
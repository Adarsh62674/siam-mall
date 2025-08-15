package com.siam.system.modular.package_goods.mapper;

import java.util.List;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

import com.siam.system.modular.package_goods.entity.TbUnit;
import com.siam.system.modular.package_goods.model.param.TbUnitParam;

/**
 * ---------------------------
 * 单位表 (TbUnitMapper)         
 * ---------------------------
 * 作者：  暹罗
 * 时间：  2024-07-10 18:05:17
 * ---------------------------
 */
public interface TbUnitMapper extends BaseMapper<TbUnit> {

    /**
     * 基础分页查询
     * @param param
     * @return
     */    
    Page<TbUnit> page(@Param("page") Page page, @Param("param") TbUnitParam param);
    
}
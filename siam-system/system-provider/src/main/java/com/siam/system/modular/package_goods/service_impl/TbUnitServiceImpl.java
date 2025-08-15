package com.siam.system.modular.package_goods.service_impl;

import java.util.List;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import com.siam.system.modular.package_goods.entity.TbUnit;
import com.siam.system.modular.package_goods.model.param.TbUnitParam;
import com.siam.system.modular.package_goods.mapper.TbUnitMapper;
import com.siam.system.modular.package_goods.service.TbUnitService;

/**
 * ---------------------------
 * 单位表 (TbUnitServiceImpl)         
 * ---------------------------
 * 作者：  暹罗
 * 时间：  2024-07-10 18:05:17
 * ---------------------------
 */
@Service
public class TbUnitServiceImpl extends ServiceImpl<TbUnitMapper, TbUnit> implements TbUnitService {

	@Autowired
	private TbUnitMapper tbUnitMapper;

	@Override
	public void insert(TbUnitParam param) {
		TbUnit record = new TbUnit();
		BeanUtils.copyProperties(param, record);
        tbUnitMapper.insert(record);
	}

	@Override
	public void delete(Long id) {
		tbUnitMapper.deleteById(id);
	}

	@Override
	public void batchDelete(List<Long> idList) {
		tbUnitMapper.deleteBatchIds(idList);
	}

	@Override
	public void update(TbUnitParam param) {
		TbUnit record = new TbUnit();
		BeanUtils.copyProperties(param, record);
		tbUnitMapper.updateById(record);
	}

	@Override
	public Page<TbUnit> page(TbUnitParam param) {
        Page<TbUnit> page = tbUnitMapper.page(new Page(param.getPageNo(), param.getPageSize()), param);
        return page;
	}

	@Override
	public TbUnit findById(Long id) {
		return tbUnitMapper.selectById(id);
	}
}

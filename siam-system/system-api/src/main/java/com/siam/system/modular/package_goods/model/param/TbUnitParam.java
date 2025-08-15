package com.siam.system.modular.package_goods.model.param;

import lombok.Data;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.siam.system.modular.package_goods.entity.TbUnit;
import com.siam.package_common.entity.BaseParam;

/**
 * ---------------------------
 * 单位表 (TbUnitParam)
 * ---------------------------
 * 作者：  暹罗
 * 时间：  2024-07-10 18:05:17
 * ---------------------------
 */
@Data
public class TbUnitParam extends BaseParam {

	/** 主键id */
	private Long id;

	/** 单位名称 */
	private String name;

	/** 创建时间 */
	private java.util.Date createTime;

	/** 修改时间 */
	private java.util.Date updateTime;

}

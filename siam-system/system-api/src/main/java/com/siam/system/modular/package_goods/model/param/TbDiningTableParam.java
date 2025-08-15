package com.siam.system.modular.package_goods.model.param;

import lombok.Data;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.siam.system.modular.package_goods.entity.TbDiningTable;
import com.siam.package_common.entity.BaseParam;

/**
 * ---------------------------
 * 餐桌表 (TbDiningTableParam)
 * ---------------------------
 * 作者：  暹罗
 * 时间：  2024-07-10 18:05:17
 * ---------------------------
 */
@Data
public class TbDiningTableParam extends BaseParam {

	/** 主键id */
	private Long id;

	/** 店铺id */
	private Integer shopId;

	/** 餐桌编号 */
	private String tableNo;

	/** 餐桌名称 */
	private String tableName;

	/** 餐桌码-微信小程序太阳码 */
	private String tableSuncode;

	/** 创建时间 */
	private java.util.Date createTime;

	/** 修改时间 */
	private java.util.Date updateTime;

}

package com.siam.system.modular.package_goods.entity;

import lombok.Data;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * ---------------------------
 * 餐桌表 (TbDiningTable)         
 * ---------------------------
 * 作者：  暹罗
 * 时间：  2024-07-10 18:05:17
 * ---------------------------
 */
@Data
@TableName("tb_dining_table")
public class TbDiningTable {

	/** 主键id */
	@TableId(value = "id", type = IdType.ASSIGN_ID)
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
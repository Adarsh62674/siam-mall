package com.siam.system.modular.package_goods.entity;

import lombok.Data;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * ---------------------------
 * 单位表 (TbUnit)         
 * ---------------------------
 * 作者：  暹罗
 * 时间：  2024-07-10 18:05:17
 * ---------------------------
 */
@Data
@TableName("tb_unit")
public class TbUnit {

	/** 主键id */
	@TableId(value = "id", type = IdType.ASSIGN_ID)
	private Long id;

	/** 单位名称 */
	private String name;

	/** 创建时间 */
	private java.util.Date createTime;

	/** 修改时间 */
	private java.util.Date updateTime;

}
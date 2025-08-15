package com.siam.system.modular.package_order.entity;

import com.baomidou.mybatisplus.annotation.IdType; import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Data
@ApiModel(value = "订单商品详情表")
@TableName("tb_order_detail")
public class OrderDetail {

    @ApiModelProperty(notes = "主键id")
    @TableId(type = IdType.AUTO)
    private Integer id;

    @TableField(exist = false)
    List<String> ids;

    @ApiModelProperty(notes = "订单id")
    private Integer orderId;

    @ApiModelProperty(notes = "商品id")
    private Integer goodsId;

    @ApiModelProperty(notes = "商品名称")
    private String goodsName;

    @ApiModelProperty(notes = "商品主图")
    private String mainImage;

    @ApiModelProperty(notes = "商品规格 JSON格式")
    private String specList;

    @ApiModelProperty(notes = "价格")
    private BigDecimal price;

    @ApiModelProperty(notes = "购买数量")
    private Integer number;

    @ApiModelProperty(notes = "小计")
    private BigDecimal subtotal;

    private BigDecimal packingCharges;

    private Boolean isUsedCoupons;

    private BigDecimal couponsDiscountPrice;

    private BigDecimal afterCouponsDiscountPrice;

    private Boolean isDeleted;

    private String unitName;

    @ApiModelProperty(notes = "创建时间")
    private Date createTime;

    @ApiModelProperty(notes = "修改时间")
    private Date updateTime;

    //页码
    @TableField(exist = false) private Integer pageNo = 1;

    //页面大小
    @TableField(exist = false) private Integer pageSize = 20;
}
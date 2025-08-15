package com.siam.system.modular.package_goods.entity;

import com.baomidou.mybatisplus.annotation.IdType; import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("tb_setting")
public class Setting {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private BigDecimal purchaseRewardPoints;

    private BigDecimal registrationRewardPoints;

    private Integer newMemberCouponsId;

    private BigDecimal merchantWithdrawFee;

    private BigDecimal startDeliveryPrice;

    private BigDecimal deliveryStartingDistance;

    private BigDecimal deliveryStartingPrice;

    private BigDecimal deliveryKilometerPrice;

    private BigDecimal deliveryDistanceLimit;

    private BigDecimal orderSystemExtractionRatio;

    private BigDecimal merchantMealPreparationTime;

    private BigDecimal memberWithdrawFee;

    private BigDecimal registrationRewardInviteRewardAmount;

    private BigDecimal memberWithdrawMeetAmount;

    private BigDecimal memberWithdrawAuditThreshold;

    private String customerServicePhone;

    private String customerServiceWechat;

    private String customerServiceWechatQrcode;

    private BigDecimal freightInsurancePaidAmount;

    private BigDecimal inviteeConsumeCommission;

    private BigDecimal caseoneOwnCommission;

    private BigDecimal casetwoOwnCommission;

    private BigDecimal casetwoFirstLevelInviterCommission;

    private BigDecimal casethreeOwnCommission;

    private BigDecimal casethreeFirstLevelInviterCommission;

    private BigDecimal casethreeSecondLevelInviterCommission;

    private BigDecimal pointsMallInviteeConsumeCommission;

    private BigDecimal pointsMallCaseoneOwnCommission;

    private BigDecimal pointsMallCasetwoOwnCommission;

    private BigDecimal pointsMallCasetwoFirstLevelInviterCommission;

    private BigDecimal pointsMallCasethreeOwnCommission;

    private BigDecimal pointsMallCasethreeFirstLevelInviterCommission;

    private BigDecimal pointsMallCasethreeSecondLevelInviterCommission;

    private String inviteFriendsActivityRule;

    private String commissionRule;

    private String vipRule;

    private Integer shopManagementMode;

    private Integer defaultShopId;

    private String province;

    private String city;

    private String area;

    private String street;

    private String realname;

    private String phone;

    private Date createTime;

    private Date updateTime;

    //页码
    @TableField(exist = false) private Integer pageNo = 1;

    //页面大小
    @TableField(exist = false) private Integer pageSize = 20;

}
package com.siam.system.modular.package_goods.entity.internal;

import com.baomidou.mybatisplus.annotation.IdType; import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
@TableName("tb_printer")
public class Printer {

    @TableField(exist = false)
    List<Integer> ids;

    //页码
    @TableField(exist = false) private Integer pageNo = 1;

    //页面大小
    @TableField(exist = false) private Integer pageSize = 20;

    @TableId(type = IdType.AUTO)
    private Integer id;

    private Integer shopId;

    private String name;

    private String number;

    private String identifyingCode;

    private Boolean isAutoPrint;

    private String mobileCardNumber;

    private String cloudRegistrationStatus;

    private Integer type;

    private Integer brand;

    private String developerId;

    private String developerKey;

    private Date createTime;

    private Date updateTime;

}
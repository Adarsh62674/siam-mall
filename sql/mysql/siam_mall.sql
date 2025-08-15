SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for tb_admin
-- ----------------------------
DROP TABLE IF EXISTS `tb_admin`;
CREATE TABLE `tb_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `username` varchar(50) DEFAULT NULL COMMENT '管理员用户名',
  `mobile` varchar(11) NOT NULL COMMENT '手机号',
  `password` varchar(100) DEFAULT NULL COMMENT '密码',
  `password_salt` varchar(100) DEFAULT NULL COMMENT '密码加盐',
  `nickname` varchar(100) DEFAULT NULL COMMENT '昵称',
  `roles` varchar(128) DEFAULT NULL COMMENT '权限',
  `is_disabled` int(1) NOT NULL DEFAULT '0' COMMENT '是否禁用 0=启用 1=禁用',
  `is_deleted` int(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0=正常 1=已删除',
  `disabled` int(1) NOT NULL DEFAULT '0' COMMENT '是否禁用 0=启用 1=禁用',
  `create_time` datetime DEFAULT NULL COMMENT '注册时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登陆时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='后台管理员表';

-- ----------------------------
-- Table structure for tb_advertisement
-- ----------------------------
DROP TABLE IF EXISTS `tb_advertisement`;
CREATE TABLE `tb_advertisement` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `image_name` varchar(50) DEFAULT NULL COMMENT '轮播图名称',
  `image_path` varchar(256) DEFAULT NULL COMMENT '轮播图路径',
  `description` varchar(50) DEFAULT NULL COMMENT '说明',
  `type` int(2) DEFAULT '1' COMMENT '轮播图类型 1=首页轮播图 2=菜单页轮播图 3=商城页面轮播图 4=分享页面生成美图',
  `sort_number` int(11) DEFAULT NULL COMMENT '排序号',
  `image_link_url` varchar(256) DEFAULT NULL COMMENT '点击轮播图跳转的链接',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COMMENT='广告轮播图表';

-- ----------------------------
-- Table structure for tb_delivery_address
-- ----------------------------
DROP TABLE IF EXISTS `tb_delivery_address`;
CREATE TABLE `tb_delivery_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `realname` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '联系人姓名',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `province` varchar(20) DEFAULT NULL COMMENT '省份',
  `city` varchar(20) DEFAULT NULL COMMENT '城市',
  `area` varchar(100) DEFAULT NULL COMMENT '区/县',
  `street` varchar(100) DEFAULT NULL COMMENT '详细地址',
  `is_default` int(1) NOT NULL DEFAULT '0' COMMENT '是否默认收获地址 0=否 1=是',
  `sex` int(1) DEFAULT '0' COMMENT '联系人性别 0=无 1=先生 2=女士',
  `house_number` varchar(100) DEFAULT NULL COMMENT '门牌号',
  `longitude` decimal(18,6) DEFAULT NULL COMMENT '经度',
  `latitude` decimal(18,6) DEFAULT NULL COMMENT '纬度',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=611 DEFAULT CHARSET=utf8 COMMENT='收货地址表';

-- ----------------------------
-- Table structure for tb_mall_coupons
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_coupons`;
CREATE TABLE `tb_mall_coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(100) DEFAULT NULL COMMENT '优惠卷名称',
  `preferential_type` int(11) DEFAULT NULL COMMENT '优惠类型，1=折扣，2=满减',
  `discount_amount` decimal(10,2) DEFAULT '1.00' COMMENT '折扣额度',
  `limited_price` decimal(10,2) DEFAULT '0.00' COMMENT '满足价格（元，满足该价格才能使用）',
  `reduced_price` decimal(10,2) DEFAULT '0.00' COMMENT '减价额度(元)',
  `description` varchar(500) DEFAULT NULL COMMENT '使用规则描述',
  `valid_type` int(1) NOT NULL DEFAULT '2' COMMENT '时效:1绝对时效（领取后XXX-XXX时间段有效）  2相对时效（领取后N天有效）',
  `valid_start_time` datetime DEFAULT NULL COMMENT '使用开始时间',
  `valid_end_time` datetime DEFAULT NULL COMMENT '使用结束时间',
  `valid_days` int(3) NOT NULL DEFAULT '0' COMMENT '自领取之日起有效天数',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否被删除，0-否，1-是',
  `source` int(2) DEFAULT NULL COMMENT '优惠券发放来源 1=商家中心 2=调度中心',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_coupons_goods_relation
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_coupons_goods_relation`;
CREATE TABLE `tb_mall_coupons_goods_relation` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `coupons_id` int(11) DEFAULT NULL COMMENT '优惠卷id',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_coupons_member_relation
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_coupons_member_relation`;
CREATE TABLE `tb_mall_coupons_member_relation` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `coupons_id` int(11) DEFAULT NULL COMMENT '优惠卷id',
  `coupons_name` varchar(100) DEFAULT NULL COMMENT '优惠卷名称',
  `member_id` int(11) DEFAULT NULL COMMENT '用户id',
  `start_time` datetime DEFAULT NULL COMMENT '生效时间',
  `end_time` datetime DEFAULT NULL COMMENT '过期时间',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '是否已经使用，0=未使用，1=已使用',
  `is_expired` tinyint(1) DEFAULT '0' COMMENT '是否过期，0=未过期，1=已过期',
  `is_valid` tinyint(1) DEFAULT '1' COMMENT '是否有效，0-否，1-是',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1318 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_full_reduction_rule
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_full_reduction_rule`;
CREATE TABLE `tb_mall_full_reduction_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` int(11) DEFAULT NULL COMMENT '店铺id',
  `name` varchar(100) DEFAULT NULL COMMENT '规则名称',
  `status` int(11) DEFAULT NULL COMMENT '活动状态，1=开启，2=关闭',
  `limited_price` decimal(10,2) DEFAULT '0.00' COMMENT '满足价格（元，满足该价格才能使用）',
  `reduced_price` decimal(10,2) DEFAULT '0.00' COMMENT '减价额度(元)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_goods
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_goods`;
CREATE TABLE `tb_mall_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` int(11) DEFAULT NULL COMMENT '店铺id',
  `name` varchar(50) NOT NULL COMMENT '商品名称',
  `main_image` varchar(128) DEFAULT NULL COMMENT '商品主图',
  `sub_images` varchar(1024) DEFAULT NULL COMMENT '商品子图',
  `detail` varchar(1024) DEFAULT NULL COMMENT '商品详情',
  `detail_images` varchar(1024) DEFAULT NULL COMMENT '详情图片',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '一口价',
  `stock` int(11) DEFAULT '0' COMMENT '库存',
  `is_hot` tinyint(1) DEFAULT '0' COMMENT '是否热门',
  `is_new` tinyint(1) DEFAULT '0' COMMENT '是否新品',
  `status` int(2) DEFAULT '1' COMMENT '状态 1=待上架 2=已上架 3=已下架 4=售罄',
  `is_sale` tinyint(1) unsigned DEFAULT '0' COMMENT '是否开启促销 0-否 1-是',
  `sale_price` decimal(10,2) DEFAULT '0.00' COMMENT '折扣价',
  `monthly_sales` int(11) DEFAULT '0' COMMENT '月销量',
  `total_sales` int(11) DEFAULT '0' COMMENT '累计销量',
  `total_comments` int(11) DEFAULT '0' COMMENT '累计评价',
  `preferential_name` varchar(20) DEFAULT NULL COMMENT '优惠名称',
  `packing_charges` decimal(10,2) DEFAULT '0.00' COMMENT '包装费',
  `product_time` decimal(10,2) DEFAULT '0.00' COMMENT '制作时长(分钟)',
  `exchange_points` int(10) DEFAULT NULL COMMENT '兑换商品所需积分数量',
  `sort_number` int(11) DEFAULT NULL COMMENT '排序号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_goods_specification
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_goods_specification`;
CREATE TABLE `tb_mall_goods_specification` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `name` varchar(10) NOT NULL COMMENT '商品规格名称',
  `sort_number` int(11) DEFAULT NULL COMMENT '排序号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_goods_specification_option
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_goods_specification_option`;
CREATE TABLE `tb_mall_goods_specification_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `goods_specification_id` int(11) NOT NULL COMMENT '商品规格id',
  `name` varchar(10) NOT NULL COMMENT '商品规格选项名称',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '单价/加价金额',
  `stock` int(11) DEFAULT '1' COMMENT '库存 1=有货 2=无货',
  `sort_number` int(11) DEFAULT NULL COMMENT '排序号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_member_goods_collect
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_member_goods_collect`;
CREATE TABLE `tb_mall_member_goods_collect` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) DEFAULT NULL COMMENT '用户id',
  `shop_id` int(11) DEFAULT NULL COMMENT '店铺id',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品id',
  `is_goods_exists` tinyint(1) DEFAULT '1' COMMENT '商品是否有效 0=无效 1=有效',
  `is_buy` tinyint(1) DEFAULT '0' COMMENT '商品是否购买 0=未购买 1=已购买',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_mall_menu
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_menu`;
CREATE TABLE `tb_mall_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` int(11) DEFAULT NULL COMMENT '店铺id',
  `name` varchar(50) CHARACTER SET utf8mb4 NOT NULL COMMENT '菜单分类名称',
  `description` varchar(512) COLLATE utf8_bin DEFAULT NULL COMMENT '菜单分类描述',
  `sort_number` int(11) DEFAULT NULL COMMENT '排序号',
  `icon` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT '菜单图标',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_mall_menu_goods_relation
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_menu_goods_relation`;
CREATE TABLE `tb_mall_menu_goods_relation` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `menu_id` int(11) NOT NULL COMMENT '菜单分类id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_mall_order
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_order`;
CREATE TABLE `tb_mall_order` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(50) NOT NULL COMMENT '订单编号，供客户查询',
  `goods_total_quantity` int(11) DEFAULT '0' COMMENT '商品总数量',
  `goods_total_price` decimal(10,2) DEFAULT '0.00' COMMENT '商品总金额',
  `packing_charges` decimal(10,2) DEFAULT NULL COMMENT '包装费',
  `delivery_fee` decimal(10,2) DEFAULT '0.00' COMMENT '运费/配送费',
  `actual_price` decimal(10,2) DEFAULT '0.00' COMMENT '实付款',
  `shopping_way` int(2) DEFAULT NULL COMMENT '购物方式 1=自取 2=配送',
  `delivery_address_id` int(11) DEFAULT NULL COMMENT '收货地址id',
  `contact_realname` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `contact_province` varchar(20) DEFAULT NULL COMMENT '省份',
  `contact_city` varchar(20) DEFAULT NULL COMMENT '城市',
  `contact_area` varchar(100) DEFAULT NULL COMMENT '区/县',
  `contact_street` varchar(100) DEFAULT NULL COMMENT '详细地址(具体到街道门牌号)',
  `contact_sex` int(1) DEFAULT '0' COMMENT '联系人性别 0=无 1=先生 2=女士',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `description` varchar(2048) DEFAULT NULL COMMENT '订单描述',
  `status` int(2) DEFAULT '1' COMMENT '订单状态 1=未付款 4=待发货(已处理) 5=已发货 6=已完成 7=售后处理中 8=已退款(废弃选项) 9=售后处理完成 10=已取消(未支付)',
  `trade_id` int(11) DEFAULT NULL COMMENT '用户交易id',
  `order_logistics_id` int(11) DEFAULT NULL COMMENT '物流id',
  `is_invoice` tinyint(1) DEFAULT '0' COMMENT '是否开票',
  `invoice_id` int(11) DEFAULT NULL COMMENT '发票id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0=正常 1=删除',
  `shop_id` int(11) DEFAULT NULL COMMENT '接单门店id',
  `shop_name` varchar(100) DEFAULT NULL COMMENT '接单门店名称',
  `shop_address` varchar(200) DEFAULT NULL COMMENT '门店地址',
  `cancel_reason` int(2) DEFAULT NULL COMMENT '(未支付)订单取消原因 1=您主动取消 2=订单超时未支付 3=系统异常',
  `payment_deadline` datetime DEFAULT NULL COMMENT '支付截止时间(五分钟内未付款的订单会被自动关闭)',
  `is_printed` tinyint(1) DEFAULT '0' COMMENT '是否已打印',
  `queue_no` int(11) DEFAULT NULL COMMENT '取餐号',
  `full_reduction_rule_id` int(11) DEFAULT NULL COMMENT '使用的满减id',
  `full_reduction_rule_description` varchar(100) DEFAULT NULL COMMENT '使用的满减规则描述',
  `coupons_id` int(11) DEFAULT NULL COMMENT '使用的优惠卷id',
  `coupons_description` varchar(100) DEFAULT NULL COMMENT '使用的优惠卷描述',
  `coupons_member_relation_id` int(11) DEFAULT NULL COMMENT '优惠卷用户关系id',
  `is_change_to_delivery` tinyint(1) DEFAULT '0' COMMENT '是否由自取订单改为配送 0=否 1=是',
  `change_to_delivery_out_trade_no` varchar(50) DEFAULT NULL COMMENT '自取订单改为配送的商户单号',
  `change_to_delivery_trade_id` int(11) DEFAULT NULL COMMENT '自取订单改为配送的用户交易id',
  `platform_extract_ratio` decimal(10,2) DEFAULT '0.00' COMMENT '平台抽取比例(%)',
  `platform_extract_price` decimal(10,2) DEFAULT '0.00' COMMENT '平台抽取金额',
  `platform_delivery_fee` decimal(10,2) DEFAULT '0.00' COMMENT '平台承担配送费',
  `platform_income` decimal(10,2) DEFAULT '0.00' COMMENT '平台实际收入',
  `merchant_delivery_fee` decimal(10,2) DEFAULT '0.00' COMMENT '商家承担配送费',
  `courier_income` decimal(10,2) DEFAULT '0.00' COMMENT '骑手实际收入',
  `merchant_income` decimal(10,2) DEFAULT '0.00' COMMENT '商家实际收入',
  `payment_success_time` datetime DEFAULT NULL COMMENT '支付成功时间',
  `order_completion_time` datetime DEFAULT NULL COMMENT '订单完成时间',
  `paid_order_cancel_reason` int(2) DEFAULT NULL COMMENT '(废弃字段)(已支付)订单取消原因 1=信息填写错误 2=送达时间选错了 3=买错了/买少了 4=商家缺货 5=商家联系我取消 6=配送太慢 7=骑手联系我取消 8=我不想要了',
  `limited_price` decimal(10,2) DEFAULT '0.00' COMMENT '满足价格(元)',
  `reduced_price` decimal(10,2) DEFAULT '0.00' COMMENT '减价额度(元)',
  `coupons_discount_price` decimal(10,2) DEFAULT '0.00' COMMENT '优惠券折扣金额/优惠券优惠金额',
  `delivery_way` int(2) DEFAULT NULL COMMENT '配送方式 1=商家自配送',
  `is_pay_to_merchant` tinyint(1) DEFAULT '0' COMMENT '用户下单资金是否已转入商家余额 0=否 1=是',
  `before_reduced_delivery_fee` decimal(10,2) DEFAULT '0.00' COMMENT '立减之前需要支付的运费/配送费',
  `payment_mode` int(2) DEFAULT NULL COMMENT '支付方式 1=微信支付 (2=平台余额) 3=平台积分',
  `logistics_way` varchar(50) DEFAULT NULL COMMENT '物流方式/快递公司名称',
  `logistics_no` varchar(50) DEFAULT NULL COMMENT '物流编号/快递单号',
  `courier_name` varchar(50) DEFAULT NULL COMMENT '快递员/快递站名称',
  `courier_phone` varchar(11) DEFAULT NULL COMMENT '快递员电话',
  `delivery_status` int(2) DEFAULT NULL COMMENT '快递状态 0=快递收件(揽件) 1=在途中 2=正在派件 3=已签收 4=派送失败 5=疑难件 6=退件签收',
  `is_sign` tinyint(1) DEFAULT NULL COMMENT '是否签收',
  `delivery_last_update_time` datetime DEFAULT NULL COMMENT '快递轨迹信息最新时间',
  `take_time` varchar(50) DEFAULT NULL COMMENT '发货到收货消耗时长 (截止最新轨迹)',
  `contact_house_number` varchar(100) DEFAULT NULL COMMENT '门牌号',
  `contact_longitude` decimal(18,6) DEFAULT NULL COMMENT '经度',
  `contact_latitude` decimal(18,6) DEFAULT NULL COMMENT '纬度',
  `first_goods_main_image` varchar(128) DEFAULT NULL COMMENT '第一件商品的主图',
  `goods_source` int(2) DEFAULT NULL COMMENT '发货源 1=拼多多 2=淘宝 3=京东',
  `goods_source_order_no` varchar(50) DEFAULT NULL COMMENT '发货源订单编号',
  `platform_remark` varchar(1024) DEFAULT NULL COMMENT '平台备注',
  `create_time` datetime DEFAULT NULL COMMENT '下单时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_order_detail`;
CREATE TABLE `tb_mall_order_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_id` bigint(11) NOT NULL COMMENT '订单id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `goods_name` varchar(50) NOT NULL COMMENT '商品名称',
  `main_image` varchar(128) NOT NULL COMMENT '商品主图',
  `spec_list` varchar(1024) DEFAULT NULL COMMENT '商品规格 JSON数据',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '价格',
  `number` int(11) DEFAULT '0' COMMENT '购买数量',
  `subtotal` decimal(10,2) DEFAULT '0.00' COMMENT '小计',
  `packing_charges` decimal(10,2) DEFAULT '0.00' COMMENT '单件商品的包装费',
  `is_used_coupons` tinyint(1) DEFAULT '0' COMMENT '该商品是否使用了优惠券 0=否 1=是',
  `coupons_discount_price` decimal(10,2) DEFAULT '0.00' COMMENT '优惠券折扣金额/优惠券优惠金额',
  `after_coupons_discount_price` decimal(10,2) DEFAULT '0.00' COMMENT '优惠券折扣之后的商品价格',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0=正常 1=删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_order_logistics
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_order_logistics`;
CREATE TABLE `tb_mall_order_logistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_id` bigint(11) NOT NULL COMMENT '订单id',
  `description` varchar(200) DEFAULT NULL COMMENT '物流状态描述',
  `description_time` datetime DEFAULT NULL COMMENT '物流状态描述对应的时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_order_refund`;
CREATE TABLE `tb_mall_order_refund` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_id` bigint(11) NOT NULL COMMENT '订单id',
  `type` int(2) DEFAULT '1' COMMENT '退款类型 1=未发货订单申请退款 2=已发货订单申请售后-仅退款 3=已发货订单申请售后-退货退款',
  `refund_way` int(2) DEFAULT '1' COMMENT '退款方式 1=全额退款 2=部分退款',
  `refund_reason` int(2) DEFAULT NULL COMMENT '退款原因 1=订单信息拍错（规格/尺码/颜色等） 2=我不想要了 3=地址/电话信息填写错误 4=没用/少用优惠 5=缺货 31=缺货 32=协商一致退款 33=未按约定时间发货 34=排错/多拍/不想要 35=其他 61=效果不好/不喜欢 62=材质不符 63=尺寸不符 64=外观破损 65=颜色/款式图案与描述不符 66=物流问题 67=和预期不符 68=服务承诺/态度 69=质量问题 70=其他',
  `refund_reason_description` varchar(1024) DEFAULT NULL COMMENT '退款原因详细描述',
  `evidence_images` varchar(1024) DEFAULT NULL COMMENT '凭证图片',
  `refund_amount` decimal(10,2) DEFAULT '0.00' COMMENT '退款金额',
  `refund_account` int(2) DEFAULT NULL COMMENT '退款账户 1=微信 2=支付宝 3=平台余额 4=平台积分',
  `status` int(2) DEFAULT '1' COMMENT '退款状态 1=退款申请已提交 4=等待平台处理 5=平台拒绝退款，退款已关闭 7=退款成功',
  `goods_total_quantity` int(11) DEFAULT '0' COMMENT '退还商品总数量',
  `goods_total_price` decimal(10,2) DEFAULT '0.00' COMMENT '退还商品总金额',
  `packing_charges` decimal(10,2) DEFAULT '0.00' COMMENT '退还包装费',
  `is_refund_delivery_fee` tinyint(1) DEFAULT '0' COMMENT '是否退还了配送费 0=否 1=是',
  `delivery_fee` decimal(10,2) DEFAULT '0.00' COMMENT '退还运费/配送费',
  `is_used_coupons` tinyint(1) DEFAULT '0' COMMENT '退款商品中是否使用了优惠券 0=否 1=是',
  `is_used_full_reduction_rule` tinyint(1) DEFAULT '0' COMMENT '退款商品中是否使用了满减规则 0=否 1=是',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_order_refund_goods
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_order_refund_goods`;
CREATE TABLE `tb_mall_order_refund_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_refund_id` int(11) NOT NULL COMMENT '订单退款id',
  `order_detail_id` int(11) NOT NULL COMMENT '订单商品详情id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `goods_name` varchar(50) NOT NULL COMMENT '商品名称',
  `main_image` varchar(128) NOT NULL COMMENT '商品主图',
  `spec_list` varchar(1024) DEFAULT NULL COMMENT '商品规格 JSON数据',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '价格',
  `number` int(11) DEFAULT '0' COMMENT '退款数量',
  `subtotal` decimal(10,2) DEFAULT '0.00' COMMENT '小计',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_order_refund_process
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_order_refund_process`;
CREATE TABLE `tb_mall_order_refund_process` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `order_refund_id` int(11) NOT NULL COMMENT '订单退款id',
  `name` varchar(50) NOT NULL COMMENT '流程名称',
  `description` varchar(200) DEFAULT NULL COMMENT '流程描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_mall_shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `tb_mall_shopping_cart`;
CREATE TABLE `tb_mall_shopping_cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `shop_id` int(11) DEFAULT NULL COMMENT '店铺id',
  `spec_list` varchar(1024) DEFAULT NULL COMMENT '商品规格 JSON数据',
  `number` int(11) DEFAULT '1' COMMENT '购买数量',
  `is_goods_exists` tinyint(1) DEFAULT '1' COMMENT '商品是否有效 0=无效 1=有效',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_member
-- ----------------------------
DROP TABLE IF EXISTS `tb_member`;
CREATE TABLE `tb_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `username` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '用户名',
  `mobile` varchar(11) NOT NULL COMMENT '手机号',
  `password` varchar(100) DEFAULT NULL COMMENT '密码',
  `password_salt` varchar(100) DEFAULT NULL COMMENT '密码盐值',
  `nickname` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '昵称(废弃字段)',
  `balance` decimal(10,2) DEFAULT '0.00' COMMENT '余额',
  `login_count` int(11) NOT NULL DEFAULT '0' COMMENT '登陆次数',
  `invite_code` varchar(10) DEFAULT NULL COMMENT '邀请码',
  `head_img` varchar(256) DEFAULT NULL COMMENT '头像',
  `roles` varchar(128) DEFAULT NULL COMMENT '权限',
  `sex` int(2) DEFAULT '0' COMMENT '性别 0=无 1=男 2=女',
  `email` varchar(50) DEFAULT NULL COMMENT '电子邮箱',
  `is_disabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否禁用 0=启用 1=禁用',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0=正常 1=删除',
  `open_id` varchar(50) DEFAULT NULL COMMENT '微信小程序openId',
  `is_bind_wx` tinyint(1) DEFAULT '0' COMMENT '是否绑定微信 0=否 1=是',
  `points` decimal(10,2) DEFAULT '0.00' COMMENT '积分',
  `vip_status` int(2) DEFAULT '0' COMMENT '会员状态 0=无/非会员 1=正常 2=禁用 3=已过期(预留字段)',
  `vip_type` int(2) DEFAULT '0' COMMENT '会员类型 0=无 1=超级会员 2=黄金会员 3=钻石会员(预留字段)',
  `vip_start_time` datetime DEFAULT NULL COMMENT '会员开始时间(预留字段)',
  `vip_end_time` datetime DEFAULT NULL COMMENT '会员结束时间(预留字段)',
  `type` int(2) DEFAULT '1' COMMENT '用户类型 1=普通用户 2=VIP会员',
  `vip_no` varchar(50) DEFAULT NULL COMMENT '会员编号',
  `is_new_people` tinyint(1) DEFAULT '1' COMMENT '是否为新用户 0=否 1=是',
  `is_remind_new_people` tinyint(1) DEFAULT '1' COMMENT '是否需要弹出新人引导提示 0=否 1=是',
  `last_use_time` datetime DEFAULT NULL COMMENT '最后使用/进入小程序的时间',
  `last_use_address` varchar(200) DEFAULT NULL COMMENT '最后使用/进入小程序的定位地址',
  `register_way` int(2) DEFAULT NULL COMMENT '注册方式 1=微信一键登录 2=手机验证码 3=邀请注册',
  `wx_public_platform_open_id` varchar(50) DEFAULT NULL COMMENT '微信公众号openId',
  `is_request_wx_notify` tinyint(1) DEFAULT '1' COMMENT '是否需要请求授权服务通知 0=否 1=是',
  `last_request_wx_notify_time` datetime DEFAULT NULL COMMENT '上一次请求授权服务通知时间',
  `invite_reward_amount` decimal(10,2) DEFAULT '0.00' COMMENT '邀请新用户注册奖励金额',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `total_balance` decimal(10,2) DEFAULT '0.00' COMMENT '累计余额',
  `total_consume_balance` decimal(10,2) DEFAULT '0.00' COMMENT '累计消费余额',
  `total_points` decimal(10,2) DEFAULT '0.00' COMMENT '累计积分',
  `total_consume_points` decimal(10,2) DEFAULT '0.00' COMMENT '累计消费积分',
  `total_withdraw_invite_reward_amount` decimal(10,2) DEFAULT '0.00' COMMENT '累积已提邀请新用户注册奖励金额',
  `payment_password` varchar(100) DEFAULT NULL COMMENT '支付密码',
  `payment_password_salt` varchar(100) DEFAULT NULL COMMENT '支付密码盐值',
  `invite_suncode` varchar(256) DEFAULT NULL COMMENT '邀请分享-微信小程序太阳码',
  `unreceived_points` decimal(10,2) DEFAULT '0.00' COMMENT '未到账-积分',
  `unreceived_invite_reward_amount` decimal(10,2) DEFAULT '0.00' COMMENT '未到账-邀请新用户注册奖励金额',
  `create_time` datetime DEFAULT NULL COMMENT '注册时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Table structure for tb_member_billing_record
-- ----------------------------
DROP TABLE IF EXISTS `tb_member_billing_record`;
CREATE TABLE `tb_member_billing_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `type` int(2) NOT NULL COMMENT '账单类型 1=积分兑换商品 2=下单奖励积分 3=新用户注册赠送积分 4=会员充值奖励余额 5=邀请新用户注册获得奖励金额 6=邀请新用户注册奖励金额提现 7=邀请新用户注册奖励金额提现失败退回 8=一级邀请人佣金奖励 9=二级邀请人佣金奖励 10=下单用户佣金奖励 11=新用户注册赠送奖励金额 12=订单使用余额支付 13=一分钟内取消订单-余额退回 14=用户申请退款-余额退回 15=商城订单使用积分支付 16=未发货订单申请退款-积分退回 17=已发货订单申请退款-积分退回 18=会员充值原价金额同等转入余额 19=订单退款-下单奖励积分退回 20=订单退款-一级邀请人佣金奖励退回 21=订单退款-二级邀请人佣金奖励退回 22=订单退款-下单用户佣金奖励退回',
  `operate_type` int(2) NOT NULL COMMENT '操作类型 1=加 2=减',
  `coin_type` int(2) NOT NULL COMMENT '货币类型 1=积分 2=余额 3=邀请新用户注册奖励金额 4=未到账-积分 5=未到账-邀请新用户注册奖励金额',
  `number` decimal(10,2) NOT NULL COMMENT '增减的数值',
  `service_fee` decimal(10,2) DEFAULT NULL COMMENT '服务费',
  `message` varchar(200) DEFAULT NULL COMMENT '账单信息',
  `order_id` int(11) DEFAULT NULL COMMENT '外卖系统订单id',
  `points_mall_order_id` int(11) DEFAULT NULL COMMENT '商城订单id',
  `is_return` tinyint(1) DEFAULT '0' COMMENT '账单金额是否被退回',
  `is_settled` tinyint(1) DEFAULT '0' COMMENT '账单金额是否已发放/已结算',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=376 DEFAULT CHARSET=utf8 COMMENT='用户账单记录表';

-- ----------------------------
-- Table structure for tb_member_goods_collect
-- ----------------------------
DROP TABLE IF EXISTS `tb_member_goods_collect`;
CREATE TABLE `tb_member_goods_collect` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) DEFAULT NULL COMMENT '用户id',
  `shop_id` int(11) DEFAULT NULL COMMENT '店铺id',
  `goods_id` int(11) DEFAULT NULL COMMENT '商品id',
  `is_goods_exists` tinyint(1) DEFAULT '1' COMMENT '商品是否有效 0=无效 1=有效',
  `is_buy` tinyint(1) DEFAULT '0' COMMENT '商品是否购买 0=未购买 1=已购买',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tb_member_invite_relation
-- ----------------------------
DROP TABLE IF EXISTS `tb_member_invite_relation`;
CREATE TABLE `tb_member_invite_relation` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) DEFAULT NULL COMMENT '被邀请用户id',
  `inviter_id` int(11) DEFAULT NULL COMMENT '邀请者id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户邀请关系表’';

-- ----------------------------
-- Table structure for tb_member_trade_record
-- ----------------------------
DROP TABLE IF EXISTS `tb_member_trade_record`;
CREATE TABLE `tb_member_trade_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) DEFAULT NULL COMMENT '用户id',
  `merchant_id` int(11) DEFAULT NULL COMMENT '商家账号id',
  `out_trade_no` varchar(50) DEFAULT NULL COMMENT '商户单号(网站平台的订单号)',
  `trade_no` varchar(50) DEFAULT NULL COMMENT '交易单号(支付平台的订单号)',
  `type` int(2) DEFAULT '1' COMMENT '交易类型 1=用户订单付款 2=用户会员充值 3=用户自取订单改为配送 4=商家余额提现 5=邀请新用户注册奖励金额提现 6=用户商城订单付款',
  `payment_mode` int(2) DEFAULT NULL COMMENT '支付方式 1=微信 2=支付宝 3=平台余额 4=平台积分',
  `amount` decimal(10,2) DEFAULT '0.00' COMMENT '金额',
  `status` int(2) DEFAULT '1' COMMENT '交易状态 1=待支付 2=支付成功 3=支付失败 4=交易超时自动关闭',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COMMENT='平台交易记录表';

-- ----------------------------
-- Table structure for tb_member_withdraw_record
-- ----------------------------
DROP TABLE IF EXISTS `tb_member_withdraw_record`;
CREATE TABLE `tb_member_withdraw_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(50) NOT NULL COMMENT '订单编号，供客户查询',
  `coin_type` int(2) NOT NULL COMMENT '货币类型 1=邀请新用户注册奖励金额',
  `withdraw_amount` decimal(10,2) NOT NULL COMMENT '提现金额',
  `platform_fee` decimal(10,2) NOT NULL COMMENT '平台手续费/服务费',
  `actual_amount` decimal(10,2) DEFAULT NULL COMMENT '实际到账金额',
  `audit_status` int(2) NOT NULL DEFAULT '1' COMMENT '审核状态 1=平台处理中 2=到账成功 3=审核不通过',
  `audit_reason` varchar(50) DEFAULT NULL COMMENT '审核不通过原因',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `payment_mode` int(2) DEFAULT NULL COMMENT '打款方式/到账方式 1=微信 2=支付宝 3=银行',
  `opening_bank_address` varchar(50) DEFAULT NULL COMMENT '开户行',
  `opening_bank_name` varchar(50) DEFAULT NULL COMMENT '开户银行名称',
  `bank_card` varchar(50) DEFAULT NULL COMMENT '银行卡号',
  `alipay_account` varchar(50) DEFAULT NULL COMMENT '支付宝账号',
  `wechat_account` varchar(50) DEFAULT NULL COMMENT '微信账号',
  `trade_id` int(11) DEFAULT NULL COMMENT '用户交易id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tb_message
-- ----------------------------
DROP TABLE IF EXISTS `tb_message`;
CREATE TABLE `tb_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int(11) DEFAULT NULL COMMENT '用户id',
  `user_type` int(2) NOT NULL COMMENT '消息用户类型 1=用户 2=商家 3=管理员',
  `title` varchar(255) DEFAULT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读 0=未读 1=已读',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统消息表';

-- ----------------------------
-- Table structure for tb_paperwork_push
-- ----------------------------
DROP TABLE IF EXISTS `tb_paperwork_push`;
CREATE TABLE `tb_paperwork_push` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(50) NOT NULL COMMENT '文案名称',
  `content` text COMMENT '文案内容',
  `pushed_number` int(11) DEFAULT '0' COMMENT '已推送次数',
  `last_pushed_time` datetime DEFAULT NULL COMMENT '上次推送时间',
  `sort_number` int(11) DEFAULT NULL COMMENT '排序号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tb_picture_upload_record
-- ----------------------------
DROP TABLE IF EXISTS `tb_picture_upload_record`;
CREATE TABLE `tb_picture_upload_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` int(11) DEFAULT NULL COMMENT '店铺id',
  `url` varchar(128) DEFAULT NULL COMMENT '图片地址(相对路径)',
  `module` int(2) DEFAULT NULL COMMENT '所属模块 1=商品模块',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tb_scheduled_task
-- ----------------------------
DROP TABLE IF EXISTS `tb_scheduled_task`;
CREATE TABLE `tb_scheduled_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(50) NOT NULL COMMENT '任务名称',
  `code` varchar(256) NOT NULL COMMENT '任务代码',
  `frequency` varchar(50) NOT NULL COMMENT '执行频率',
  `state` int(2) DEFAULT '1' COMMENT '执行状态 1=未执行 2=正在执行',
  `last_start_time` datetime DEFAULT NULL COMMENT '最后执行开始时间',
  `last_end_time` datetime DEFAULT NULL COMMENT '最后执行结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='定时任务表';

-- ----------------------------
-- Table structure for tb_scheduled_task_log
-- ----------------------------
DROP TABLE IF EXISTS `tb_scheduled_task_log`;
CREATE TABLE `tb_scheduled_task_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `scheduled_task_code` varchar(256) NOT NULL COMMENT '任务代码',
  `state` int(2) NOT NULL DEFAULT '1' COMMENT '执行状态 1=执行成功 2=执行出错',
  `error` varchar(1024) DEFAULT NULL COMMENT '错误描述',
  `host_name` varchar(50) NOT NULL COMMENT '执行主机名称',
  `host_ip_address` varchar(50) NOT NULL COMMENT '执行主机ip地址',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='定时任务执行日志表';

-- ----------------------------
-- Table structure for tb_setting
-- ----------------------------
DROP TABLE IF EXISTS `tb_setting`;
CREATE TABLE `tb_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `purchase_reward_points` decimal(10,2) DEFAULT '0.00' COMMENT '购买一杯奶茶赠送积分数量',
  `registration_reward_points` decimal(10,2) DEFAULT '0.00' COMMENT '新用户注册奖励积分数量',
  `new_member_coupons_id` int(11) DEFAULT NULL COMMENT '(废弃字段)新人优惠卷id',
  `merchant_withdraw_fee` decimal(10,2) NOT NULL COMMENT '商家提现手续费(%)',
  `start_delivery_price` decimal(10,2) DEFAULT '0.00' COMMENT '系统默认起送价格',
  `delivery_starting_distance` decimal(10,2) DEFAULT '0.00' COMMENT '配送起步距离(KM)',
  `delivery_starting_price` decimal(10,2) DEFAULT '0.00' COMMENT '配送起步价',
  `delivery_kilometer_price` decimal(10,2) DEFAULT '0.00' COMMENT '配送公里价(元/KM)',
  `delivery_distance_limit` decimal(10,2) DEFAULT '0.00' COMMENT '配送距离上限(KM)',
  `order_system_extraction_ratio` decimal(10,2) DEFAULT NULL COMMENT '用户下单系统抽佣比例(%)',
  `merchant_meal_preparation_time` decimal(10,2) DEFAULT NULL COMMENT '商家备餐时间(分钟)',
  `member_withdraw_fee` decimal(10,2) NOT NULL COMMENT '用户提现手续费(%)',
  `registration_reward_invite_reward_amount` decimal(10,2) NOT NULL COMMENT '新用户注册奖励-邀请新用户注册奖励金额',
  `member_withdraw_meet_amount` decimal(10,2) NOT NULL COMMENT '奖励金累计到(≥)XX元可以提现/用户的邀请新用户注册奖励金额满足多少方可提现',
  `member_withdraw_audit_threshold` decimal(10,2) NOT NULL COMMENT '用户提现金额达到(≥)XX元需要人工审核/用户提现金额需审核门槛/用户的邀请新用户注册奖励金额高于多少时需要审核(不包含该金额)',
  `customer_service_phone` varchar(11) DEFAULT NULL COMMENT '客服电话',
  `customer_service_wechat` varchar(50) DEFAULT NULL COMMENT '客服微信',
  `customer_service_wechat_qrcode` varchar(1024) DEFAULT NULL COMMENT '客服微信二维码',
  `freight_insurance_paid_amount` decimal(10,2) DEFAULT NULL COMMENT '(预留字段)运费险赔付金额',
  `invitee_consume_commission` decimal(10,2) NOT NULL COMMENT '被邀请注册的用户下单后，平台邀请佣金占订单金额的百分比(%)--该佣金发放到邀请人的邀请新用户注册奖励金额',
  `caseone_own_commission` decimal(10,2) NOT NULL COMMENT '无上级邀请人时，下单用户佣金占比(%)',
  `casetwo_own_commission` decimal(10,2) NOT NULL COMMENT '有1个上级邀请人时，下单用户佣金占比(%)',
  `casetwo_first_level_inviter_commission` decimal(10,2) NOT NULL COMMENT '有1个上级邀请人时，一级邀请人佣金占比(%)',
  `casethree_own_commission` decimal(10,2) NOT NULL COMMENT '有2个上级邀请人，下单用户佣金占比(%)',
  `casethree_first_level_inviter_commission` decimal(10,2) NOT NULL COMMENT '有2个上级邀请人，一级邀请人佣金占比(%)',
  `casethree_second_level_inviter_commission` decimal(10,2) NOT NULL COMMENT '有2个上级邀请人，二级邀请人佣金占比(%)',
  `points_mall_invitee_consume_commission` decimal(10,2) NOT NULL COMMENT '商城--被邀请注册的用户下单后，平台邀请佣金占订单金额的百分比(%)--该佣金发放到邀请人的邀请新用户注册奖励金额',
  `points_mall_caseone_own_commission` decimal(10,2) NOT NULL COMMENT '商城--无上级邀请人时，下单用户佣金占比(%)',
  `points_mall_casetwo_own_commission` decimal(10,2) NOT NULL COMMENT '商城--有1个上级邀请人时，下单用户佣金占比(%)',
  `points_mall_casetwo_first_level_inviter_commission` decimal(10,2) NOT NULL COMMENT '商城--有1个上级邀请人时，一级邀请人佣金占比(%)',
  `points_mall_casethree_own_commission` decimal(10,2) NOT NULL COMMENT '商城--有2个上级邀请人，下单用户佣金占比(%)',
  `points_mall_casethree_first_level_inviter_commission` decimal(10,2) NOT NULL COMMENT '商城--有2个上级邀请人，一级邀请人佣金占比(%)',
  `points_mall_casethree_second_level_inviter_commission` decimal(10,2) NOT NULL COMMENT '商城--有2个上级邀请人，二级邀请人佣金占比(%)',
  `invite_friends_activity_rule` text COMMENT '分享邀请好友-活动规则',
  `commission_rule` text COMMENT '佣金奖励规则',
  `vip_rule` text COMMENT '会员规则',
  `shop_management_mode` int(2) DEFAULT '2' COMMENT '门店经营模式 1=单门店 2=多门店',
  `default_shop_id` int(11) DEFAULT NULL COMMENT '单门店时，默认接单的门店',
  `province` varchar(20) DEFAULT NULL COMMENT '省份',
  `city` varchar(20) DEFAULT NULL COMMENT '城市',
  `area` varchar(100) DEFAULT NULL COMMENT '区/县',
  `street` varchar(50) DEFAULT NULL COMMENT '详细地址',
  `realname` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '联系人姓名',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='基础数据设置表';

-- ----------------------------
-- Table structure for tb_sms_log
-- ----------------------------
DROP TABLE IF EXISTS `tb_sms_log`;
CREATE TABLE `tb_sms_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) DEFAULT NULL COMMENT '用户id',
  `mobile` varchar(11) NOT NULL COMMENT '手机号',
  `type` varchar(20) DEFAULT NULL COMMENT '短信类型 注册=register 登录=login 验证手机号=verification 找回密码=findpwd 自提提醒=extractRemind',
  `verify_code` varchar(10) DEFAULT NULL COMMENT '短信验证码',
  `ip` varchar(15) NOT NULL COMMENT '请求ip',
  `state` int(2) NOT NULL DEFAULT '1' COMMENT '发送状态 1=发送成功 2=发送失败',
  `description` varchar(50) DEFAULT NULL COMMENT 'API调用返回信息',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='短信验证码记录表';

-- ----------------------------
-- Table structure for tb_system_usage_record
-- ----------------------------
DROP TABLE IF EXISTS `tb_system_usage_record`;
CREATE TABLE `tb_system_usage_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) DEFAULT NULL COMMENT '用户id',
  `shop_id` int(11) DEFAULT NULL COMMENT '店铺id',
  `type` varchar(20) DEFAULT NULL COMMENT '类型 intoShop=进入店铺 intoPointsMall=进入商城',
  `ip` varchar(15) DEFAULT NULL COMMENT '请求ip',
  `imei` varchar(100) DEFAULT NULL COMMENT '国际移动设备标识',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3486 DEFAULT CHARSET=utf8 COMMENT='系统使用记录表';

-- ----------------------------
-- Table structure for tb_vip_recharge_denomination
-- ----------------------------
DROP TABLE IF EXISTS `tb_vip_recharge_denomination`;
CREATE TABLE `tb_vip_recharge_denomination` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(50) DEFAULT NULL COMMENT '充值面额名称(预留字段)',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '售价',
  `is_sale` tinyint(1) unsigned DEFAULT '0' COMMENT '是否开启促销 0=否 1=是(预留字段)',
  `sale_price` decimal(10,2) DEFAULT '0.00' COMMENT '折扣价(预留字段)',
  `brief_description` varchar(50) DEFAULT NULL COMMENT '简短展示文本/简短奖励描述(预留字段)',
  `description` varchar(500) DEFAULT NULL COMMENT '充值面额描述/充值面额优惠活动奖励描述',
  `is_give_balance` tinyint(1) unsigned DEFAULT '0' COMMENT '充值后是否赠送余额 0=否 1=是',
  `give_balance` decimal(10,2) DEFAULT '0.00' COMMENT '赠送余额数量',
  `is_give_coupons` tinyint(1) unsigned DEFAULT '0' COMMENT '充值后是否赠送优惠券 0=否 1=是',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tb_vip_recharge_denomination_coupons_relation
-- ----------------------------
DROP TABLE IF EXISTS `tb_vip_recharge_denomination_coupons_relation`;
CREATE TABLE `tb_vip_recharge_denomination_coupons_relation` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `vip_recharge_denomination_id` int(11) DEFAULT NULL COMMENT '会员充值面额id',
  `coupons_id` int(11) DEFAULT NULL COMMENT '赠送优惠卷id',
  `give_quantity` int(11) DEFAULT '1' COMMENT '赠送优惠券数量',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tb_vip_recharge_record
-- ----------------------------
DROP TABLE IF EXISTS `tb_vip_recharge_record`;
CREATE TABLE `tb_vip_recharge_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `member_id` int(11) DEFAULT NULL COMMENT '用户id',
  `order_no` varchar(50) DEFAULT NULL COMMENT '订单编号，供客户查询',
  `channel` int(10) DEFAULT NULL COMMENT '充值渠道 1=小程序 2=商家端 3=调度后台',
  `denomination_id` int(11) DEFAULT NULL COMMENT '会员充值面额id',
  `amount` decimal(10,2) DEFAULT NULL COMMENT '充值费用',
  `denomination_name` varchar(50) DEFAULT NULL COMMENT '充值面额名称',
  `denomination_price` decimal(10,2) DEFAULT '0.00' COMMENT '售价',
  `denomination_is_sale` tinyint(1) unsigned DEFAULT '0' COMMENT '是否开启促销 0=否 1=是',
  `denomination_sale_price` decimal(10,2) DEFAULT '0.00' COMMENT '折扣价',
  `denomination_is_give_balance` tinyint(1) unsigned DEFAULT '0' COMMENT '充值后是否赠送余额 0=否 1=是',
  `denomination_give_balance` decimal(10,2) DEFAULT '0.00' COMMENT '赠送余额数量',
  `denomination_is_give_coupons` tinyint(1) unsigned DEFAULT '0' COMMENT '充值后是否赠送优惠券 0=否 1=是',
  `denomination_give_coupons_description` varchar(500) DEFAULT NULL COMMENT '赠送的优惠券描述',
  `denomination_give_coupons_json` varchar(1024) DEFAULT NULL COMMENT '赠送的优惠券(JSON数据)',
  `trade_id` int(11) DEFAULT NULL COMMENT '用户交易id',
  `status` int(2) DEFAULT '1' COMMENT '交易状态 1=待支付 2=支付成功 3=支付失败 4=交易超时自动关闭',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员充值记录表';

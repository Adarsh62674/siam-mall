// const Login = () => import( './pages/Login.vue')
const LoginMain = () => import('./pages/LoginMain.vue')
const NotFound = () => import('./pages/404.vue')
const Home = () => import('./pages/Home.vue')
const Main = () => import('./pages/Main.vue')

const login = () => import('./pages/login/login.vue')
const QuickLogin = () => import('./pages/login/QuickLogin.vue')
const setPassword = () => import('./pages/login/setPassword.vue')

// 基础数据模块

//banner管理

//空页面
const emptyList = () => import('./pages/basicModule/emptyList.vue')

//用户管理
const memberList = () => import('./pages/memberManage/memberList.vue')
const purchasedMemberList = () => import('./pages/memberManage/purchasedMemberList.vue')
const unPurchasedMemberList = () => import('./pages/memberManage/unPurchasedMemberList.vue')

//促销管理
const paperworkPushList = () => import('./pages/promotionManage/paperworkPushList.vue')

//会员管理
const vipRechargeDenomination = () => import('./pages/promotionManage/internal/vipRechargeDenomination.vue')
const vipRechargeRecord = () => import('./pages/promotionManage/internal/vipRechargeRecord.vue')
const memberWithdrawRecord = () => import('./pages/promotionManage/memberWithdrawRecord.vue')

//轮播图管理
const advertisementList = () => import('./pages/shopDecoration/advertisementList.vue')
const addAdvertisementList = () => import('./pages/shopDecoration/addAdvertisementList.vue')
const editAdvertisementList = () => import('./pages/shopDecoration/editAdvertisementList.vue')

//系统设置
const settingList = () => import('./pages/systemSetting/settingList.vue')

//数据中心
const statisticGraph = () => import('./pages/basicModule/statisticGraph.vue')

//1、商城管理
//商品管理
const pointsMall_menuList = () => import('./pages/internal/pointsMallManage/goodsManage/menuList.vue')
const pointsMall_addMenu = () => import('./pages/internal/pointsMallManage/goodsManage/addMenu.vue')
const pointsMall_editMenu = () => import('./pages/internal/pointsMallManage/goodsManage/editMenu.vue')

const pointsMall_goodsList = () => import('./pages/internal/pointsMallManage/goodsManage/goodsList.vue')
const pointsMall_addGoods = () => import('./pages/internal/pointsMallManage/goodsManage/addGoods.vue')
const pointsMall_editGoods = () => import('./pages/internal/pointsMallManage/goodsManage/editGoods.vue')
//订单管理
const pointsMall_refundOrderList = () => import('./pages/internal/pointsMallManage/orderManage/refundOrderList.vue')
const pointsMall_orderDetail = () => import('./pages/internal/pointsMallManage/orderManage/orderDetail.vue')
const pointsMall_takeOutOrderList = () => import('./pages/internal/pointsMallManage/orderManage/takeOutOrderList.vue')
//促销管理
const pointsMall_fullReductionRuleList = () => import('./pages/internal/pointsMallManage/promotionManage/fullReductionRuleList.vue')
const pointsMall_couponsList = () => import('./pages/internal/pointsMallManage/promotionManage/couponsList.vue')
//数据中心
const pointsMall_statisticGraph = () => import('./pages/internal/pointsMallManage/basicModule/statisticGraph.vue')


let routes = [
  // {
  //     path: '/login',
  //     component: Login,
  //     name: '',
  //     hidden: true
  // },
  {
    path: '/login',
    component: LoginMain,
    name: '',
    hidden: true,
    children: [
      { path: '/', component: login, pagename: '登录', icon: 'el-icon-search', hidden: true },
      { path: '/QuickLogin', component: QuickLogin, pagename: '手机验证登录', icon: 'el-icon-search', hidden: true },
      { path: '/setPassword', component: setPassword, pagename: '忘记密码', icon: 'el-icon-search', hidden: true },
    ]
  },
  {
    path: '/404',
    component: NotFound,
    name: '',
    hidden: true
  },
  {
    path: '/',
    component: Home,
    name: '数据中心',
    iconCls: 'el-icon-house',
    leaf: true,//只有一个节点
    children: [
          { path: '/pointsMall_statisticGraph', component: pointsMall_statisticGraph, name: '数据中心' },
    ]
  },
  {
    path: '/',
    component: Home,
    name: '用户管理',
    iconCls: 'el-icon-user',
    children: [
      {
        path: '/memberList', component: memberList, name: '用户列表',
        leaf: true,//只有一个节点
        children: [
          { path: '/memberList', component: memberList, name: '用户列表' },
        ]
      },
      {
        path: '/purchasedMemberList', component: purchasedMemberList, name: '已购买用户',
        leaf: true,//只有一个节点
        children: [
          { path: '/purchasedMemberList', component: purchasedMemberList, name: '已购买用户' },
        ]
      },
      {
        path: '/unPurchasedMemberList', component: unPurchasedMemberList, name: '未购买用户',
        leaf: true,//只有一个节点
        children: [
          { path: '/unPurchasedMemberList', component: unPurchasedMemberList, name: '未购买用户' },
        ]
      },
    ]
  },

      {
        path: '/',
        component: Home,
        name: '商品管理',
        iconCls: 'el-icon-milk-tea',
        children: [
          {
            path: '/pointsMall_menuList', component: pointsMall_menuList, name: '分类管理',
            leaf: true,//只有一个节点
            children: [
              { path: '/pointsMall_menuList', component: pointsMall_menuList, name: '分类管理' },
            ]
          },
          {
            path: '/pointsMall_addMenu', component: pointsMall_addMenu, name: '新增分类', hidden: true,
            leaf: true,//只有一个节点
            children: [
              { path: '/pointsMall_addMenu', component: pointsMall_addMenu, name: '新增分类' },
            ]
          },
          {
            path: '/pointsMall_editMenu', component: pointsMall_editMenu, name: '编辑分类', hidden: true,
            leaf: true,//只有一个节点
            children: [
              { path: '/pointsMall_editMenu', component: pointsMall_editMenu, name: '编辑分类' },
            ]
          },



          {
            path: '/pointsMall_goodsList', component: pointsMall_goodsList, name: '商品列表',
            leaf: true,//只有一个节点
            children: [
              { path: '/pointsMall_goodsList', component: pointsMall_goodsList, name: '商品列表' },
            ]
          },
          {
            path: '/pointsMall_addGoods', component: pointsMall_addGoods, name: '新增商品', hidden: true,
            leaf: true,//只有一个节点
            children: [
              { path: '/pointsMall_addGoods', component: pointsMall_addGoods, name: '新增商品' },
            ]
          },
          {
            path: '/pointsMall_editGoods', component: pointsMall_editGoods, name: '编辑商品', hidden: true,
            leaf: true,//只有一个节点
            children: [
              { path: '/pointsMall_editGoods', component: pointsMall_editGoods, name: '编辑商品' },
            ]
          },
          // {
          //   path: '/pointsMall_recommendGoods', component: pointsMall_recommendGoods, name: '商家推荐',
          //   leaf: true,//只有一个节点
          //   children: [
          //     { path: '/pointsMall_recommendGoods', component: pointsMall_recommendGoods, name: '商家推荐' },
          //   ]
          // },
          // { path: '/pointsMall_goodsAccessoriesList', component: pointsMall_goodsAccessoriesList, name: '商品辅料' },          
          // { path: '/pointsMall_rawmaterialList', component: pointsMall_rawmaterialList, name: '商品原料' },  
          // { path: '/pointsMall_goodsRawmaterialRelationList', component: pointsMall_goodsRawmaterialRelationList, name: '原料配比' },  
          // { path: '/pointsMall_specificationList', component: pointsMall_specificationList, name: '商品规格' },
          // { path: '/pointsMall_stockList', component: pointsMall_stockList, name: '商品库存' },          
        ]
      },


  {
    path: '/',
    component: Home,
    name: '订单管理',
    iconCls: 'el-icon-s-order',
    children: [
      {
        path: '/pointsMall_takeOutOrderList', component: pointsMall_takeOutOrderList, name: '订单列表',
        leaf: true,//只有一个节点
        children: [
          { path: '/pointsMall_takeOutOrderList', component: pointsMall_takeOutOrderList, name: '订单列表' },
        ]
      },

      {
        path: '/pointsMall_refundOrderList', component: pointsMall_refundOrderList, name: '售后处理',
        leaf: true,//只有一个节点
        children: [
          { path: '/pointsMall_refundOrderList', component: pointsMall_refundOrderList, name: '售后处理' },
        ]
      },
      
      {
        path: '/pointsMall_orderDetail', component: pointsMall_orderDetail, name: '查看订单详情', hidden: true,
        leaf: true,//只有一个节点
        children: [
          { path: '/pointsMall_orderDetail', component: pointsMall_orderDetail, name: '查看订单详情' },
        ]
      },
    ]
  },
  
  {
    path: '/',
    component: Home,
    name: '营销中心',
    iconCls: 'el-icon-house',
    children: [
      {
        path: '/pointsMall_fullReductionRuleList', component: pointsMall_fullReductionRuleList, name: '满减',
        leaf: true,//只有一个节点
        children: [
          { path: '/pointsMall_fullReductionRuleList', component: pointsMall_fullReductionRuleList, name: '满减' },
        ]
      },
      {
        path: '/pointsMall_couponsList', component: pointsMall_couponsList, name: '优惠券',
        leaf: true,//只有一个节点
        children: [
          { path: '/pointsMall_couponsList', component: pointsMall_couponsList, name: '优惠券' },
        ]
      },
      {
        path: '/addAdvertisementList', component: addAdvertisementList, name: '新增海报', hidden: true,
        leaf: true,//只有一个节点
        children: [
          { path: '/addAdvertisementList', component: addAdvertisementList, name: '新增海报' },
        ]
      },
      {
        path: '/editAdvertisementList', component: editAdvertisementList, name: '编辑海报', hidden: true,
        leaf: true,//只有一个节点
        children: [
          { path: '/editAdvertisementList', component: editAdvertisementList, name: '编辑海报' },
        ]
      },      
      {
        path: '/vipRechargeDenomination', component: vipRechargeDenomination, name: '会员充值面额',
        leaf: true,//只有一个节点
        children: [
          { path: '/vipRechargeDenomination', component: vipRechargeDenomination, name: '会员充值面额' },
        ]
      },
      {
        path: '/paperworkPushList', component: paperworkPushList, name: '文案推送',
        leaf: true,//只有一个节点
        children: [
          { path: '/paperworkPushList', component: paperworkPushList, name: '文案推送' },
        ]
      },
    ]
  },
  {
    path: '/',
    component: Home,
    name: '财务报表',
    iconCls: 'el-icon-user',
    children: [
      {
        path: '/vipRechargeRecord', component: vipRechargeRecord, name: '会员充值记录',
        leaf: true,//只有一个节点
        children: [
          { path: '/vipRechargeRecord', component: vipRechargeRecord, name: '会员充值记录' },
        ]
      },
      {
        path: '/memberWithdrawRecord', component: memberWithdrawRecord, name: '用户奖励金提现记录',
        leaf: true,//只有一个节点
        children: [
          { path: '/memberWithdrawRecord', component: memberWithdrawRecord, name: '用户奖励金提现记录' },
        ]
      },
    ]
  },

  {
    path: '/',
    component: Home,
    name: '系统配置',
    iconCls: 'el-icon-setting',
    children: [
      {
        path: '/settingList', component: settingList, name: '基础数据配置',
        leaf: true,//只有一个节点
        children: [
          { path: '/settingList', component: settingList, name: '基础数据配置' },
        ]
      },
    ]
  },

  {
    path: '*',
    hidden: true,
    redirect: { path: '/404' }
  }
];

export default routes;

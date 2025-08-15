package com.siam.system.modular.package_goods.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.siam.system.modular.package_goods.entity.Setting;
import com.siam.system.modular.package_goods.model.example.SettingExample;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.ResultMap;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

public interface SettingMapper extends BaseMapper<Setting> {

    @ResultMap("BaseResultMap")
    @Select("<script>select s.* from tb_setting s" +
            "<where> 1=1 " +
            "<if test=\"setting.id != null\"> AND s.id = #{setting.id} </if>" +
            "<if test=\"setting.purchaseRewardPoints != null\"> AND s.purchase_reward_points = #{setting.purchaseRewardPoints} </if>" +
            "<if test=\"setting.registrationRewardPoints != null\"> AND s.registration_reward_points = #{setting.registrationRewardPoints} </if>" +
            "</where> order by s.id desc" +
            "</script>")
    Page<Map<String, Object>> getListByPage(@Param("page") Page page, @Param("setting") Setting setting);

    @ResultMap("BaseResultMap")
    @Select("select s.* from tb_setting s limit 1")
    Setting selectCurrent();
}
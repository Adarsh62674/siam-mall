package com.siam.system.modular.package_goods.util;

import com.siam.system.modular.package_user.entity.MerchantWithdrawRecord;
import lombok.extern.slf4j.Slf4j;

import java.lang.reflect.Field;
import java.math.BigDecimal;

@Slf4j
public class GenerateMapperXml {

    public static void main(String[] args) {
        new GenerateMapperXml().generateMapperXml();
    }

    /**
     * 自动生成mapper.xml中的if判断标签
     */
    public void generateMapperXml(){
        System.out.println("############## START xml标签打印 #############\n");
        Field[] declaredFields = MerchantWithdrawRecord.class.getDeclaredFields();
        for (Field field : declaredFields) {
            String dbFieldName = getDbFieldName(field.getName());
            String ifLabel = null;
            if (field.getType() == String.class){
                ifLabel =
                        "<if test=\"paramCondition."+ field.getName() +" != null and paramCondition."+ field.getName() +" != ''\">"+
                                " and "+ dbFieldName +" like CONCAT('%',#{paramCondition."+ field.getName() +"},'%') "+
                                "</if>";
            }else if (field.getType()==Integer.class || field.getType()==Long.class || field.getType()== BigDecimal.class){
                ifLabel =
                        "<if test=\"paramCondition."+ field.getName() +" != null\">"+
                                " and "+ dbFieldName +" = #{paramCondition."+ field.getName() +"} "+
                                "</if>";
            }
            if(ifLabel != null){
                System.out.println(ifLabel);
            }
        }
        System.out.println("\n############## END xml标签打印 #############");
    }

    /** 驼峰转下划线 */
    String getDbFieldName(String fieldName){
        return fieldName.replaceAll("[A-Z]", "_$0").toLowerCase();
    }
}
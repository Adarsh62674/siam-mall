package com.siam.system.modular.package_goods.util;

import lombok.extern.slf4j.Slf4j;

import java.lang.reflect.Field;

@Slf4j
public class GenerateShowDoc {

    public static void main(String[] args) {
        new GenerateShowDoc().generateShowDocXml();
    }

    /**
     * 自动生成showDoc接口文档标签打印
     */
    public void generateShowDocXml(){
        System.out.println("############## START showDoc标签打印 #############\n");
        Field[] declaredFields = com.siam.system.modular.package_goods.entity.TbDiningTable.class.getDeclaredFields();
        for (Field field : declaredFields) {
            String ifLabel = null;
            ifLabel = "|"+ field.getName() +" | "+ field.getType().getSimpleName() +"|主键id  |";

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
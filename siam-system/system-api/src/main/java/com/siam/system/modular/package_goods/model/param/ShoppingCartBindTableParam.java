package com.siam.system.modular.package_goods.model.param;

import lombok.Data;

import java.util.List;

@Data
public class ShoppingCartBindTableParam {

    private List<Integer> idList;

    private Long tableId;
}
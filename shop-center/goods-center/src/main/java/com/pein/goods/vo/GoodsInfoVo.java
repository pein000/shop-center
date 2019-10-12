package com.pein.goods.vo;

import lombok.Data;

import java.util.Date;

@Data
public class GoodsInfoVo {
    private Integer id;

    private String goodsName;

    private String goodsUrl;

    private String goodsImage;

    private String goodsDescribe;

    private Date createTime;

    private Date updateTime;
}
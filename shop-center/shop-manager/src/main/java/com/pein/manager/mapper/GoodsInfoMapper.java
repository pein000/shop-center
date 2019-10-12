package com.pein.manager.mapper;

import com.pein.manager.entity.GoodsInfo;

public interface GoodsInfoMapper {

    int insert(GoodsInfo record);

    int insertSelective(GoodsInfo record);

    GoodsInfo selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(GoodsInfo record);

    int updateByPrimaryKey(GoodsInfo record);

    int deleteOne(Integer goodsId);
}
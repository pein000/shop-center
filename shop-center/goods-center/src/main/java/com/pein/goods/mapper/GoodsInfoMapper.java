package com.pein.goods.mapper;

import com.pein.goods.entity.GoodsInfo;
import com.pein.goods.vo.GoodsInfoVo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface GoodsInfoMapper {
    int insert(GoodsInfo record);

    int insertSelective(GoodsInfo record);

    GoodsInfo selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(GoodsInfo record);

    int updateByPrimaryKey(GoodsInfo record);

    int deleteOne(Integer goodsId);

    int countAll();

    List<GoodsInfoVo> listByPage(@Param("offset") Integer offset, @Param("pageSize") Integer pageSize);
}
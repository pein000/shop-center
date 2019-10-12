package com.pein.goods.mapper;

import com.pein.goods.entity.GoodsClassify;
import com.pein.goods.vo.GoodsClassifyVo;
import org.springframework.stereotype.Repository;

import java.util.List;

public interface GoodsClassifyMapper {

    int insert(GoodsClassify record);

    int insertSelective(GoodsClassify record);

    GoodsClassify selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(GoodsClassify record);

    int updateByPrimaryKey(GoodsClassify record);

    List<GoodsClassifyVo> listAll();
}
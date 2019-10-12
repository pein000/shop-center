package com.pein.manager.service;

import com.pein.manager.mapper.GoodsInfoMapper;
import com.pein.manager.entity.GoodsInfo;
import com.pein.manager.vo.GoodsInfoVo;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class GoodsManagerService {

    @Resource
    private GoodsInfoMapper goodsInfoMapper;

    public GoodsInfo addOne(GoodsInfoVo goodsInfoVo) {
        GoodsInfo goodsInfo = new GoodsInfo();
        BeanUtils.copyProperties(goodsInfoVo, goodsInfo);
        goodsInfoMapper.insert(goodsInfo);
        return goodsInfo;
    }

    public boolean delete(Integer goodsId) {
        int result = goodsInfoMapper.deleteOne(goodsId);
        return result > 0;
    }

}

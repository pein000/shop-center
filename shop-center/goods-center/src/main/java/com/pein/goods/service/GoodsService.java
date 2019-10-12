package com.pein.goods.service;

import com.pein.goods.mapper.GoodsClassifyMapper;
import com.pein.goods.mapper.GoodsInfoMapper;
import com.pein.goods.vo.GoodsClassifyVo;
import com.pein.goods.vo.GoodsInfoVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class GoodsService {

    private final static Integer PAGE_SIZE = 10;

    @Resource
    private GoodsClassifyMapper goodsClassifyMapper;

    @Resource
    private GoodsInfoMapper goodsInfoMapper;

    public List<GoodsClassifyVo> listAllClassify() {
        return goodsClassifyMapper.listAll();
    }

    public List<GoodsInfoVo> listGoodsByPage(Integer pageNum) {
        int offset = pageNum * PAGE_SIZE + 1;
        return goodsInfoMapper.listByPage(offset, PAGE_SIZE);
    }

}

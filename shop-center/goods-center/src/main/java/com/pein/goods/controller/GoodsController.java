package com.pein.goods.controller;

import com.pein.goods.service.GoodsService;
import com.pein.goods.vo.GoodsClassifyVo;
import com.pein.goods.vo.GoodsInfoVo;
import com.pein.modal.vo.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("goods")
public class GoodsController {

    @Autowired
    private GoodsService goodsService;

    @GetMapping("list_all_classify")
    public Result<List<GoodsClassifyVo>> listAllClassify() {
        log.info("begin to GoodsController -> listAllClassify.");
        List<GoodsClassifyVo> result = goodsService.listAllClassify();
        log.info("end to GoodsController -> listAllClassify . result: {},", result);
        return new Result<>(result);
    }

    @GetMapping("list_goods_page/{pageNum}")
    public Result<List<GoodsInfoVo>> listGoodsByPage(@PathVariable Integer pageNum) {
        log.info("begin to GoodsController -> listGoodsByPage. pageNum: {}. ", pageNum);
        List<GoodsInfoVo> result = goodsService.listGoodsByPage(pageNum);
        log.info("end to GoodsController -> listGoodsByPage . result: {},", result);
        return new Result<>(result);
    }

}

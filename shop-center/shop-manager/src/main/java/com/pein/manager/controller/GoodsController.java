package com.pein.manager.controller;

import com.pein.manager.entity.GoodsInfo;
import com.pein.manager.service.GoodsManagerService;
import com.pein.manager.vo.GoodsInfoVo;
import com.pein.modal.vo.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("manager/goods")
public class GoodsController {

    @Autowired
    private GoodsManagerService goodsManagerService;

    @PostMapping("add_one")
    public Result<GoodsInfo> addOne(@RequestBody GoodsInfoVo goodsInfoVo) {
        log.info("begin to GoodsController -> addOne . goodsInfoVo: {},", goodsInfoVo);
        GoodsInfo result = goodsManagerService.addOne(goodsInfoVo);
        log.info("end to GoodsController -> addOne . result: {},", result);
        return new Result<>(result);
    }

    @PostMapping("delete_one/{goodsId}")
    public Result<Boolean> deleteOne(@PathVariable Integer goodsId) {
        log.info("begin to GoodsController -> deleteOne . goodsId: {},", goodsId);
        Boolean result = goodsManagerService.delete(goodsId);
        log.info("end to GoodsController -> deleteOne . result: {},", result);
        return new Result<>(result);
    }

}

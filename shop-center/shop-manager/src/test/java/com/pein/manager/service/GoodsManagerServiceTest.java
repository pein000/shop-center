package com.pein.manager.service;


import com.pein.manager.vo.GoodsInfoVo;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class GoodsManagerServiceTest {

    @Autowired
    private GoodsManagerService goodsManagerService;

    @Test
    public void addOne() {
        GoodsInfoVo goodsInfoVo = new GoodsInfoVo();
        goodsInfoVo.setGoodsName("测试啤酒");
        goodsInfoVo.setGoodsImage("111");
        goodsInfoVo.setGoodsUrl("111");
        goodsInfoVo.setGoodsDescribe("111");
        goodsManagerService.addOne(goodsInfoVo);
    }

    @Test
    public void delete() {
    }
}

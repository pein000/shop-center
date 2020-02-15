package com.pein.manager.service;


import com.pein.manager.vo.GoodsInfoVo;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

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

    @Test
    public void test() {
        CyclicBarrier cyclicBarrier = new CyclicBarrier(2);
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("-------------");
                try {
                    cyclicBarrier.await();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                } catch (BrokenBarrierException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private class TThread extends Thread {

        @Override
        public void run() {
            super.run();
        }
    }


    public void testSingleton() {
        Resource resource = EnumSingleton.INSTANCE.getInstance();
        Singleton instance = Singleton.getInstance();

    }

}

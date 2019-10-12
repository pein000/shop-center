package com.pein.api;

import com.pein.modal.dto.OrderInfoDTO;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(value = "order-test")
public interface OrderService {

    @GetMapping("add_one")
    OrderInfoDTO addOne(@RequestParam(value = "id") Integer id, @RequestParam(value = "name") String name, @RequestParam(value = "address") String address);

}

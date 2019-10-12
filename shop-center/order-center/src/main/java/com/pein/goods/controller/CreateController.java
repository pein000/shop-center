package com.pein.goods.controller;

import com.pein.modal.dto.OrderInfoDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping
@Slf4j
public class CreateController {

    @GetMapping("add_one")
    public OrderInfoDTO addOne(@RequestParam(value = "id") Integer id, @RequestParam(value = "name") String name, @RequestParam(value = "address") String address) {
        log.info("to add one goods. {},{},{}", id, name, address);
        return new OrderInfoDTO(id, name, address);
    }

}

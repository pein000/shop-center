package com.pein.user.controller;

import com.pein.modal.dto.UserInfoDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping
public class AddController {

    private static final Logger log = LoggerFactory.getLogger(AddController.class);

    @GetMapping("to_register_or_login")
    public UserInfoDTO registerOrLogin(@RequestParam(value = "id") Integer id, @RequestParam(value = "name") String name, @RequestParam(value = "address") String address) {
        log.info("to add one user. {},{},{}", id, name, address);
        return new UserInfoDTO(id, name, address);
    }

}

package com.pein.api;

import com.pein.modal.dto.UserInfoDTO;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(value = "user-test")
public interface UserService {

    @GetMapping("/hi")
    String home(@RequestParam(value = "name", defaultValue = "forezp") String name);

    @GetMapping("/to_add_one")
    UserInfoDTO addOne(@RequestParam(value = "id") Integer id, @RequestParam(value = "name") String name, @RequestParam(value = "address") String address);

}

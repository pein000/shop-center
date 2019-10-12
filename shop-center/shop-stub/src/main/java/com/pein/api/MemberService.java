package com.pein.api;

import com.pein.modal.dto.MemberInfoDTO;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(value = "member-test")
public interface MemberService {

    @GetMapping("/hi")
    String home(@RequestParam(value = "name", defaultValue = "forezp") String name);

    @GetMapping("/to_add_one")
    MemberInfoDTO addOne(@RequestParam(value = "id") Integer id, @RequestParam(value = "name") String name, @RequestParam(value = "address") String address);

}

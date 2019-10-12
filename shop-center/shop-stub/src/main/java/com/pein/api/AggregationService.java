package com.pein.api;

import com.pein.modal.dto.SaleInfoDTO;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(value = "aggregation-test")
public interface AggregationService {

    @GetMapping("create/{name}/{address}")
    SaleInfoDTO create(@PathVariable("name") String name, @PathVariable("address") String address);

}

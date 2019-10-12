package com.pein.modal.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderInfoDTO implements Serializable {

    private Integer id;

    private  String name;

    private String address;

}

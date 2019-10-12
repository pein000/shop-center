package com.pein.modal.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SaleInfoDTO implements Serializable {

    private Integer saleId;

    private  String SaleName;

    private String SaleAddress;
}

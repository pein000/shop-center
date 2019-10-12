package com.pein.modal.vo;

import lombok.Data;

@Data
public class Result<T> {

    private boolean success = true;

    private T data;

    private String errorCode;

    private String message;

    public Result() {
    }

    public Result(T data) {
        this.data = data;
    }

    public Result(String errorCode, String message) {
        this.success = false;
        this.errorCode = errorCode;
        this.message = message;
    }


}

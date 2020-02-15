package com.pein.manager.service;

public enum EnumSingleton {
    INSTANCE,
    ;

    private Resource instance;

    EnumSingleton() {
        instance = new Resource();
    }

    public Resource getInstance(){
        return this.instance;
    }
}

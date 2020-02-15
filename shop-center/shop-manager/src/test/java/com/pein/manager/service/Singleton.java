package com.pein.manager.service;

public class Singleton {

    private static class SingletonHolder {

        private static Singleton instance = new Singleton();
    }

    private Singleton() {

    }


    public static Singleton getInstance() {
        return SingletonHolder.instance;
    }

}

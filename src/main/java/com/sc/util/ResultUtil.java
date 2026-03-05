package com.sc.util;

public class ResultUtil {
    private int code; // 200成功 500失败
    private String msg; // 提示信息
    private Object data; // 返回数据

    // 成功响应
    public static ResultUtil success(Object data) {
        ResultUtil result = new ResultUtil();
        result.code = 200;
        result.msg = "操作成功";
        result.data = data;
        return result;
    }

    public static ResultUtil success(String msg, Object data) {
        ResultUtil result = new ResultUtil();
        result.code = 200;
        result.msg = msg;
        result.data = data;
        return result;
    }

    // 失败响应
    public static ResultUtil error(String msg) {
        ResultUtil result = new ResultUtil();
        result.code = 500;
        result.msg = msg;
        result.data = null;
        return result;
    }

    // getter和setter
    public int getCode() { return code; }
    public void setCode(int code) { this.code = code; }
    public String getMsg() { return msg; }
    public void setMsg(String msg) { this.msg = msg; }
    public Object getData() { return data; }
    public void setData(Object data) { this.data = data; }
}

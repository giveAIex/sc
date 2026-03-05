package com.sc.util;

import java.security.MessageDigest;
import java.util.UUID;

public class MD5Util {
    // 生成16位随机盐值
    public static String generateSalt() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 16);
    }

    // 基础MD5加密（32位小写）
    public static String md5(String str) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(str.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) sb.append('0');
                sb.append(hex);
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 核心加盐加密方法（注册/登录必用，永不存明文密码）
    public static String encryptWithSalt(String password, String salt) {
        return md5(md5(password) + salt);
    }

    // 兼容旧代码的encrypt方法（解决编译报错，优先使用加盐加密）
    public static String encrypt(String str) {
        return md5(str);
    }
}

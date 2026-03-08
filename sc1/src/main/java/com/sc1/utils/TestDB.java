package com.sc1.utils;

import java.sql.Connection;

public class TestDB {
    public static void main(String[] args) {
        try {
            Connection conn = DBUtil.getConnection();
            if (conn != null) {
                System.out.println("✅ 数据库连接成功！你的百货商店可以开张了。");
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("❌ 数据库连接失败，请检查密码或库名是否正确。");
            e.printStackTrace();
        }
    }
}

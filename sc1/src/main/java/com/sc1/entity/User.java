package com.sc1.entity;

public class User {
    private int id;
    private String username;
    private String password;
    private int role; // 0:普通用户, 1:管理员

    // 无参构造
    public User() {}

    // Getters and Setters (必须有，JSP和框架经常依赖它们)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }
}

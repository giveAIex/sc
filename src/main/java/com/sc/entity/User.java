package com.sc.entity;

import java.util.Date;

/**
 * 完全适配ling_mall数据库的user表
 */
public class User {
    private Integer id;
    private String username;
    private String password;
    private Integer role; // 1-管理员 2-商家 3-客户
    private String phone;
    private String email;
    private Date createTime;

    // 无参构造
    public User() {}

    // 全参构造
    public User(Integer id, String username, String password, Integer role, String phone, String email, Date createTime) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.phone = phone;
        this.email = email;
        this.createTime = createTime;
    }

    // 必须的getter/setter方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public Integer getRole() { return role; }
    public void setRole(Integer role) { this.role = role; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}

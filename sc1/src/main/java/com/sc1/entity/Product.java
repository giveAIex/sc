package com.sc1.entity;

import java.math.BigDecimal;

public class Product {
    private int id;
    private String name;
    private BigDecimal price; // 价格建议用 BigDecimal 精度更高
    private int stock;
    private String description;
    private int merchantId;   // 关联商户ID

    // 构造方法
    public Product() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getMerchantId() { return merchantId; }
    public void setMerchantId(int merchantId) { this.merchantId = merchantId; }
}

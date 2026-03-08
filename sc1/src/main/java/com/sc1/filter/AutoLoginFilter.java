package com.sc1.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

public class AutoLoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // 目前先直接放行，等后面写了 Cookie 逻辑再补
        chain.doFilter(request, response);
    }
}

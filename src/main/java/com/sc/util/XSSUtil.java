package com.sc.util;

public class XSSUtil {
    // ÌØÊâ×Ö·û×ªÒå£¬·ÀÖ¹XSS¹¥»÷
    public static String escape(String content) {
        if (content == null || content.isEmpty()) {
            return content;
        }
        content = content.replace("&", "&amp;");
        content = content.replace("<", "&lt;");
        content = content.replace(">", "&gt;");
        content = content.replace("\"", "&quot;");
        content = content.replace("'", "&#x27;");
        content = content.replace("/", "&#x2F;");
        return content;
    }
}

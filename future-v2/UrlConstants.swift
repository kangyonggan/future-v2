//
//  UrlConstants.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

// 请求地址常量
class UrlConstants: NSObject {
    
    // 域名
    static let DOMAIN = "https://kangyonggan.com/";
//    static let DOMAIN = "http://127.0.0.1:8080/";
    
    // 登录
    static let LOGIN = "mobile/login";
    
    // 获取验证码
    static let AUTH_CODE = "mobile/sms";
    
    // 注册
    static let REGISTER = "mobile/register";
    
    // 忘记密码
    static let FORGOT = "mobile/forgot";
    
    // 全部分类
    static let CATEGORY_ALL = "mobile/category/all";
    
    // 推荐小说
    static let BOOK_HOTS = "mobile/book/hots";
    
    // 搜索小说
    static let BOOK_SEARCH = "mobile/book/search";
    
    // 分类小说
    static let BOOK_CATEGORY = "mobile/book/category";
    
    // 小说第一章
    static let SECTION_FIRST = "mobile/section/first";
    
    // 查找章节
    static let SECTION = "mobile/section";
    
    // 章节缓存
    static let SECTION_CACHE = "mobile/section/cache";
    
    // 全部章节
    static let SECTION_ALL = "mobile/section/all";
    
}

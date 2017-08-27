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
    
    // 手机端前缀
    static let MOBILE = "mobile/";
    
    // 登录
    static let LOGIN = MOBILE + "user/login";
    
    // 获取验证码
    static let AUTH_CODE = MOBILE + "sms";
    
    // 注册
    static let REGISTER = MOBILE + "user/register";
    
    // 忘记密码
    static let FORGOT = MOBILE + "user/forgot";
    
    // 修改密码
    static let UPDATE_PASSWORD = MOBILE + "user/password";
    
    // 全部分类
    static let CATEGORY_ALL = MOBILE + "category/all";
    
    // 推荐小说
    static let BOOK_HOTS = MOBILE + "book/hots";
    
    // 搜索小说
    static let BOOK_SEARCH = MOBILE + "book/search";
    
    // 分类小说
    static let BOOK_CATEGORY = MOBILE + "book/category";
    
    // 小说第一章
    static let SECTION_FIRST = MOBILE + "section/first";
    
    // 查找章节
    static let SECTION = MOBILE + "section";
    
    // 章节缓存
    static let SECTION_CACHE = MOBILE + "section/cache";
    
    // 全部章节
    static let SECTION_ALL = MOBILE + "section/all";
    
    // 修改用户信息
    static let USER_UPDATE = MOBILE + "user/update";
    
    // 未读消息数量
    static let MESSAGE_COUNT = MOBILE + "message/count";
    
    // 全部消息
    static let MESSAGE_ALL = MOBILE + "message/all";
    
    // 消息已读
    static let MESSAGE_READ = MOBILE + "message/read";
    
    // 消息建议
    static let MESSAGE_ADVICE = MOBILE + "message/advice";
    
    // 消息回复
    static let MESSAGE_PRE_REPLY = MOBILE + "message/preReply";
    
    // 消息回复
    static let MESSAGE_REPLY = MOBILE + "message/reply";
    
    // 查询消息
    static let MESSAGE = MOBILE + "message/";
    
}

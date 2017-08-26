//
//  User.swift
//  future-v2
//
//  Created by kangyonggan on 8/26/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

// 用户
class User: NSObject {
    
    override init() {
        
    }
    
    init(_ u: NSDictionary) {
        self.username = u["username"] as? String;
        self.realname = u["realname"] as? String;
        self.smallAvatar = u["smallAvatar"] as? String;
        self.mediumAvatar = u["mediumAvatar"] as? String;
        self.largeAvatar = u["largeAvatar"] as? String;
        self.email = u["email"] as? String;
    }
    
    // 用户名
    var username: String!;
    
    // 真实姓名
    var realname: String!;
    
    // 小头像
    var smallAvatar: String!;
    
    // 中头像
    var mediumAvatar: String!;
    
    // 大头像
    var largeAvatar: String!;
    
    // 电子邮箱
    var email: String?
    
    // 登录指纹
    var token: String?
    
}

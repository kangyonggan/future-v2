//
//  Message.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

// 消息
class Message: NSObject {
    
    override init() {
        
    }
    
    init(_ message: NSDictionary) {
        self.id = message["id"] as? Int;
        self.title = message["title"] as? String;
        self.type = message["type"] as? String;
        self.content = message["content"] as? String;
        self.isRead = message["isRead"] as? Bool;
        self.createdUsername = message["createdUsername"] as? String;
    }
    
    // 消息ID
    var id: Int!;
    
    // 消息标题
    var title: String!;
    
    // 消息类型
    var type: String!;
    
    // 消息内容
    var content: String?;
    
    // 是否已读
    var isRead: Bool!;
    
    // 创建人
    var createdUsername: String!;
}

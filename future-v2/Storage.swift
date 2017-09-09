//
//  Storage.swift
//  future-v2
//
//  Created by kangyonggan on 9/8/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

class Storage: NSObject {
    
    override init() {
        
    }
    
    init(_ dict: NSDictionary) {
        self.subject = dict["subject"] as? String;
        self.question = dict["question"] as? String;
        self.url = dict["url"] as? String;
        self.option1 = dict["option1"] as? String;
        self.option2 = dict["option2"] as? String;
        self.option3 = dict["option3"] as? String;
        self.option4 = dict["option4"] as? String;
        self.answer = dict["answer"] as? String;
        self.explains = dict["explains"] as? String;
    }
    
    // 科目
    var subject: String!;
    
    // 题目
    var question: String!;
    
    // 题目配图
    var url: String!;
    
    // 选项1
    var option1: String!;
    
    // 选项2
    var option2: String!;
    
    // 选项3
    var option3: String!;
    
    // 选项4
    var option4: String!;
    
    // 答案
    var answer: String!;
    
    // 提示
    var explains: String!;
    
}

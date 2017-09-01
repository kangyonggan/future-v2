//
//  News.swift
//  future-v2
//
//  Created by kangyonggan on 8/31/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

class News: NSObject {
    
    // 标题
    var title: String!;
    
    // 来源
    var source: String!;
    
    // 分类
    var tag: String!;
    
    // 封面
    var imageUrl: String?;
    
    // 图片数量
    var gallaryImageCount: Int?;
    
    // 图片集
    var imageList: [String]?;
}

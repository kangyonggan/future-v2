//
//  Music.swift
//  future-v2
//
//  Created by kangyonggan on 9/6/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

class Music: NSObject {
    
    override init() {
        
    }
    
    init(_ music: NSDictionary) {
        self.name = music["name"] as? String;
        self.singer = music["singer"] as? String;
        self.album = music["album"] as? String;
        self.duration = music["duration"] as? Int;
        self.size = music["size"] as? Int;
    }
    
    // 歌曲名
    var name: String!;
    
    // 歌手
    var singer: String!;
    
    // 专辑
    var album: String!;
    
    // 时长(秒)
    var duration: Int!;
    
    // 文件大小(byte)
    var size: Int!;
    
}

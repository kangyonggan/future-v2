//
//  AsyncImage.swift
//  future-v2
//
//  Created by kangyonggan on 9/9/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class AsyncImage: UIImage {
    
    var imageView: UIImageView!;
    var name: String!;
    var defaultName: String!;
    
    func load(named: String, to: UIImageView, withDefault: String) {
        self.name = named;
        self.imageView = to;
        self.defaultName = withDefault;
        
        Http.get(named, callback: callback);
    }
    
    // 加载封面的回调
    func callback(res: HTTPResult) {
        if res.ok {
            let img = UIImage(data: res.content!)
            
            DispatchQueue.main.async {
                self.imageView.image = img;
            }
            
            // 把图片缓存到本地
            FileUtil.writeImage(img!, withName: name);
        } else {
            let img = UIImage(named: self.defaultName);
            DispatchQueue.main.async {
                self.imageView.image = img;
            }
        }
    }
}

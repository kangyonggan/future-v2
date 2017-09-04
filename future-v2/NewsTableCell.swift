//
//  NewsTableCell.swift
//  future-v2
//
//  Created by kangyonggan on 9/2/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class NewsTableCell: UITableViewCell {
    
    var coverImage: UIImageView?;
    
    // 初始化数据
    func initData(_ news: NSDictionary) {
        // 清除
        for subView in self.subviews {
            subView.removeFromSuperview();
        }
        
        // 数据准备
        var info = news["source"] as! String;
        let time = news["datetime"] as? String;
        if time != nil {
            info += " | " + time!;
        }
        
        var url = news["image_url"] as? String;
        if url == nil {
            url = news["large_image_url"] as? String;
        }
        
        if url == nil {
            let imageList = news["image_list"] as! NSArray
            if imageList.count > 0 {
                url = (imageList[0] as! NSDictionary)["url"] as? String;
            }
        }
        
        // TODO 按类型来做不同的控件
        var width = self.frame.width - 10;
        if url != nil {
            width = self.frame.width - 110;
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 5, y: 0, width: width, height: 50));
        titleLabel.numberOfLines = 2;
        
        let infoLabel = UILabel(frame: CGRect(x: 5, y: 60, width: width, height: 15));
        infoLabel.textColor = UIColor.lightGray;
        infoLabel.font = UIFont.systemFont(ofSize: 12);
        
        coverImage = UIImageView(frame: CGRect(x: self.frame.width - 105, y: 3, width: 100, height: 70));
        
        self.addSubview(titleLabel);
        self.addSubview(infoLabel);
        
        // 填充数据
        titleLabel.text = news["title"] as? String;
        infoLabel.text = info;
        
        if (url != nil) {
            self.addSubview(coverImage!);
            Just.get(url!, asyncCompletionHandler: callback);
        }
        
    }
    
    func callback(res: HTTPResult) {
        if res.ok {
            let img = UIImage(data: res.content!)
            
            DispatchQueue.main.async {
                self.coverImage!.image = img;
            }
        } else {
            DispatchQueue.main.async {
                self.coverImage!.removeFromSuperview();
            }
        }
    }
    
}

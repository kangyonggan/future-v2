//
//  FavoriteCollectionCell.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class FavoriteCollectionCell: UICollectionViewCell {
    
    // 控件
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // 初始化数据
    func initData(_ book: Book) {
        // 封面 异步加载
        Http.get(book.picUrl, callback: callback);
        
        // 书名
        nameLabel.text = book.name;
    }
    
    // 加载封面的回调
    func callback(res: HTTPResult) {
        if res.ok {
            let img = UIImage(data: res.content!)
            DispatchQueue.main.async {
                self.imageView.image = img;
            }
        } else {
            let img = UIImage(named: AppConstants.NO_COVER_IMAGE);
            DispatchQueue.main.async {
                self.imageView.image = img;
            }
        }
    }
}

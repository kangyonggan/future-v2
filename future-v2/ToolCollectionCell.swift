//
//  ToolCollectionCell.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ToolCollectionCell: UICollectionViewCell {
    
    // 控件
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func initData(_ tool: (String, String, String)) {
        imageView.image = UIImage(named: tool.0);
        nameLabel.text = tool.2;
        
        // 边框
        self.layer.cornerRadius = 5;
        self.layer.borderColor = UIColor.lightGray.cgColor;
        self.layer.borderWidth = 1;
    }
    
}

//
//  MusicTableViewCell.swift
//  future-v2
//
//  Created by kangyonggan on 9/6/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class MusicLocalTableCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    
    // 初始化数据
    func initData(_ info: (String, String), isSelected: Bool) {
        infoLabel.text = info.1 + " - " + info.0;
        if isSelected {
            rightImage.isHidden = false;
        } else {
            rightImage.isHidden = true;
            
        }
        
    }
    
}

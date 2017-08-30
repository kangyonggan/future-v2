//
//  ProvinceTableCell.swift
//  future-v2
//
//  Created by kangyonggan on 8/30/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ProvinceTableCell: UITableViewCell {
    
    // 控件
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func initData(_ prov: (String, String), isSelected: Bool) {
        if prov.0.isEmpty {
            nameLabel.text = prov.1;
        } else {
            nameLabel.text = prov.1 + "[" + prov.0 + "]";
        }
        
        if !isSelected {
            leftImage.isHidden = true;
        } else {
            leftImage.isHidden = false;
        }
    }
    
}

//
//  DriverCollectionCell.swift
//  future-v2
//
//  Created by kangyonggan on 9/8/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class DriverCollectionCell: UICollectionViewCell {

    // 控件
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    func initData(_ item: (String, String, Int)) {
        subjectLabel.text = item.0
        pageLabel.text = item.1
        
        // 边框
        self.layer.cornerRadius = 5;
        self.layer.borderColor = UIColor.lightGray.cgColor;
        self.layer.borderWidth = 1;
        
    }
    
}


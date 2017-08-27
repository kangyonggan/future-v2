//
//  MessageTableCell.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {
    
    // 控件
    @IBOutlet weak var isReadImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func initData(_ message: Message) {
        typeLabel.text = "【\(message.type!)】";
        titleLabel.text = message.title;
        
        if message.isRead {
            isReadImage.isHidden = true;
        } else {
            isReadImage.isHidden = false;
        }
    }
    
}

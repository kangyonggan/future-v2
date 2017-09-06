//
//  MusicTableViewCell.swift
//  future-v2
//
//  Created by kangyonggan on 9/6/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class MusicTableCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var downloadBtn: UIButton!
    
    // 初始化数据
    func initData(_ music: Music, isDownloaded: Bool) {
        infoLabel.text = music.singer + " - " + music.name;
        
        if isDownloaded {
            downloadImage.image = UIImage(named: "downloaded");
            downloadBtn.isEnabled = false;
        } else {
            downloadImage.image = UIImage(named: "download");
            downloadBtn.isEnabled = true;
        }
    }
    
    // 下载
    @IBAction func download(_ sender: Any) {
        downloadImage.image = UIImage(named: "downloaded");
        downloadBtn.isEnabled = false;
        
        Just.get((UrlConstants.DOMAIN + "music/" + infoLabel.text! + ".mp3").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, asyncCompletionHandler: downloadCallback)
        
    }
    
    // 下载完成回调
    func downloadCallback(res: HTTPResult) {
        if res.ok {
            let data = res.content;
            FileUtil.writeMp3(data!, withName: infoLabel.text! + ".mp3");
        } else {
            downloadImage.image = UIImage(named: "download");
            downloadBtn.isEnabled = true;
        }
    }
    
}

//
//  MusicTableViewController.swift
//  future-v2
//
//  Created by kangyonggan on 9/6/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import AVFoundation

class MusicTableViewController: UITableViewController {
    
    let CELL_ID = "MusicTableCell";
    var musics: [Music]!;
    let localMusics = FileUtil.getAllMusic();
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MusicTableCell;
        
        let music = musics[indexPath.row];
        
        cell.initData(music, isDownloaded: isDownloaded(music));
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    // 判断是否已下载
    func isDownloaded(_ music: Music) -> Bool {
        for url in localMusics {
            let info = getMusicInfo(url);
            if info.0 == music.name && info.1 == music.singer {
                return true;
            }
        }
        
        return false;
    }
    
    func getMusicInfo(_ url: URL) -> (String, String) {
        var info = ("", "");
        
        let playerItem = AVPlayerItem(url: url);
        
        // 获取歌曲信息，如：歌曲名称， 歌手名称， 专辑名称， 专辑图片等
        let orgId3 = playerItem.asset.metadata(forFormat: "org.id3");
        for item in orgId3 {
            // 解析歌曲名称
            if item.commonKey == "title" {
                let musicName = item.value as? String ?? "未知";
                info.0 = musicName;
            }
            
            // 解析歌手名称
            if item.commonKey == "artist" {
                let author = item.value as? String ?? "未知";
                info.1 = author;
            }
        }
        
        return info;
    }
    
}

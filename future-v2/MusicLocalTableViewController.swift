//
//  MusicTableViewController.swift
//  future-v2
//
//  Created by kangyonggan on 9/6/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import AVFoundation

class MusicLocalTableViewController: UITableViewController {
    
    let CELL_ID = "MusicLocalTableCell";
    var currentIndex = 0;
    var localMusics = FileUtil.getAllMusic();
    
    let dictionaryDao = DictionaryDao();
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localMusics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MusicLocalTableCell;
        
        let url = localMusics[indexPath.row];
        
        cell.initData(getMusicInfo(url), isSelected: indexPath.row == currentIndex);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 播放
        for cell in tableView.visibleCells {
            (cell as! MusicLocalTableCell).rightImage.isHidden = true;
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! MusicLocalTableCell;
        cell.rightImage.isHidden = false;
        
        // 保存当前播放的音乐下标
        dictionaryDao.delete(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.MUSIC_INDEX)
        let dict = Dictionary();
        dict.type = DictionaryKey.TYPE_DEFAULT;
        dict.key = DictionaryKey.MUSIC_INDEX;
        dict.value = String(indexPath.row);
        
        dictionaryDao.save(dict);
        
        // 发通知
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playMusic"), object: nil, userInfo: nil);
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRow(indexPath);
        }
    }
    
    // 删除数据源
    func deleteRow(_ indexPath: IndexPath) {
        // 删除本地文件
        FileUtil.deleteMp3(getMusicInfo(localMusics[indexPath.row]));
        
        localMusics.remove(at: indexPath.row);
        
        // 必须先删除数据源，否则报错
        self.tableView.deleteRows(at: [indexPath], with: .fade)
        
        Toast.showMessage("删除成功", onView: self.view)
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

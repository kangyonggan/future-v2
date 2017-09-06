//
//  MusicStoreController.swift
//  future-v2
//
//  Created by kangyonggan on 9/4/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class MusicStoreController: UIViewController {
    
    // 控件
    @IBOutlet weak var musicCountLabel: UILabel!
    @IBOutlet weak var localMusicCountLabel: UILabel!
    
    let dictionaryDao = DictionaryDao();
    
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
        
        initData();
    }
    
    // 初始化界面
    func initView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
    }
    
    // 初始化数据
    func initData() {
        // 加载乐库数量
        Http.post(UrlConstants.MUSIC_COUNT, callback: musicCountCallback)
        
        // 加载本地音乐列表
        let musics = FileUtil.getAllMusic();
        localMusicCountLabel.text = String(musics.count);
    }
    
    // 加载乐库数量的回调
    func musicCountCallback(res: HTTPResult) {
        let result = Http.parse(res);
        if result.0 {
            DispatchQueue.main.async {
                self.musicCountLabel.text = String(result.2["count"] as! Int);
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 显示导航条
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        
    }
    
    // 加载所有音乐
    @IBAction func showStore(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        loadingView = ViewUtil.loadingView(self.view);
        
        Http.post(UrlConstants.MUSIC, params: ["pageSize": 1000], callback: musicCallback)
    }
    
    // 加载所有音乐的回调
    func musicCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            var musics = [Music]();
            let data = result.2["musics"] as! NSArray;
            for m in data {
                let ms = m as! NSDictionary
                let music = Music(ms);
                
                musics.append(music);
            }
            
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MusicTableViewController") as! MusicTableViewController;
                vc.musics = musics;
                self.navigationController?.pushViewController(vc, animated: true);
            }
        } else {
            Toast.showMessage(result.1, onView: self.view);
        }
    }
    
    // 本地音乐列表
    @IBAction func localMusics(_ sender: Any) {
        let dict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.MUSIC_INDEX);
        var index = 0;
        if dict != nil {
            index = Int(dict!.value) ?? 0;
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MusicLocalTableViewController") as! MusicLocalTableViewController;
        vc.currentIndex = index;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    // 判断是否正在加载
    func isLoading() -> Bool {
        return loadingView != nil && loadingView.isAnimating;
    }
    
    // 停止加载中动画
    func stopLoading() {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
        }
    }
    
}

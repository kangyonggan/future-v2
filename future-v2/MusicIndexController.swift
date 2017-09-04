//
//  HomeIndexController.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import AVFoundation

class MusicIndexController: UIViewController {
    
    // 控件
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var loopImage: UIImageView!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeNowLabel: UILabel!
    @IBOutlet weak var timeAllLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var zhuanjiLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var zhuanjiImage: UIImageView!
    
    //播放器相关
    var playerItem: AVPlayerItem!;
    var player: AVPlayer!;
    var isPlaying = false;
    var isFirst = true;
    var isDraging = false;
    
    // 歌曲列表
    let musics = ["塞宁 - 轻微", "明萌派 - 茶汤", "龙宽九段 - 我听这种音乐的时候最爱你"];
    var currentMusicIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
        
        loadMusic(musics[currentMusicIndex]);
    }
    
    // 初始化界面
    func initView() {
        
        // 圆角
        zhuanjiImage.layer.cornerRadius = 100;
        zhuanjiImage.layer.masksToBounds = true;
    }
    
    // 加载音乐
    func loadMusic(_ name: String) {
        //初始化播放器
        //        let url = URL(string: "https://kangyonggan.com/music/demo.mp3")
        let path = Bundle.main.path(forResource: name, ofType: "mp3");
        let url = URL(fileURLWithPath: path!);
        playerItem = AVPlayerItem(url: url)
        
        // 获取歌曲信息，如：歌曲名称， 歌手名称， 专辑名称， 专辑图片等
        let orgId3 = playerItem.asset.metadata(forFormat: "org.id3");
        for item in orgId3 {
            // 解析歌曲名称
            if item.commonKey == "title" {
                let musicName = item.value as? String ?? "未知";
                nameLabel.text = "歌曲：\(musicName)";
            }
            
            // 解析歌手名称
            if item.commonKey == "artist" {
                let author = item.value as? String ?? "未知";
                authorLabel.text = "歌手：\(author)";
            }
            
            // 专辑名称
            if item.commonKey == "albumName" {
                let zhuanji = item.value as? String ?? "未知";
                zhuanjiLabel.text = "专辑：\(zhuanji)";
            }
            
            // 专辑图片
            if item.commonKey == "artwork" {
                let data = item.value as? Data;
                if data != nil {
                    zhuanjiImage.image = UIImage(data: data!);
                }
            }
        }
        
        player = AVPlayer(playerItem: playerItem!)
        
        //设置进度条相关属性
        let duration = playerItem!.asset.duration
        let seconds = CMTimeGetSeconds(duration)
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(seconds)
        timeSlider.isContinuous = false
        timeAllLabel.text = formatTime(seconds);
        
        // 进度条监听
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: DispatchQueue.main, using: changeSlider);
        
    }
    
    // 监听播放进度，修改进度条
    func changeSlider(time: CMTime) {
        if isDraging {
            return;
        }
        
        //更新进度条进度值
        let currentTime = CMTimeGetSeconds(self.player!.currentTime())
        self.timeSlider.value = Float(currentTime)
        
        //更新播放时间
        self.timeNowLabel.text = formatTime(currentTime);
        
        // 播放完毕
        if Float(currentTime) >= timeSlider.maximumValue {
            next(self);
        }
    }
    
    // 时间格式化
    func formatTime(_ time: Float64) -> String {
        let all = Int(time)
        let m = all % 60
        let f = Int(all / 60)
        var result = ""
        if f < 10 {
            result = "0\(f):"
        } else {
            result = "\(f)"
        }
        if m < 10 {
            result += "0\(m)"
        } else {
            result += "\(m)"
        }
        
        return result
    }
    
    // 旋转动画
    func anim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.fromValue = 0;
        anim.toValue = 2 * Double.pi;
        anim.isRemovedOnCompletion = false
        anim.repeatCount = MAXFLOAT;
        anim.duration = 15;
        let layer = zhuanjiImage.layer;
        layer.add(anim, forKey: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        // 导航条
        parent?.navigationItem.title = "音乐";
        
        // 隐藏导航条
        parent?.navigationController?.setNavigationBarHidden(true, animated: false);
        
        // tabbar背景色
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 57/255, green: 67/255, blue: 76/255, alpha: 1);
    }
    
    // 播放/暂停
    @IBAction func playOrPause(_ sender: Any) {
        if isFirst {
            anim();
            isFirst = false;
        }
        
        let layer = zhuanjiImage.layer;
        if isPlaying {
            player.pause();
            let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil);
            layer.speed = 0.0;
            layer.timeOffset = pausedTime;
        } else {
            player.play();
            let pausedTime = layer.timeOffset;
            layer.speed = 1.0;
            layer.timeOffset = 0.0;
            layer.beginTime = 0.0;
            let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime;
            layer.beginTime = timeSincePause;
        }
        
        isPlaying = !isPlaying;
        updateStatus();
    }
    
    // 上一曲
    @IBAction func prov(_ sender: Any) {
        currentMusicIndex -= 1;
        if currentMusicIndex < 0 {
            currentMusicIndex = musics.count - 1;
        }
        loadMusic(musics[currentMusicIndex]);
        player.play();
        isPlaying = true;
        
        updateStatus();
        anim();
    }
    
    // 下一曲
    @IBAction func next(_ sender: Any) {
        currentMusicIndex += 1;
        currentMusicIndex %= musics.count;
        loadMusic(musics[currentMusicIndex]);
        player.play();
        isPlaying = true;
        
        updateStatus();
        anim();
    }
    
    // 更新播放器各个状态
    func updateStatus() {
        if isPlaying {
            playImage.image = UIImage(named: "pause");
        } else {
            playImage.image = UIImage(named: "play");
        }
    }
    
    // 循环
    @IBAction func loop(_ sender: Any) {
        Toast.showMessage("暂时只能列表循环", onView: self.view);
    }
    
    // 列表
    @IBAction func list(_ sender: Any) {
        Toast.showMessage("暂时只能播放这几首歌", onView: self.view);
    }
    
    // 拖拽进度条
    @IBAction func drag(_ sender: Any) {
        let value = timeSlider.value;
        let time = CMTimeMake(Int64(value), 1);
        
        player.seek(to: time, completionHandler: {(b) in })
        isDraging = false;
    }
    
    // 拖拽中
    @IBAction func dragIn(_ sender: Any) {
        isDraging = true;
        let value = timeSlider.value;
        timeNowLabel.text = formatTime(Float64(value));
    }
    
}

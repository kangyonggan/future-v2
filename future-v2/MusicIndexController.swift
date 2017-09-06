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
    // 循环模式，0：列表循环，1：单曲循环，2：随机循环
    var loopMode = 0;
    let dictionaryDao = DictionaryDao();
    
    // 歌曲列表
    var musics: [URL]!;
    var currentMusicIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
        
        initData();
        
        if musics.isEmpty {
            let path = Bundle.main.path(forResource: "GALA - Young For You", ofType: "mp3");
            let url = URL(fileURLWithPath: path!);
            load(url)
        } else {
            load(musics[currentMusicIndex])
        }
    }
    
    // 初始化界面
    func initView() {
        // 圆角
        zhuanjiImage.layer.cornerRadius = 70;
        zhuanjiImage.layer.masksToBounds = true;
        
        // 通知
        NotificationCenter.default.addObserver(self, selector: #selector(playMusic(notification:)), name: NSNotification.Name(rawValue: "playMusic"), object: nil)
    }
    
    func playMusic(notification: Notification) {
        let indexDict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.MUSIC_INDEX);
        if indexDict != nil {
            currentMusicIndex = Int(indexDict!.value) ?? 0;
        }
        
        load(musics[currentMusicIndex])
        player.play();
        isPlaying = true;
        
        updateStatus();
        anim();
    }
    
    // 初始化数据
    func initData() {
        // 初始化循环模式
        let dict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.LOOP_MODE);
        if dict != nil {
            loopMode = Int(dict!.value)!;
        }
        updateLoopStatus();
        
        let indexDict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.MUSIC_INDEX);
        if indexDict != nil {
            currentMusicIndex = Int(indexDict!.value) ?? 0;
        }
        
        // 加载本地MP3
        musics = FileUtil.getAllMusic();
    }
    
    // 加载音乐
    func load(_ url: URL) {
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
        
        // 保存当前播放的音乐下标
        dictionaryDao.delete(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.MUSIC_INDEX)
        let dict = Dictionary();
        dict.type = DictionaryKey.TYPE_DEFAULT;
        dict.key = DictionaryKey.MUSIC_INDEX;
        dict.value = String(currentMusicIndex);
        
        dictionaryDao.save(dict);
    }
    
    // 监听播放进度，修改进度条
    func changeSlider(time: CMTime) {
        //更新进度条进度值
        let currentTime = CMTimeGetSeconds(self.player!.currentTime())
        
        if !isDraging {
            self.timeSlider.value = Float(currentTime)
            //更新播放时间
            self.timeNowLabel.text = formatTime(currentTime);
            
            // 播放完毕
            if Float(currentTime) >= timeSlider.maximumValue {
                if loopMode == 1 {
                    currentMusicIndex -= 1;
                }
                next(self);
            }
        } else {
            // 播放完毕, 还是播放这一首
            if Float(currentTime) >= timeSlider.maximumValue {
                currentMusicIndex -= 1;
                next(self);
            }
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
        
        // 加载本地MP3
        musics = FileUtil.getAllMusic();
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
        if musics.isEmpty {
            Toast.showMessage("只有一首歌曲", onView: self.view)
            return
        }
        
        currentMusicIndex -= 1;
        if currentMusicIndex < 0 {
            currentMusicIndex = musics.count - 1;
        }
        load(musics[currentMusicIndex]);
        player.play();
        isPlaying = true;
        
        updateStatus();
        anim();
    }
    
    // 下一曲
    @IBAction func next(_ sender: Any) {
        if musics.isEmpty {
            Toast.showMessage("只有一首歌曲", onView: self.view)
            return
        }
        
        if loopMode < 2 {
            // 列表循环
            currentMusicIndex += 1;
        } else if loopMode == 2 {
            // 随机循环
            currentMusicIndex = Int(arc4random()) % musics.count
        }
        currentMusicIndex %= musics.count;
        load(musics[currentMusicIndex]);
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
        loopMode += 1;
        loopMode %= 3;
        
        dictionaryDao.delete(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.LOOP_MODE);
        
        let dict = Dictionary();
        dict.type = DictionaryKey.TYPE_DEFAULT;
        dict.key = DictionaryKey.LOOP_MODE;
        dict.value = String(loopMode);
        dictionaryDao.save(dict);
        
        updateLoopStatus();
    }
    
    func updateLoopStatus() {
        
        if loopMode == 0 {
            loopImage.image = UIImage(named: "list-loop");
        } else if loopMode == 1 {
            loopImage.image = UIImage(named: "single-loop");
        } else {
            loopImage.image = UIImage(named: "rand-loop");
        }
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

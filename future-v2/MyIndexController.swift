//
//  MyIndexController.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class MyIndexController: UIViewController {
    
    // 控件
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var realnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageCountLabel: UILabel!
    
    // 当前用户
    var user: User!;
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView();
    }
    
    // 初始化界面
    func initView() {
        parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        user = UserService.getCurrentUser();
        
        // 去掉导航条的下边框
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        
        // 头像圆角
        avatarImage.layer.cornerRadius = 5;
        avatarImage.layer.masksToBounds = true;
    }
    
    // 查询未读消息数量回调
    func messageCountCallback(res: HTTPResult) {
        let result = Http.parse(res);
        
        if result.0 {
            let count = result.2["count"] as! Int;
            
            if count > 0 {
                DispatchQueue.main.async {
                    self.messageCountLabel.text = String(count);
                    self.messageCountLabel.layer.masksToBounds = true;
                    self.messageCountLabel.layer.cornerRadius = 10;
                    self.messageCountLabel.backgroundColor = AppConstants.MASTER_COLOR;
                }
            }
        }
    }
    
    func initData() {
        // 更新个人信息
        user = UserService.getCurrentUser();
        parent?.navigationItem.title = "我的";
        realnameLabel.text = user.realname;
        usernameLabel.text = user.username;
        
        // 加载头像 异步加载
        Http.get(user.largeAvatar, callback: avatarCallback);
        
    }
    
    // 加载头像的回调
    func avatarCallback(res: HTTPResult) {
        if res.ok {
            let img = UIImage(data: res.content!)
            DispatchQueue.main.async {
                self.avatarImage.image = img;
            }
        } else {
            let img = UIImage(named: "120");
            DispatchQueue.main.async {
                self.avatarImage.image = img;
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        initData();
        
        // 查询未读消息数量
        messageCountLabel.backgroundColor = UIColor.white;
        Http.post(UrlConstants.MESSAGE_COUNT, params:["username": user.username], callback: messageCountCallback)
    }
    
    // 查看系统消息
    @IBAction func showMessages(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        // 加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        // 异步加载全部消息
        Http.post(UrlConstants.MESSAGE_ALL, params:["username": user.username], callback: allMessageCallback)
    }
    
    // 查看所有消息
    func allMessageCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            var messages = [Message]();
            
            let msgs = result.2["messages"] as! NSArray;
            for msg in msgs {
                let m = msg as! NSDictionary
                let message = Message(m);
                
                messages.append(message);
            }
            
            if messages.isEmpty {
                Toast.showMessage("没有系统消息", onView: self.view);
                return;
            }
            
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageTableViewController") as! MessageTableViewController;
                vc.messages = messages;
                self.navigationController?.pushViewController(vc, animated: true);
            }
            
        } else {
            Toast.showMessage(result.1, onView: self.view);
        }
    }
    
    // 注销
    @IBAction func logout(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController;
        vc.isJump = true;
        self.navigationController?.pushViewController(vc, animated: false);
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

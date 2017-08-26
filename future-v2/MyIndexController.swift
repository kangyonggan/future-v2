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
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var realnameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView();
        
        initData();
        
    }
    
    func initView() {
        parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        // 去掉导航条的下边框
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        
        // 头像圆角
        avatarImage.layer.cornerRadius = 5;
        avatarImage.layer.masksToBounds = true;
    }
    
    func initData() {
        // 当前用户数据
        let user = UserService.getCurrentUser()!;
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
        
        parent?.navigationItem.title = "我的";
        let user = UserService.getCurrentUser()!;
        realnameLabel.text = user.realname;
    }
    
    // 注销
    @IBAction func logout(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController;
        vc.isJump = true;
        self.navigationController?.pushViewController(vc, animated: false);
    }
    
}

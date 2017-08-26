//
//  UserInfoController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class UserInfoController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var realnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
        
        initData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        let user = UserService.getCurrentUser()!;
        realnameLabel.text = user.realname;
        if user.email!.isEmpty {
            emailLabel.text = "未填写";
        } else {
            emailLabel.text = user.email;
        }
        
    }
    
    func initView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        // 头像圆角
        avatarImage.layer.cornerRadius = 5;
        avatarImage.layer.masksToBounds = true;
        
    }
    
    func initData() {
        // 当前用户数据
        let user = UserService.getCurrentUser()!;
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
    
    // 退出登录
    @IBAction func logout(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController;
        vc.isJump = true;
        self.navigationController?.show(vc, sender: nil);
    }
    
    
}

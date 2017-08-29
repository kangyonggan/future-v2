//
//  UserInfoController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class UserInfoController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var realnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        initData();
        
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
        CacheImage().load(named: user.largeAvatar, to: avatarImage, withDefault: "120");
        
        realnameLabel.text = user.realname;
        if user.email!.isEmpty {
            emailLabel.text = "未填写";
        } else {
            emailLabel.text = user.email;
        }
    }
    
    // 退出登录
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "退出登录后不会删除您的数据，下次登录后数据仍然会存在。", message: nil, preferredStyle: .actionSheet);
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil);
        
        let okBtn = UIAlertAction(title: "退出登录", style: .destructive, handler: logoutOk)
        
        alert.addAction(cancelBtn);
        alert.addAction(okBtn);
        
        self.present(alert, animated: true, completion: nil);
    }
    
    // 确定退出
    func logoutOk(_ action: UIAlertAction) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController;
        vc.isJump = true;
        self.navigationController?.show(vc, sender: nil);
        
    }
    
    
}

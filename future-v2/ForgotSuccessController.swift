//
//  ForgotSuccessController.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ForgotSuccessController: UIViewController {
    
    @IBOutlet weak var goLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        // 立马登录按钮
        goLoginBtn.layer.cornerRadius = 20;
        goLoginBtn.layer.masksToBounds = true;
        
        // 隐藏返回按钮
        self.navigationItem.hidesBackButton = true;
    }
    
    // 跳转到登录界面
    @IBAction func jumpToLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController;
        vc.isJump = true;
        self.navigationController?.show(vc, sender: nil);
    }
}

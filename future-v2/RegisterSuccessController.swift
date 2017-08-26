//
//  RegisterSuccessController.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//
import UIKit

class RegisterSuccessController: UIViewController {
    
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
}

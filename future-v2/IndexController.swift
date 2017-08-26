//
//  IndexController.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class IndexController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        // 导航条设置
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        self.navigationItem.hidesBackButton = true;
    }
}

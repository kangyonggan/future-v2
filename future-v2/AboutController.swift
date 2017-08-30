//
//  AboutController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class AboutController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        // 图片
        logoImage.layer.cornerRadius = 20;
        logoImage.layer.masksToBounds = true;
    }
    
    // 评分
    @IBAction func pingFen(_ sender: Any) {
        Toast.showMessage("该App暂未上架，无法评分！", onView: self.view);
    }
    
}

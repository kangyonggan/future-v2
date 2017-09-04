//
//  AboutFunctionController.swift
//  future-v2
//
//  Created by kangyonggan on 8/28/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class AboutFunctionController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // 设置标题
        self.navigationItem.title = "功能介绍";
        
        // 请求消息详情界面
        let request = URLRequest(url: URL(string: UrlConstants.DOMAIN + UrlConstants.MESSAGE + "10")!);
        
        webView.loadRequest(request);
    }
    
}

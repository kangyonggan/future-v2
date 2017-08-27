//
//  MessageDetailController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class MessageDetailController: UIViewController {
    
    // 控件
    @IBOutlet weak var webView: UIWebView!
    
    // 数据
    var message: Message!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData();
    }
    
    // 初始化数据
    func initData() {
        // 设置标题
        self.navigationItem.title = message.title;
        
        // 请求消息详情界面
        let request = URLRequest(url: URL(string: UrlConstants.DOMAIN + UrlConstants.MESSAGE + "\(message.id!)")!);
        
        webView.loadRequest(request);
    }
    
    
}

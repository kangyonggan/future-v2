//
//  AdviceController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//


import UIKit
import Just

class AdviceController: UIViewController {
    
    // 控件
    @IBOutlet weak var contenInput: UITextView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    // 提交
    @IBAction func submit(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        let content = contenInput.text!;
        
        if StringUtil.trim(content).characters.count < 10 {
            Toast.showMessage("输入的内容不能低于十个字符", onView: self.view)
            return;
        }
        
        // 启动加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        let user = UserService.getCurrentUser();
        
        // 使用异步请求
        Http.post(UrlConstants.MESSAGE_ADVICE, params: ["username": user!.username, "content": content], callback: adviceCallback)
    }
    
    // 意见反馈的回调
    func adviceCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true);
            }
        } else {
            Toast.showMessage(result.1, onView: self.view);
        }
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



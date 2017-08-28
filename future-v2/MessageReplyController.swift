//
//  MessageReplyController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class MessageReplyController: UIViewController, UIWebViewDelegate {

    // 控件
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var replyInput: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    // 数据
    var message: Message!;
    var replyMessage: Message?;
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
        
        initData();
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextFillColor='#555555'");
    }
    
    // 初始化界面
    func initView() {
        webView.delegate = self;
        
        if replyMessage != nil {
            submitBtn.isEnabled = false;
            submitBtn.backgroundColor = UIColor.lightGray;
            label.text = "已被\(replyMessage!.createdUsername!)回复，内容如下";
        }
    }
    
    // 初始化数据
    func initData() {
        self.navigationItem.title = self.message.title;
        self.webView.loadHTMLString(self.message.content!, baseURL: nil);
        
        if (replyMessage != nil) {
            replyInput.text = replyMessage?.content;
        }
    }
    
    // 提交
    @IBAction func submit(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        let content = replyInput.text!;
        
        if StringUtil.trim(content).characters.count < 10 {
            Toast.showMessage("回复的内容不能低于十个字符", onView: self.view)
            return;
        }
        
        // 启动加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        let user = UserService.getCurrentUser();
        
        // 使用异步请求
        Http.post(UrlConstants.MESSAGE_REPLY, params: ["username": user!.username, "messageId": message.id, "content": content], callback: replyCallback)
        
    }
    
    // 回复消息的回调
    func replyCallback(res: HTTPResult) {
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



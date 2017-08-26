//
//  EmailController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//


import UIKit
import Just

class EmailController: UIViewController {
    
    // 控件
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var finishBtn: UIButton!
    
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    var email: String!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        // 输入框缩进
        ViewUtil.addLeftView(emailInput, withIcon: "empty", width: 10, height: 20);
        
        // 按钮禁用的背景色
        finishBtn.backgroundColor = UIColor.lightGray;
        
        // 获取邮箱
        let user = UserService.getCurrentUser();
        email = user!.email;
        emailInput.text = email;
    }
    
    // 修改邮箱
    @IBAction func changeEmail(_ sender: Any) {
        let em = emailInput.text!;
        
        if StringUtil.trim(em).isEmpty || em == email || em.characters.count > 64 {
            finishBtn.isEnabled = false;
            finishBtn.backgroundColor = UIColor.lightGray;
        } else {
            finishBtn.isEnabled = true;
            finishBtn.backgroundColor = AppConstants.MASTER_COLOR;
        }
    }
    
    // 完成
    @IBAction func finish(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        // 启动加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        let user = UserService.getCurrentUser();
        
        // 使用异步请求
        Http.post(UrlConstants.USER_UPDATE, params: ["username": user!.username, "email": StringUtil.trim(emailInput.text!)], callback: updateUserEmailCallback)
        
    }
    
    // 修改邮箱回调
    func updateUserEmailCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            // 修改本地用户信息
            let user = UserService.getCurrentUser();
            user?.email = StringUtil.trim(emailInput.text!);
            UserService.updateUser(user!);
            
            // 返回
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


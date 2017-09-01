//
//  RegisterController.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class RegisterController: UIViewController {
    
    // 控件
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var authCodeInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var authCodeBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    // 标识
    var isShowPassword = false;// 是否显示密码
    
    // 获取验证码倒计时
    var timer: Timer?;
    var time = 0;
    
    // 加载中菊花图标
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    // 初始化界面
    func initView() {
        // 显示导航条
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        
        // 输入框加下边框
        ViewUtil.addBorderBottom(usernameInput, withColor: UIColor.gray);
        ViewUtil.addBorderBottom(authCodeInput, withColor: UIColor.gray);
        ViewUtil.addBorderBottom(passwordInput, withColor: UIColor.gray);
        
        // 输入框加左侧图标
        ViewUtil.addLeftView(usernameInput, withIcon: "mobile", width: 30, height: 20);
        ViewUtil.addLeftView(authCodeInput, withIcon: "auth-code", width: 30, height: 20);
        ViewUtil.addLeftView(passwordInput, withIcon: "password", width: 30, height: 20);
        
        // 密码框右侧图标
        let rightView = UIImageView(frame: CGRect(x: passwordInput.frame.width - 30, y: 0, width: 20, height: 20));
        rightView.image = UIImage(named: "eye");
        passwordInput.rightView = rightView;
        passwordInput.rightViewMode = UITextFieldViewMode.always;
        
        // 查看密码事件监听/////添加tapGuestureRecognizer手势
        rightView.isUserInteractionEnabled = true;
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)));
        rightView.addGestureRecognizer(tapGR)
        
        // 获取验证码按钮
        authCodeBtn.layer.cornerRadius = 5;
        authCodeBtn.layer.masksToBounds = true;
        authCodeBtn.backgroundColor = AppConstants.MASTER_COLOR;
        
        // 提交按钮
        submitBtn.layer.cornerRadius = 20;
        submitBtn.layer.masksToBounds = true;
        submitBtn.backgroundColor = UIColor.lightGray;
    }
    
    // 手势处理函数
    func tapHandler(sender: UITapGestureRecognizer) {
        if isShowPassword {
            (passwordInput.rightView as! UIImageView).image = UIImage(named: "eye");
            passwordInput.isSecureTextEntry = true;
        } else {
            (passwordInput.rightView as! UIImageView).image = UIImage(named: "eye-selected");
            passwordInput.isSecureTextEntry = false;
        }
        
        isShowPassword = !isShowPassword;
    }
    
    // 结束输入用户名
    @IBAction func endInputUsername(_ sender: Any) {
        authCodeBtn.becomeFirstResponder();
    }
    
    // 结束输入验证码
    @IBAction func endInputAuthCode(_ sender: Any) {
        passwordInput.becomeFirstResponder();
    }
    
    // 结束输入密码
    @IBAction func endInputPassword(_ sender: Any) {
        submitBtn.becomeFirstResponder();
    }
    
    // 输入用户名
    @IBAction func usernameChange(_ sender: Any) {
        passwordChange(sender)
    }
    
    // 输入验证码
    @IBAction func authCodeChange(_ sender: Any) {
        passwordChange(sender)
    }
    
    // 输入密码
    @IBAction func passwordChange(_ sender: Any) {
        let username =  usernameInput.text!;
        let password = passwordInput.text!;
        let authCode = authCodeInput.text!;
        
        if !(username.isEmpty || password.isEmpty || authCode.isEmpty) {
            submitBtn.isEnabled = true;
            submitBtn.backgroundColor = AppConstants.MASTER_COLOR;
        } else {
            submitBtn.isEnabled = false;
            submitBtn.backgroundColor = UIColor.lightGray;
        }
    }
    
    // 获取验证码
    @IBAction func getAuthCode(_ sender: Any) {
        
        // 收起键盘
        UIApplication.shared.keyWindow?.endEditing(true);
        
        if isLoading() {
            return;
        }
        
        let username =  usernameInput.text!;
        if !StringUtil.isMobile(username) {
            Toast.showMessage("请输入正确的手机号", onView: self.view);
            return;
        }
        
        // 启动加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        // 使用异步请求
        Http.post(UrlConstants.AUTH_CODE, params: ["mobile": username, "type": "REGISTER"], callback: authCodeCallback)
    }
    
    // 获取验证码的回调
    func authCodeCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            Toast.showMessage("获取验证码成功", onView: self.view);
            
            DispatchQueue.main.async {
                self.time = 0;
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateAuthCodeBtn), userInfo: nil, repeats: true);
                self.authCodeBtn.isEnabled = false;
                self.authCodeBtn.backgroundColor = UIColor.lightGray;
            }
        } else {
            Toast.showMessage(result.1, onView: self.view);
        }
    }
    
    // 更新获取验证码按钮
    func updateAuthCodeBtn() {
        self.time += 1;
        self.authCodeBtn.setTitle("\(60-self.time)秒", for: UIControlState.normal);
        
        if (self.time > 60) {
            self.time = 0;
            self.authCodeBtn.isEnabled = true;
            self.authCodeBtn.backgroundColor = AppConstants.MASTER_COLOR;
            self.timer?.invalidate();
            self.authCodeBtn.setTitle("重新获取", for: UIControlState.normal);
        }
    }
    
    // 提交
    @IBAction func submit(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        let username =  usernameInput.text!;
        let password = passwordInput.text!;
        let authCode = authCodeInput.text!;
        
        if username.characters.count != 11 {
            Toast.showMessage("请输入正确的手机号", onView: self.view);
            return;
        }
        
        if authCode.characters.count != 4 {
            Toast.showMessage("验证码的长度必须是4位", onView: self.view);
            return;
        }
        
        if password.characters.count < 8 || password.characters.count > 20 {
            Toast.showMessage("密码长度为8-20位", onView: self.view);
            return;
        }
        
        // 启动加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        // 使用异步请求
        Http.post(UrlConstants.REGISTER, params: ["username": username, "password":password, "authCode": authCode], callback: registerCallback)
    }
    
    // 注册回调
    func registerCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            // 跳转到注册成功界面
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterSuccessController");
                self.navigationController?.pushViewController(vc!, animated: true);
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

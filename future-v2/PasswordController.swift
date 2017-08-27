//
//  PasswordController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class PasswordController: UIViewController {
    
    // 控件
    @IBOutlet weak var oldPasswordInput: UITextField!
    @IBOutlet weak var newPasswordInput: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    // 标识
    var isShowPassword = false;// 是否显示密码
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    // 初始化控件
    func initView() {
        // 输入框加下边框
        ViewUtil.addBorderBottom(oldPasswordInput, withColor: UIColor.gray);
        ViewUtil.addBorderBottom(newPasswordInput, withColor: UIColor.gray);
        
        // 输入框加左侧图标
        ViewUtil.addLeftView(oldPasswordInput, withIcon: "password", width: 30, height: 20);
        ViewUtil.addLeftView(newPasswordInput, withIcon: "password", width: 30, height: 20);
        
        // 密码框右侧图标
        let rightView = UIImageView(frame: CGRect(x: newPasswordInput.frame.width - 30, y: 0, width: 20, height: 20));
        rightView.image = UIImage(named: "eye");
        newPasswordInput.rightView = rightView;
        newPasswordInput.rightViewMode = UITextFieldViewMode.always;
        
        // 查看密码事件监听/////添加tapGuestureRecognizer手势
        rightView.isUserInteractionEnabled = true;
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)));
        rightView.addGestureRecognizer(tapGR)
        
        // 提交按钮
        submitBtn.layer.cornerRadius = 20;
        submitBtn.layer.masksToBounds = true;
        submitBtn.backgroundColor = UIColor.lightGray;
    }
    
    // 手势处理函数
    func tapHandler(sender: UITapGestureRecognizer) {
        if isShowPassword {
            (newPasswordInput.rightView as! UIImageView).image = UIImage(named: "eye");
            newPasswordInput.isSecureTextEntry = true;
        } else {
            (newPasswordInput.rightView as! UIImageView).image = UIImage(named: "eye-selected");
            newPasswordInput.isSecureTextEntry = false;
        }
        
        isShowPassword = !isShowPassword;
    }
    
    @IBAction func endInputOldPassword(_ sender: Any) {
        newPasswordInput.becomeFirstResponder()
    }
    
    @IBAction func endInputNewPassword(_ sender: Any) {
        submitBtn.becomeFirstResponder();
    }
    
    // 修改老密码
    @IBAction func changeOldPassword(_ sender: Any) {
    }
    
    // 修改新密码
    @IBAction func changeNewPassword(_ sender: Any) {
        let oldPassword = oldPasswordInput.text!;
        let newPassword = newPasswordInput.text!;
        
        if !(oldPassword.isEmpty || newPassword.isEmpty) {
            submitBtn.isEnabled = true;
            submitBtn.backgroundColor = AppConstants.MASTER_COLOR;
        } else {
            submitBtn.isEnabled = false;
            submitBtn.backgroundColor = UIColor.lightGray;
        }
    }
    
    // 提交
    @IBAction func submit(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        let newPassword =  newPasswordInput.text!;
        let oldPassword = oldPasswordInput.text!;
        
        if oldPassword.characters.count < 8 || oldPassword.characters.count > 20 {
            Toast.showMessage("旧密码长度为8-20位", onView: self.view);
            return;
        }
        
        if newPassword.characters.count < 8 || newPassword.characters.count > 20 {
            Toast.showMessage("新密码长度为8-20位", onView: self.view);
            return;
        }
        
        let user = UserService.getCurrentUser();
        
        // 启动加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        // 使用异步请求
        Http.post(UrlConstants.UPDATE_PASSWORD, params: ["username": user!.username, "token": user!.token!, "oldPassword": oldPassword, "password": newPassword], callback: passwordUpdateCallback)
    }
    
    // 提交回调
    func passwordUpdateCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
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

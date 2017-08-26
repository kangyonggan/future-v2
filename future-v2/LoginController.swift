//
//  LoginController.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class LoginController: UIViewController {
    
    // 控件
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    // 标识
    var isShowPassword = false;// 是否显示密码
    var isJump = false;// 是否是其他界面跳转过来的
    
    // 加载中菊花图标
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        if !isJump {
            launchAnimation();
            
            tryLogin();
        } else {
            // 删除用户的token
            let user = UserService.getCurrentUser();
            if user != nil {
                user!.token = "";
                
                UserService.updateUser(user!);
            }
        }
    }
    
    // 尝试登录
    func tryLogin() {
        // 取出本地token，尝试直接登录
        let user = UserService.getCurrentUser();
        if user != nil && !(user!.token?.isEmpty)! {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IndexController");
            self.navigationController?.pushViewController(vc!, animated: false);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隐藏导航条
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
    // 初始化界面
    func initView() {
        // 修改返回按钮
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        // 图片
        imageView.layer.cornerRadius = 25;
        imageView.layer.masksToBounds = true;
        
        // 输入框加下边框
        ViewUtil.addBorderBottom(usernameInput, withColor: UIColor.gray);
        ViewUtil.addBorderBottom(passwordInput, withColor: UIColor.gray);
        
        // 输入框加左侧图标
        ViewUtil.addLeftView(usernameInput, withIcon: "mobile", width: 30, height: 20);
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
        
        // 登录按钮
        loginBtn.layer.cornerRadius = 20;
        loginBtn.layer.borderWidth = 1;
        loginBtn.layer.borderColor = UIColor.gray.cgColor;
        loginBtn.layer.masksToBounds = true;
        
        // 忘记密码和注册之间的竖线
        let line = UIView(frame: CGRect(x: bottomView.frame.width / 2, y: 0, width: 1, height: bottomView.frame.height));
        line.backgroundColor = UIColor.gray;
        bottomView.addSubview(line);
        
        // 用户名初始化
        let user = UserService.getCurrentUser();
        if user != nil {
            usernameInput.text = user!.username;
        }
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
    
    // 用户名改变
    @IBAction func usernameChanged(_ sender: Any) {
        passwordChanged(sender);
    }
    
    // 密码改变
    @IBAction func passwordChanged(_ sender: Any) {
        let username =  usernameInput.text!;
        let password = passwordInput.text!;
        
        if !(username.isEmpty || password.isEmpty) {
            loginBtn.isEnabled = true;
        } else {
            loginBtn.isEnabled = false;
        }
    }
    
    // 用户名输入结束
    @IBAction func endInputUsername(_ sender: Any) {
        // 焦点给密码框
        passwordInput.becomeFirstResponder();
    }
    
    // 密码输入结束
    @IBAction func endInputPassword(_ sender: Any) {
        // 焦点给登录按钮
        loginBtn.becomeFirstResponder();
    }
    
    // 登录
    @IBAction func login(_ sender: Any) {
        let username =  usernameInput.text!;
        let password = passwordInput.text!;
        
        if isLoading() {
            return;
        }
        
        if !StringUtil.isMobile(username) {
            Toast.showMessage("请输入正确的手机号", onView: view);
            return;
        }
        
        if password.characters.count < 8 || password.characters.count > 20 {
            Toast.showMessage("密码长度为8-20位", onView: view);
            return;
        }
        
        // 加载中菊花
        loadingView = ViewUtil.loadingView(view);
        
        // 异步请求，回调
        Http.post(UrlConstants.LOGIN, params: ["username": username, "password":password], callback: loginCallback)
    }
    
    // 登录回调
    func loginCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            let u = result.2["user"] as! NSDictionary;
            let user = User(u);
            user.token = result.2["token"] as? String;
            
            UserService.saveUser(user);
            
            // 在主线程中操作UI，跳转界面
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "IndexController");
                self.navigationController?.pushViewController(vc!, animated: true);
            }
        } else {
            // 在主线程中操作UI，提示用户
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
    
    // 播放启动画面动画
    private func launchAnimation() {
        // 获取启动视图
        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "Launch")
        let launchview = vc.view!
        let delegate = UIApplication.shared.delegate
        delegate?.window!!.addSubview(launchview)
        // 如果没有导航栏，直接添加到当前的view即可
        self.view.addSubview(launchview)
        
        // 播放动画效果，完毕后将其移除
        UIView.animate(withDuration: 1, delay: 1.5, options: .beginFromCurrentState,
                       animations: {
                        launchview.alpha = 0.0
                        let transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
                        launchview.layer.transform = transform
        }) { (finished) in
            launchview.removeFromSuperview()
        }
    }
}

//
//  RealnameController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class RealnameController: UIViewController {
    
    // 控件
    @IBOutlet weak var realnameInput: UITextField!
    @IBOutlet weak var finishBtn: UIButton!
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    var realname: String!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        // 输入框缩进
        ViewUtil.addLeftView(realnameInput, withIcon: "empty", width: 10, height: 20);
        
        // 按钮禁用的背景色
        finishBtn.backgroundColor = UIColor.lightGray;
        
        // 获取名字
        let user = UserService.getCurrentUser();
        realname = user!.realname;
        realnameInput.text = realname;
    }
    
    // 修改名字
    @IBAction func changeRealname(_ sender: Any) {
        let rn = realnameInput.text!;
        
        if StringUtil.trim(rn).isEmpty || rn == realname || rn.characters.count < 2 || rn.characters.count > 32 {
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
        Http.post(UrlConstants.USER_UPDATE, params: ["username": user!.username, "realname": StringUtil.trim(realnameInput.text!)], callback: updateUserRealnameCallback)
        
    }
    
    // 修改名字回调
    func updateUserRealnameCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            // 修改本地用户信息
            let user = UserService.getCurrentUser();
            user?.realname = StringUtil.trim(realnameInput.text!);
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

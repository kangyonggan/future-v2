//
//  IdcardVerifyController.swift
//  future-v2
//
//  Created by kangyonggan on 8/30/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class IdcardVerifyController: UIViewController {

    // 控件
    @IBOutlet weak var idcardInput: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var resultText: UITextView!
    
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    // 初始化界面
    func initView() {
        // 输入框加下边框
        ViewUtil.addBorderBottom(idcardInput, withColor: UIColor.gray);
        
        // 按钮
        verifyBtn.layer.cornerRadius = 20;
        verifyBtn.layer.masksToBounds = true;
        
        // 长按事件
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.saveResult))
        self.resultText.isUserInteractionEnabled = true;
        self.resultText.addGestureRecognizer(longPress)
    }
    // 长按保存结果
    func saveResult() {
        if resultText.text!.isEmpty {
            return;
        }
        
        let alert = UIAlertController(title: "是否需要复制校验结果？", message: nil, preferredStyle: .actionSheet);
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil);
        
        let okBtn = UIAlertAction(title: "复制", style: .destructive, handler: copyResult)
        
        alert.addAction(cancelBtn);
        alert.addAction(okBtn);
        
        self.present(alert, animated: true, completion: nil);
    }
    
    // 复制
    func copyResult(_ action: UIAlertAction) {
        UIPasteboard.general.string = resultText.text!;
        Toast.showMessage("复制成功", onView: self.view);
        
    }
    
    // 结束输入身份证
    @IBAction func endInputIdcard(_ sender: Any) {
        verifyBtn.becomeFirstResponder();
    }
    
    // 开始校验
    @IBAction func verify(_ sender: Any) {
        // 收起键盘
        UIApplication.shared.keyWindow?.endEditing(true);
        
        let idcard = idcardInput.text!;
        
        if idcard.isEmpty {
            Toast.showMessage("身份证号码不能为空", onView: self.view);
            return
        }
        
        resultText.text = "";
        
        loadingView = ViewUtil.loadingView(self.view)
        
        Http.post(UrlConstants.TOOL_IDCARD_VERIFY, params: ["idcard": idcard], callback: verifyCallback)
    }
    
    // 校验的回调
    func verifyCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            let data = result.2;
            let isIdCard = data["idCard"] as! Bool;
            if isIdCard {
                let province = data["province"] as! String;
                let age = data["age"] as! Int;
                let year = data["year"] as! String;
                let month = data["month"] as! String;
                let day = data["day"] as! String;
                let sex = data["sex"] as! String;
                let area = data["area"] as! String;
                let shengXiao = data["shengXiao"] as! String;
                let ganZhi = data["ganZhi"] as! String;
                let yunshi = data["yunshi"] as! String;
                let transCard = data["transCard"] as! String;
                
                var dispText = "省份: " + province + "\n";
                dispText += "地区: " + area + "\n";
                dispText += "性别: " + sex + "\n";
                dispText += "生日: " + year + "年" + month + "月" + day + "日" + "\n";
                dispText += "年龄: " + String(age) + "周岁\n";
                if idcardInput.text!.characters.count > 16 {
                    dispText += "转成15位: " + transCard + "\n";
                } else {
                    dispText += "转成18位: " + transCard + "\n";
                }
                dispText += "生肖: " + shengXiao + "\n";
                dispText += "出生年份: " + ganZhi + "\n";
                dispText += "运势: " + yunshi + "\n";
                
                DispatchQueue.main.async {
                    self.resultText.text = dispText;
                }
                
            } else {
                DispatchQueue.main.async {
                    self.resultText.text = "您输入的不是合法的身份证号码";
                }
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

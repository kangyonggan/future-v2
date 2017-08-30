//
//  IdcardGenerateController.swift
//  future-v2
//
//  Created by kangyonggan on 8/30/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class IdcardGenerateController: UIViewController {
    
    // 控件
    @IBOutlet weak var generateBtn: UIButton!
    @IBOutlet weak var provInput: UITextField!
    @IBOutlet weak var ageMinInput: UITextField!
    @IBOutlet weak var ageMaxInput: UITextField!
    @IBOutlet weak var sexRandImage: UIImageView!
    @IBOutlet weak var sexMaleImage: UIImageView!
    @IBOutlet weak var sexFemaleImage: UIImageView!
    @IBOutlet weak var lenRandImage: UIImageView!
    @IBOutlet weak var len18Image: UIImageView!
    @IBOutlet weak var len15Image: UIImageView!
    @IBOutlet weak var countInput: UITextField!
    @IBOutlet weak var resultText: UITextView!
    
    var loadingView: UIActivityIndicatorView!;
    
    var sex = -1;// -1: 随机，0：男，1：女
    var len = -1;// -1: 随机，15：15为，18：18位
    var prov = ("", "随机");// province's code, name
    var idcardArr = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView();
    }
    
    // 选择省份
    @IBAction func selectProv(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProvinceTableViewController") as! ProvinceTableViewController;
        vc.selectedProv = self.prov;
        vc.provs = AppConstants.provs();
        vc.viewController = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    // 选择省份
    func selectProv(_ prov: (String, String)) {
        self.prov = prov;
        if prov.0.isEmpty {
            provInput.text = prov.1;
        } else {
            provInput.text = prov.1 + "[" + prov.0 + "]";
        }
    }
    
    // 结束输入最小年龄
    @IBAction func endInputAgeMin(_ sender: Any) {
        ageMaxInput.becomeFirstResponder();
    }
    
    // 结束输入最大年龄
    @IBAction func endInputAgeMax(_ sender: Any) {
        // 收起键盘
        UIApplication.shared.keyWindow?.endEditing(true);
    }
    
    // 性别随机
    @IBAction func sexRand(_ sender: Any) {
        sexRandImage.image = UIImage(named: "radio-selected");
        sexMaleImage.image = UIImage(named: "radio-no-selected");
        sexFemaleImage.image = UIImage(named: "radio-no-selected");
        
        sex = -1;
    }
    
    // 性别男
    @IBAction func sexMale(_ sender: Any) {
        sexRandImage.image = UIImage(named: "radio-no-selected");
        sexMaleImage.image = UIImage(named: "radio-selected");
        sexFemaleImage.image = UIImage(named: "radio-no-selected");
        
        sex = 0;
    }
    
    // 性别女
    @IBAction func sexFemale(_ sender: Any) {
        sexRandImage.image = UIImage(named: "radio-no-selected");
        sexMaleImage.image = UIImage(named: "radio-no-selected");
        sexFemaleImage.image = UIImage(named: "radio-selected");
        
        sex = 1;
    }
    
    // 长度随机
    @IBAction func lenRand(_ sender: Any) {
        lenRandImage.image = UIImage(named: "radio-selected");
        len18Image.image = UIImage(named: "radio-no-selected");
        len15Image.image = UIImage(named: "radio-no-selected");
        
        len = -1;
    }
    
    // 长度18
    @IBAction func len18(_ sender: Any) {
        lenRandImage.image = UIImage(named: "radio-no-selected");
        len18Image.image = UIImage(named: "radio-selected");
        len15Image.image = UIImage(named: "radio-no-selected");
        
        len = 18;
    }
    
    // 长度15
    @IBAction func len15(_ sender: Any) {
        lenRandImage.image = UIImage(named: "radio-no-selected");
        len18Image.image = UIImage(named: "radio-no-selected");
        len15Image.image = UIImage(named: "radio-selected");
        
        len = 15;
    }
    
    // 结束输入数量
    @IBAction func endInputCount(_ sender: Any) {
        generateBtn.becomeFirstResponder();
    }
    
    // 生成
    @IBAction func generate(_ sender: Any) {
        // 收起键盘
        UIApplication.shared.keyWindow?.endEditing(true);
        
        if isLoading() {
            return
        }
        
        loadingView = ViewUtil.loadingView(self.view);
        
        Http.post(UrlConstants.TOOL_IDCARD_GENERATE, params: ["prov": prov.0, "startAge": ageMinInput.text!, "endAge": ageMaxInput.text!, "sex": String(sex), "len": String(len), "size": countInput.text!], callback: generateCallback)
    }
    
    // 生成回调
    func generateCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            let data = result.2["idcards"] as! NSArray;
            var idcards = "";
            idcardArr = [];
            var i = 1;
            for idcard in data {
                idcards += String(i) + "：" + (idcard as! String) + "\n";
                i += 1;
                idcardArr.insert(idcard as! String, at: 0);
            }
            
            DispatchQueue.main.async {
                self.resultText.text = idcards;
            }
        } else {
            Toast.showMessage(result.1, onView: self.view);
        }
    }
    
    // 初始化控件
    func initView()  {
        
        // 按钮
        generateBtn.layer.cornerRadius = 20;
        generateBtn.layer.masksToBounds = true;
        
        // 长按事件
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.saveResult))
        self.resultText.isUserInteractionEnabled = true;
        self.resultText.addGestureRecognizer(longPress)
    }
    
    // 长按保存结果
    func saveResult() {
        if idcardArr.isEmpty {
            return;
        }
        
        let alert = UIAlertController(title: "是否需要复制生成的身份证号码？", message: nil, preferredStyle: .actionSheet);
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil);
        
        let okBtn = UIAlertAction(title: "全部复制", style: .destructive, handler: copyAll)
        
        alert.addAction(cancelBtn);
        alert.addAction(okBtn);
        
        self.present(alert, animated: true, completion: nil);
    }
    
    // 全部复制
    func copyAll(_ action: UIAlertAction) {
        UIPasteboard.general.string = resultText.text!;
        Toast.showMessage("复制成功", onView: self.view);
        
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

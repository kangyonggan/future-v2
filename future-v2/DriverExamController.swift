//
//  ExamController.swift
//  future-v2
//
//  Created by kangyonggan on 9/8/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class DriverExamController: UIViewController {
    
    // 控件
    @IBOutlet weak var questionLabel: UITextView!
    @IBOutlet weak var picLabel: UILabel!
    @IBOutlet weak var picView: UIView!
    @IBOutlet weak var picImage: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var aImage: UIImageView!
    @IBOutlet weak var aOptionLabel: UILabel!
    @IBOutlet weak var bImage: UIImageView!
    @IBOutlet weak var bOptionLabel: UILabel!
    @IBOutlet weak var cImage: UIImageView!
    @IBOutlet weak var cOptionLabel: UILabel!
    @IBOutlet weak var dImage: UIImageView!
    @IBOutlet weak var dOptionLabel: UILabel!
    
    var item: (String, String, Int)!;
    var loadingView: UIActivityIndicatorView!;
    
    var storages = [Storage]();
    var currentIndex = 0;
    var answers: [String]!;
    
    override func viewDidLoad() {
        
        initData();
        
        // 左滑 右滑
        handleSwipeGesture();
    }
    
    // 左滑又滑
    func handleSwipeGesture(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextStorage))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(provStorage))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    // 上一题
    func provStorage() {
        if currentIndex == 0 {
            Toast.showMessage("已经是第一题了", onView: self.view);
            return
        }
        
        currentIndex -= 1;
        
        updateContent();
    }
    
    // 下一题
    func nextStorage() {
        if currentIndex == storages.count - 1 {
            
            let alertController = UIAlertController(title: "系统评分", message: calcRight(), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "重做", style: .cancel, handler: {
                action in
                self.currentIndex = 0;
                self.answers = [String](repeating: "0", count: self.storages.count);
                self.updateContent();
            })
            let okAction = UIAlertAction(title: "换一套", style: .default, handler: {
                action in
                self.navigationController?.popViewController(animated: true);
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        currentIndex += 1;
        
        updateContent();
    }
    
    // 初始化数据
    func initData() {
        if isLoading() {
            return;
        }
        
        loadingView = ViewUtil.loadingView(self.view);
        
        var s = "4";
        if item.0 == "科目一" {
            s = "1";
        }
        
        Http.post(UrlConstants.STORAGE_LIST, params: ["s": s, "p": String(item.2)], callback: callback);
    }
    
    // 回调
    func callback(res: HTTPResult) {
        stopLoading()
        
        let result = Http.parse(res);
        
        if result.0 {
            storages = [];
            let data = result.2["storages"] as! NSArray;
            
            for i in 0..<data.count {
                let dict = data[i] as! NSDictionary;
                let storage = Storage(dict);
                
                self.storages.append(storage);
            }
            
            answers = [String](repeating: "0", count: self.storages.count);
            
            DispatchQueue.main.async {
                self.updateContent();
            }
        } else {
            Toast.showMessage(result.1, onView: self.view);
        }
    }
    
    // 更新内容
    func updateContent() {
        let storage = storages[currentIndex];
        questionLabel.text = storage.question;
        self.navigationItem.title = String(currentIndex + 1) + "/" + String(storages.count);
        
        if storage.url.isEmpty {
            picView.isHidden = true;
            picLabel.isHidden = true;
            
            optionView.frame = CGRect(x: 7, y: 139, width: 725, height: 200);
            optionLabel.frame = CGRect(x: 7, y: 110, width: 725, height: 21);
        } else {
            picView.isHidden = false;
            picLabel.isHidden = false;
            
            optionView.frame = CGRect(x: 7, y: 318, width: 725, height: 200);
            optionLabel.frame = CGRect(x: 7, y: 289, width: 725, height: 21);
            AsyncImage().load(named: storage.url, to: picImage, withDefault: "load-fail");
        }
        
        if !storage.option1.isEmpty {
            aOptionLabel.text = "A：" + storage.option1;
        } else {
            aOptionLabel.text = "";
        }
        
        if !storage.option2.isEmpty {
            bOptionLabel.text = "B：" + storage.option2;
        } else {
            bOptionLabel.text = "";
        }
        
        if !storage.option3.isEmpty {
            cOptionLabel.text = "C：" + storage.option3;
        } else {
            cOptionLabel.text = "";
        }
        
        if !storage.option4.isEmpty {
            dOptionLabel.text = "D：" + storage.option4;
        } else {
            dOptionLabel.text = "";
        }
        
        aImage.image = nil;
        bImage.image = nil;
        cImage.image = nil;
        dImage.image = nil;
        
        let ans = answers[currentIndex] ;
        if ans != "0" {
            if ans == "1" {
                if storage.answer == "1" {
                    aImage.image = UIImage(named: "selected");
                } else {
                    aImage.image = UIImage(named: "x");
                }
            }
            
            if ans == "2" {
                if storage.answer == "2" {
                    bImage.image = UIImage(named: "selected");
                } else {
                    bImage.image = UIImage(named: "x");
                }
            }
            
            if ans == "3" {
                if storage.answer == "3" {
                    cImage.image = UIImage(named: "selected");
                } else {
                    cImage.image = UIImage(named: "x");
                }
            }
            
            if ans == "4" {
                if storage.answer == "4" {
                    dImage.image = UIImage(named: "selected");
                } else {
                    dImage.image = UIImage(named: "x");
                }
            }
        }
    }
    
    // 选A
    @IBAction func selectA(_ sender: Any) {
        if answers[currentIndex] != "0" {
            return
        }
        
        let storage = storages[currentIndex];
        
        if storage.option1.isEmpty {
            return
        }
        
        if storage.answer == "1" {
            aImage.image = UIImage(named: "selected");
        } else {
            aImage.image = UIImage(named: "x");
        }
        
        answers[currentIndex] = "1";
    }
    
    // 选B
    @IBAction func selectB(_ sender: Any) {
        if answers[currentIndex] != "0" {
            return
        }
        
        let storage = storages[currentIndex];
        
        if storage.option2.isEmpty {
            return
        }
        
        if storage.answer == "2" {
            bImage.image = UIImage(named: "selected");
        } else {
            bImage.image = UIImage(named: "x");
        }
        
        answers[currentIndex] = "2";
    }
    
    // 选C
    @IBAction func selectC(_ sender: Any) {
        if answers[currentIndex] != "0" {
            return
        }
        
        let storage = storages[currentIndex];
        
        
        if storage.option3.isEmpty {
            return
        }
        
        if storage.answer == "3" {
            cImage.image = UIImage(named: "selected");
        } else {
            cImage.image = UIImage(named: "x");
        }
        
        answers[currentIndex] = "3";
    }
    
    // 选D
    @IBAction func selectD(_ sender: Any) {
        if answers[currentIndex] != "0" {
            return
        }
        
        let storage = storages[currentIndex];
        
        if storage.option4.isEmpty {
            return
        }
        
        if storage.answer == "4" {
            dImage.image = UIImage(named: "selected");
        } else {
            dImage.image = UIImage(named: "x");
        }
        
        answers[currentIndex] = "4";
    }
    
    // 提示
    @IBAction func showTips(_ sender: Any) {
        let alertController = UIAlertController(title: "提示", message: storages[currentIndex].explains, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "记住了", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 计算正确率
    func calcRight() -> String {
        var rightCount = 0;
        var noSelectCount = 0;
        for i in 0..<answers.count {
            if answers[i] == "0" {
                noSelectCount += 1;
                continue;
            }
            if answers[i] == storages[i].answer {
                rightCount += 1;
                continue;
            }
        }
        
        return "一共\(answers.count)题，对了\(rightCount)题, 错了\(answers.count - rightCount - noSelectCount)题, 还没\(noSelectCount)未选";
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

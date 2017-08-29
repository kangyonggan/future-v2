
//
//  QrScanResultController.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class QrScanResultController: UIViewController {
 
    // 控件
    @IBOutlet weak var resultView: UIView!
    
    // 扫描结果
    var results: [String]!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView();
        
        initData();
    }
    
    // 初始化界面
    func initView() {
        // 导航条
        self.navigationItem.title = "扫描结果";
        
        resultView.layer.borderWidth = 1;
        resultView.layer.borderColor = UIColor.lightGray.cgColor;
    }
    
    // 初始化数据
    func initData() {
        if results.count == 1 {
            let label = UILabel(frame: CGRect(x: 0, y: 20, width: resultView.frame.width, height: resultView.frame.height - 40));
            label.text = results[0];
            label.textAlignment = .center;
            resultView.addSubview(label);
        } else {
            for i in 0..<results.count {
                let label = UILabel(frame: CGRect(x: 0, y: 20 + (i * 70), width: Int(resultView.frame.width), height: 60));
                label.text = "二维码\(i+1)的内容:\n\(results[i])";
                label.numberOfLines = 5;
                label.textAlignment = .center;
                resultView.addSubview(label);
            }
        }
    }
    
    // 复制
    @IBAction func copyResult(_ sender: Any) {
        UIPasteboard.general.strings = results;
        Toast.showMessage("扫描结果已经复制到粘贴板了", onView: self.view);
    }
    
    // 分享
    @IBAction func share(_ sender: Any) {
        
    }
    
}

//
//  ToolIndexController.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ToolIndexController: UIViewController {
    
    // 控件
    @IBOutlet weak var toolCollectionView: ToolCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
        
        initData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 导航条
        parent?.navigationItem.title = "综合";
    }
    
    // 初始化界面
    func initView() {
        parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        toolCollectionView.delegate = toolCollectionView;
        toolCollectionView.dataSource = toolCollectionView;
        
        toolCollectionView.viewController = self;
    }
    
    // 初始化数据
    func initData() {
        toolCollectionView.initData(AppConstants.tools());
    }
    
}

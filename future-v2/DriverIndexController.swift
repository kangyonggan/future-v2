//
//  DriverIndexController.swift
//  future-v2
//
//  Created by kangyonggan on 9/8/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class DriverIndexController: UIViewController {
    // 控件
    @IBOutlet weak var collectionView: DriverCollectionView!
    
    override func viewDidLoad() {
        
        collectionView.delegate = collectionView;
        collectionView.dataSource = collectionView;
        
        collectionView.viewController = self;
        
        collectionView.initData();
        
        self.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
    }
}

//
//  HomeIndexController.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class HomeIndexController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        // 导航条
        parent?.navigationItem.title = "首页";
    }
    
}

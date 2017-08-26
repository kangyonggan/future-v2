//
//  MyIndexController.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class MyIndexController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 注销
    @IBAction func logout(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController;
        vc.isLogout = true;
        self.navigationController?.pushViewController(vc, animated: false);
        
    }
    
}

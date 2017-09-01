//
//  HomeIndexController.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class NewsIndexController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var news = [News]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView();
        
        initData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        // 导航条
        parent?.navigationItem.title = "新闻";
    }
    
    // 初始化界面
    func initView() {
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
    // 初始化数据
    func initData() {
        
        
        tableView.reloadData();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath);
        
        return cell;
    }
    
}

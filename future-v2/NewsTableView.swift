//
//  NewsTableView.swift
//  future-v2
//
//  Created by kangyonggan on 8/31/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class NewsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let CELL_ID_JOKE = "NewsJokeTableCell";
    
    var news = [News]();
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func numberOfRows(inSection section: Int) -> Int {
        return news.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID_JOKE, for: indexPath) as! NewsJokeTableCell;
        
        return cell
    }
    
    
}

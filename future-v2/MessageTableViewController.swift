//
//  MessageTableViewController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {
    
    let CELL_ID = "MessageTableCell";
    
    // 数据
    var messages = [Message]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MessageTableCell;
        
        let message = messages[indexPath.row];
        
        cell.initData(message);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row];
        
        // 把此消息标识为已读
        self.updateMessage(message);
        
        // 跳转消息详情
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageDetailController") as! MessageDetailController;
        vc.message = message;
        self.navigationController?.pushViewController(vc, animated: true);
        
        // 异步请求服务，把消息更新为已读
        let user = UserService.getCurrentUser();
        Http.post(UrlConstants.MESSAGE_READ, params: ["id": message.id, "username": user!.username])
    }
    
    // 把消息更新为已读
    func updateMessage(_ message: Message) {
        for msg in messages {
            if msg.id == message.id {
                self.tableView.reloadData();
                msg.isRead = true;
                break;
            }
        }
    }
    
}

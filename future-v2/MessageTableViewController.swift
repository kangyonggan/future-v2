//
//  MessageTableViewController.swift
//  future-v2
//
//  Created by kangyonggan on 8/27/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class MessageTableViewController: UITableViewController {
    
    let CELL_ID = "MessageTableCell";
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
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
        if isLoading() {
            return;
        }
        
        // 准备数据
        let message = messages[indexPath.row];
        let user = UserService.getCurrentUser();
        
        // 把此消息标识为已读
        self.updateMessage(message);
        
        // 如果是【意见反馈】，就跳转到可以回复的界面
        if message.type == "意见反馈" {
            loadingView = ViewUtil.loadingView(self.view);
            
            Http.post(UrlConstants.MESSAGE_PRE_REPLY, params: ["id": message.id, "username": user!.username], callback: preReplyCallback)
        } else {
            // 跳转消息详情
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageDetailController") as! MessageDetailController;
            vc.message = message;
            self.navigationController?.pushViewController(vc, animated: true);
            
            // 异步请求服务，把消息更新为已读
            Http.post(UrlConstants.MESSAGE_READ, params: ["id": message.id, "username": user!.username])
        }
        
    }
    
    // 欲回复消息的回调
    func preReplyCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            let msg = result.2["message"] as! NSDictionary;
            let message = Message(msg);
            
            let replyMsg = result.2["replyMessage"] as? NSDictionary;
            var replyMessage: Message?;
            if replyMsg != nil {
                replyMessage = Message(replyMsg!);
            }
            
            // 跳转消息回复界面
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageReplyController") as! MessageReplyController;
                vc.message = message;
                vc.replyMessage = replyMessage;
                self.navigationController?.pushViewController(vc, animated: true);
            }
        } else {
            Toast.showMessage(result.1, onView: self.view);
        }
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

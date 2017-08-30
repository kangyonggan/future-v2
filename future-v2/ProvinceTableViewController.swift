//
//  ProvinceTableViewController.swift
//  future-v2
//
//  Created by kangyonggan on 8/30/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ProvinceTableViewController: UITableViewController {
    
    let CELL_ID = "ProvinceTableCell";
    var selectedProv: (String, String)!;
    var provs = [(String, String)]();
    var viewController: IdcardGenerateController!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // 跳转到当前选择的cell
        let row = clacSelectedRow();
        let indexPath = IndexPath(row: row, section: 0);
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true);
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ProvinceTableCell;
        
        let prov = provs[indexPath.row]
        
        cell.initData(prov, isSelected: prov.1 == selectedProv.1);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController.selectProv(provs[indexPath.row]);
        
        self.navigationController?.popViewController(animated: true);
    }
    
    // 计算当前选择所在的行
    func clacSelectedRow() -> Int {
        var row = 0;
        for prov in provs {
            if prov.0 == selectedProv.0 {
                return row;
            }
            row += 1;
        }
        
        return -1;
    }
    
}

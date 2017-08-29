//
//  ToolCollectionView.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ToolCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let CELL_ID = "ToolCollectionCell";
    
    var tools = [(String, String, String)]();
    var viewController: ToolIndexController!;
    
    func initData(_ tools: [(String, String, String)]) {
        self.tools = tools;
    }
    
    // collection view //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! ToolCollectionCell;
        
        cell.initData(tools[indexPath.row]);
        
        return cell;
    }
    
    // 选中事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tool = tools[indexPath.row];
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: tool.1);
        
        self.viewController.navigationController?.pushViewController(vc, animated: true);
       
    }
    
}

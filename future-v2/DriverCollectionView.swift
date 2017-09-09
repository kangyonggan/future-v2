
//
//  DriverCollectionView.swift
//  future-v2
//
//  Created by kangyonggan on 9/8/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class DriverCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource{
    
    let CELL_ID = "DriverCollectionCell";
    
    var items = [(String, String, Int)]();
    var viewController: DriverIndexController!;
    
    func initData() {
        // TODO
        items.append(("科目一", "题库（一）", 1));
        items.append(("科目一", "题库（二）", 2));
        items.append(("科目一", "题库（三）", 3));
        items.append(("科目一", "题库（四）", 4));
        items.append(("科目一", "题库（五）", 5));
        items.append(("科目一", "题库（六）", 6));
        items.append(("科目一", "题库（七）", 7));
        items.append(("科目一", "题库（八）", 8));
        items.append(("科目一", "题库（九）", 9));
        items.append(("科目一", "题库（十）", 10));
        items.append(("科目一", "题库（十一）", 11));
        items.append(("科目一", "题库（十二）", 12));
        items.append(("科目一", "题库（十三）", 13));
        
        items.append(("科目四", "题库（一）", 1));
        items.append(("科目四", "题库（二）", 2));
        items.append(("科目四", "题库（三）", 3));
        items.append(("科目四", "题库（四）", 4));
        items.append(("科目四", "题库（五）", 5));
        items.append(("科目四", "题库（六）", 6));
        items.append(("科目四", "题库（七）", 7));
        items.append(("科目四", "题库（八）", 8));
        items.append(("科目四", "题库（九）", 9));
        items.append(("科目四", "题库（十）", 10));
        items.append(("科目四", "题库（十一）", 11));
    }
    
    // collection view //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! DriverCollectionCell;
        
        cell.initData(items[indexPath.row]);
        
        return cell;
    }
    
    // 选中事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row];
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverExamController") as! DriverExamController;
        vc.item = item;
        self.viewController.navigationController?.pushViewController(vc, animated: true);
    }

}

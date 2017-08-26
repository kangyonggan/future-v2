//
//  StringUtil.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

class StringUtil: NSObject {
    static let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
    static let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
    static let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
    static let CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
    
    // 判断是否是手机号
    static func isMobile(_ num: String) -> Bool {
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        
        if ((regextestmobile.evaluate(with: num) == true)
            || (regextestcm.evaluate(with: num)  == true)
            || (regextestct.evaluate(with: num) == true)
            || (regextestcu.evaluate(with: num) == true)) {
            return true
        }
        
        return false
    }
    
    // 去除首尾的空格和回车
    static func trim(_ str: String) -> String {
        return str.trimmingCharacters(in: .whitespacesAndNewlines);
    }
}

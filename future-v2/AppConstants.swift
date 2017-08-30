//
//  AppConstants.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

// 常量
class AppConstants: NSObject {
    
    // 主色
    static let MASTER_COLOR = UIColor(red: 255/255, green: 85/255, blue: 55/255, alpha: 1);
    
    // 超时时间（单位：秒）
    static let TIMEOUT = 10.0;
    
    // 没有封面
    static let NO_COVER_IMAGE = "no-cover";
    
    // 小说主题
    static func themes() -> [(String, String)] {
        var themes = [(String, String)]();
        
        let theme_default = ("白雪（默认）", "#FFFFFF");
        themes.append(theme_default);
        
        let theme1 = ("漆黑", "#000000");
        themes.append(theme1);
        
        let theme2 = ("明黄", "#FFFFED");
        themes.append(theme2);
        
        let theme3 = ("淡绿", "#EEFAEE");
        themes.append(theme3);
        
        let theme4 = ("草绿", "#CCE8CF");
        themes.append(theme4);
        
        let theme5 = ("红粉", "#FCEFFF");
        themes.append(theme5);
        
        let theme6 = ("深灰", "#EFEFEF");
        themes.append(theme6);
        
        let theme7 = ("米色", "#F5F5DC");
        themes.append(theme7);
        
        let theme8 = ("茶色", "#D2B48C");
        themes.append(theme8);
        
        let theme9 = ("银色", "#E7F4FE");
        themes.append(theme9);
        
        return themes;
    }
    
    // 工具
    static func tools() -> [(String, String, String)] {
        var tools = [(String, String, String)]()// icon, controller, name
        tools.append(("scancode", "QrScanController", "扫描二维码"));
        tools.append(("qrcode", "QrGenerateController", "生成二维码"));
        tools.append(("yinyang", "", "算一卦"));
        tools.append(("idcard", "IdcardGenerateController", "生成身份证"));
        tools.append(("checkidcard", "IdcardVerifyController", "身份证校验"));
        
        return tools;
    }
    
    // 省份
    static func provs() -> [(String, String)] {
        var provs = [(String, String)]()// code, name
        provs.append(("", "随机"));
        provs.append(("11", "北京"));
        provs.append(("12", "天津"));
        provs.append(("13", "河北"));
        provs.append(("14", "山西"));
        provs.append(("15", "内蒙古"));
        provs.append(("21", "辽宁"));
        provs.append(("22", "吉林"));
        provs.append(("23", "黑龙江"));
        provs.append(("31", "上海"));
        provs.append(("32", "江苏"));
        provs.append(("33", "浙江"));
        provs.append(("34", "安徽"));
        provs.append(("35", "福建"));
        provs.append(("36", "江西"));
        provs.append(("37", "山东"));
        provs.append(("41", "河南"));
        provs.append(("42", "湖北"));
        provs.append(("43", "湖南"));
        provs.append(("44", "广东"));
        provs.append(("45", "广西"));
        provs.append(("46", "海南"));
        provs.append(("50", "重庆"));
        provs.append(("51", "四川"));
        provs.append(("52", "贵州"));
        provs.append(("53", "云南"));
        provs.append(("54", "西藏"));
        provs.append(("61", "陕西"));
        provs.append(("62", "甘肃"));
        provs.append(("63", "青海"));
        provs.append(("64", "宁夏"));
        provs.append(("65", "新疆"));
        provs.append(("71", "台湾"));
        provs.append(("81", "香港"));
        provs.append(("82", "澳门"));
        provs.append(("91", "国外"));
        
        return provs;
    }
}

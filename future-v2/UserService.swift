//
//  UserService.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class UserService: NSObject {
    
    static let dictionaryDao = DictionaryDao();
    static let userDao = UserDao();
    
    // 保存登录的用户
    static func saveUser(_ user: User) {
        // 删除老的用户
        userDao.deleteUser(user.username);
        
        // 保存新用户
        userDao.save(user);
        
        // 删除当前用户名
        dictionaryDao.delete(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.USERNAME);
        
        // 保存当前用户名
        let mobile = Dictionary();
        mobile.key = DictionaryKey.USERNAME;
        mobile.value = user.username;
        mobile.type = DictionaryKey.TYPE_DEFAULT;
        dictionaryDao.save(mobile);
    }
    
    // 获取当前登录的用户
    static func getCurrentUser() -> User? {
        // 当前用户的手机号
        let dict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.USERNAME);
        
        if dict != nil {
            return userDao.findUser(dict!.value);
        }
        
        return nil;
    }
    
    // 更新用户信息
    static func updateUser(_ user: User) {
        userDao.deleteUser(user.username);
        userDao.save(user);
    }
    
}

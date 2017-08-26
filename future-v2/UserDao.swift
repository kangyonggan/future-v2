//
//  UserDao.swift
//  future-v2
//
//  Created by kangyonggan on 8/26/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//


import UIKit
import CoreData

class UserDao: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    let entityName = "TUser";
    
    override init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 保存用户
    func save(_ user: User) {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext);
        
        newEntity.setValue(user.username, forKey: "username");
        newEntity.setValue(user.realname, forKey: "realname");
        newEntity.setValue(user.smallAvatar, forKey: "smallAvatar");
        newEntity.setValue(user.mediumAvatar, forKey: "mediumAvatar");
        newEntity.setValue(user.largeAvatar, forKey: "largeAvatar");
        newEntity.setValue(user.email, forKey: "email");
        newEntity.setValue(user.token, forKey: "token");
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError();
        }
    }
    
    // 删除用户
    func deleteUser(_ username: String) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "username=%@", username);
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                managedObjectContext.delete(row);
            }
            
            try managedObjectContext.save();
        }catch{
            fatalError();
        }
    }
    
    // 查询用户
    func findUser(_ username: String) -> User? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "username=%@", username);
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            let dict = User();
            for row in rows {
                dict.username = (row.value(forKey: "username") as? String);
                dict.realname = (row.value(forKey: "realname") as? String);
                dict.smallAvatar = (row.value(forKey: "smallAvatar") as? String);
                dict.mediumAvatar = (row.value(forKey: "mediumAvatar") as? String);
                dict.largeAvatar = (row.value(forKey: "largeAvatar") as? String);
                dict.email = (row.value(forKey: "email") as? String);
                dict.token = (row.value(forKey: "token") as? String);
                
                return dict;
            }
        }catch{
            fatalError();
        }
        
        return nil;
    }
    
    // 查询所有用户
    func findUsers() -> [User] {
        var users = [User]();
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                let dict = User();
                dict.username = (row.value(forKey: "username") as? String);
                dict.realname = (row.value(forKey: "realname") as? String);
                dict.smallAvatar = (row.value(forKey: "smallAvatar") as? String);
                dict.mediumAvatar = (row.value(forKey: "mediumAvatar") as? String);
                dict.largeAvatar = (row.value(forKey: "largeAvatar") as? String);
                dict.email = (row.value(forKey: "email") as? String);
                dict.token = (row.value(forKey: "token") as? String);
                
                users.append(dict);
            }
        }catch{
            fatalError();
        }
        
        return users;
    }
    
}


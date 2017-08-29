//
//  FileUtil.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class FileUtil: NSObject {
    
    // 写图片
    static func writeImage(_ image: UIImage, withName: String) {
        let fileManager = FileManager.default;
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        // 判断文件、目录是否存在，如果不存在就创建目录
        if !fileManager.fileExists(atPath: rootPath + "/images/upload") {
            try! fileManager.createDirectory(atPath: rootPath + "/images/upload", withIntermediateDirectories: true, attributes: nil)
        }
        if !fileManager.fileExists(atPath: rootPath + "/images/cover") {
            try! fileManager.createDirectory(atPath: rootPath + "/images/cover", withIntermediateDirectories: true, attributes: nil)
        }
        
        let filePath = rootPath + "/images/" + withName;
        let imageData = UIImagePNGRepresentation(image);
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
    }
    
    // 读图片
    static func readImage(_ named: String) -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath + "/images/").appendingPathComponent(named);
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image;
        }
        
        return nil;
    }
}

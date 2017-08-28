//
//  AvatarUploadController.swift
//  future-v2
//
//  Created by kangyonggan on 8/28/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class AvatarUploadController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var user: User!;
    var picker: UIImagePickerController!;
    var isSelected = false;
    var imageData: Data!;
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    // 初始化界面
    func initView() {
        user = UserService.getCurrentUser();
        
        // 头像圆角
        avatarImage.layer.cornerRadius = 10;
        avatarImage.layer.masksToBounds = true;
        
        // 按钮圆角
        submitBtn.layer.cornerRadius = 20;
        submitBtn.layer.masksToBounds = true;
        
        // 加载头像 异步加载
        Http.get(user.largeAvatar, callback: avatarCallback);
    }
    
    // 加载头像的回调
    func avatarCallback(res: HTTPResult) {
        if res.ok {
            let img = UIImage(data: res.content!)
            DispatchQueue.main.async {
                self.avatarImage.image = img;
            }
        } else {
            let img = UIImage(named: "600");
            DispatchQueue.main.async {
                self.avatarImage.image = img;
            }
        }
    }
    
    // 选择头像
    @IBAction func selectImage(_ sender: Any) {
        // 判断是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker = UIImagePickerController();
            picker.sourceType = .photoLibrary;
            picker.delegate = self;
            picker.allowsEditing = true;
            
            self.present(picker, animated: true, completion: nil);
        } else {
            Toast.showMessage("读取相册失败", onView: self.view);
        }
    }
    
    // 选择图片代理事件
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type = (info[UIImagePickerControllerMediaType] as! String);
        if type != "public.image" {
            Toast.showMessage("您选择的不是图片", onView: self.view);
            return;
        }
        
        // 将选择的图片保存到Document目录下
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
        let fileManager = FileManager.default;
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/avatar.png";
        imageData = UIImagePNGRepresentation(image);
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
        // 预览
        avatarImage.image = image;
        
        // 标识已选图片，可上传
        isSelected = true;
        
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil);
    }
    
    // 提交上传
    @IBAction func submit(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        if !isSelected {
            Toast.showMessage("请选择头像", onView: self.view)
            return;
        }
        
        loadingView = ViewUtil.loadingView(self.view);
        
        Http.post(UrlConstants.USER_AVATAR, params: ["username": user.username], file: ["avatar": HTTPFile.data("\(user.username!).png", imageData, nil)], callback: uploadCallback)
    }
    
    // 上传回调
    func uploadCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            let u = result.2["user"] as! NSDictionary;
            let us = User(u);
            us.token = user.token;
            
            // 更新本地用户信息
            UserService.updateUser(us);
            
            isSelected = false;
            Toast.showMessage("上传成功", onView: self.view);
        } else {
            Toast.showMessage(result.1, onView: self.view);
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

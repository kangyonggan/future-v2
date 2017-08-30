//
//  QrGenerateController.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class QrGenerateController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 控件
    @IBOutlet weak var contentInput: UITextView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var generateBtn: UIButton!
    @IBOutlet weak var resultImage: UIImageView!
    
    var picker: UIImagePickerController!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    // 初始化界面
    func initView() {
        // Logo边框
        iconImage.layer.borderWidth = 1;
        iconImage.layer.borderColor = UIColor.lightGray.cgColor;
        
        // 结果边框
        resultImage.layer.borderWidth = 1;
        resultImage.layer.borderColor = UIColor.lightGray.cgColor;
        
        // 按钮
        generateBtn.layer.cornerRadius = 20;
        generateBtn.layer.masksToBounds = true;
        
        // 长按事件
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.saveImage))
        self.resultImage.isUserInteractionEnabled = true;
        self.resultImage.addGestureRecognizer(longPress)
    }
    
    // 选择Logo
    @IBAction func selectLogo(_ sender: Any) {
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
        
        // 将选择的图片放入logo中
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
        iconImage.image = image;
        
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil);
    }
    
    // 开始生成
    @IBAction func gengeate(_ sender: Any) {
        // 收起键盘
        UIApplication.shared.keyWindow?.endEditing(true);
        
        let content = contentInput.text!;
        if content.isEmpty {
            Toast.showMessage("请输入内容", onView: self.view);
            return;
        }
        
        var icon = iconImage.image;
        if icon == nil {
            icon = UIImage(named: "empty");
        }
        
        // 带图片的二维码图片
        let image = generateQr(content, icon: icon);
        resultImage.image = image;
        
        // 清空内容和logo
        contentInput.text = "";
        iconImage.image = nil;
        Toast.showMessage("生成成功", onView: self.view);
        
    }
    
    // 保存到相册
    func saveImage() {
        if resultImage.image != nil {
            let alert = UIAlertController(title: "把生成的二维码保存到相册", message: nil, preferredStyle: .actionSheet);
            let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil);
            
            let okBtn = UIAlertAction(title: "保存到相册", style: .destructive, handler: saveToPhoto)
            
            alert.addAction(cancelBtn);
            alert.addAction(okBtn);
            
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    func saveToPhoto(_ action: UIAlertAction) {
        PhotoAlbumUtil.saveImageInAlbum(image: resultImage.image!, albumName: "未来") { (result) in
            switch result{
            case .success:
                Toast.showMessage("保存成功", onView: self.view);
            case .denied:
                Toast.showMessage("拒绝保存", onView: self.view);
            case .error:
                Toast.showMessage("保存失败", onView: self.view);
            }
        }
    }
    
    // 生成二维码, 并保存到app
    func generateQr(_ content: String, icon: UIImage?) -> UIImage? {
        // 字符串内容
        let stringData = content.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        // 创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter?.outputImage
        
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        // 返回二维码image
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5))))
        
        // 中间一般放logo
        if icon != nil {
            
            let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
            
            UIGraphicsBeginImageContext(rect.size)
            codeImage.draw(in: rect)
            let avatarSize = CGSize(width: rect.size.width*0.25, height: rect.size.height*0.25)
            
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            icon!.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return resultImage;
        }
        
        let data = UIImagePNGRepresentation(codeImage);
        
        return codeImage;
    }
    
}

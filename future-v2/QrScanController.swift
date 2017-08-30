//
//  QrScanController.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import AVFoundation

class QrScanController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    
    // 打开文件的控制器
    var picker: UIImagePickerController!;

    // 通过摄像头扫描所需变量
    var scanRectView:UIView!
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!
    var isOk = false;
    
    // 上下扫描
    var timer: Timer!
    var scanLineView: UIView!;
    var scanLineViewY = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        // 初始化扫描器
        initScan();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        if isOk {
            //开始捕获
            self.session.startRunning()
        }
    }
    
    // 使用相机扫描二维码
    func initScan() {
        do{
            if self.session != nil {
                self.session.stopRunning();
            }
            
            self.device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
            self.input = try AVCaptureDeviceInput(device: device)
            
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            self.session = AVCaptureSession()
            if UIScreen.main.bounds.size.height < 500 {
                self.session.sessionPreset = AVCaptureSessionPreset640x480
            }else{
                self.session.sessionPreset = AVCaptureSessionPresetHigh
            }
            
            self.session.addInput(self.input)
            self.session.addOutput(self.output)
            
            self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            //计算中间可探测区域
            let windowSize = UIScreen.main.bounds.size
            let scanSize = CGSize(width:windowSize.width * 3 / 4, height: windowSize.width * 3 / 4)
            var scanRect = CGRect(x: (windowSize.width-scanSize.width) / 2,
                                  y: (windowSize.height-scanSize.height) / 2 - 100,
                                  width: scanSize.width, height: scanSize.height)
            
            //计算rectOfInterest 注意x,y交换位置
            scanRect = CGRect(x: scanRect.origin.y / windowSize.height,
                              y: scanRect.origin.x / windowSize.width,
                              width: scanRect.size.height / windowSize.height,
                              height: scanRect.size.width / windowSize.width);
            //设置可探测区域
            self.output.rectOfInterest = scanRect
            
            self.preview = AVCaptureVideoPreviewLayer(session: self.session)
            self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.preview.frame = UIScreen.main.bounds
            self.view.layer.insertSublayer(self.preview, at: 0)
            
            //添加中间的探测区域框
            self.scanRectView = UIView();
            self.view.addSubview(self.scanRectView)
            self.scanRectView.frame = CGRect(x: 0, y: 0, width: scanSize.width,
                                             height: scanSize.height);
            self.scanRectView.center = CGPoint(x: UIScreen.main.bounds.midX,
                                                y: UIScreen.main.bounds.midY - 100)
            self.scanRectView.layer.borderColor = AppConstants.MASTER_COLOR.cgColor;
            self.scanRectView.layer.borderWidth = 1;
            
            isOk = true;
            
            // 上下扫描的效果
            self.scanLineView = UIView(frame: CGRect(x: 0, y: 0, width: scanSize.width, height: 4));
            self.scanLineView.backgroundColor = UIColor(red: 245/255, green: 75/255, blue: 45/255, alpha: 0.7);
            self.scanLineView.layer.cornerRadius = 20;
            self.scanLineView.layer.masksToBounds = true;
            
            self.scanRectView.addSubview(self.scanLineView);
            
            // 启用计时器，控制每个一段时间执行一次scanLine方法
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(scanLine), userInfo:nil, repeats: true)
        } catch _ {
            //打印错误消息
            let alertController = UIAlertController(title: "提醒",
                                                    message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机",
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 上下扫描的特效
    func scanLine() {
        self.scanLineViewY = (self.scanLineViewY + 1) % Int(self.scanRectView.frame.height);
        var frame = self.scanLineView.frame;
        frame = CGRect(x: frame.origin.x, y: CGFloat(self.scanLineViewY), width: frame.width, height: frame.height);
        self.scanLineView.frame = frame;
    }
    
    // 摄像头捕获
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!) {
        
        var results = [String]();
        
        for i in 0..<metadataObjects.count {
            let metadataObject = metadataObjects[i] as! AVMetadataMachineReadableCodeObject
            results.insert(metadataObject.stringValue, at: 0);
        }
        self.session.stopRunning()
        
        if results.isEmpty {
            Toast.showMessage("没有扫到二维码", onView: self.view);
            self.session.startRunning()
        } else {
            // 震动
            //建立的SystemSoundID对象
            let soundID = SystemSoundID(kSystemSoundID_Vibrate)
            //振动
            AudioServicesPlaySystemSound(soundID)
            
            // 跳转到扫描结果页
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QrScanResultController") as! QrScanResultController;
            vc.results = results;
            self.navigationController?.pushViewController(vc, animated: true);
        }
        
    }
    
    // 相册
    @IBAction func scanPhoto(_ sender: Any) {
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
        
        //二维码读取
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
        let ciImage = CIImage(image: image)!
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context,
                                  options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]);
        
        var results = [String]();
        if let features = detector?.features(in: ciImage) {
            //遍历所有的二维码，并框出
            for feature in features as! [CIQRCodeFeature] {
                results.insert(feature.messageString!, at: 0)
            }
        }
        
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil);
        
        if results.count == 0 {
            Toast.showMessage("您选择的图片上没有二维码", onView: self.view);
            return;
        }
        
        // 跳转到扫描结果页
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QrScanResultController") as! QrScanResultController;
        vc.results = results;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
}

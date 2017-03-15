//
//  LoadViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/27.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {
    
    //var launchView:UIView?
    var initFinished = false
    //var loadViewCtrl:UIViewController?
    var imageView:UIImageView!
    var labelCopyright:UILabel!
    var alertHasShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView()
        imageView.image = UIImage(named: "splash_icon")
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-50)
            make.width.equalTo(128)
            make.height.equalTo(128)
        }
        
        labelCopyright = UILabel()
        labelCopyright.text = "©2016 IMOTTO.NET"
        labelCopyright.textColor = UIColor("#1CA8DD")
        labelCopyright.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(labelCopyright)
        labelCopyright.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-8)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (!alertHasShown) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.checkNetwork()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notifyCenter = NotificationCenter.default
        notifyCenter.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkNetwork() {
        if IMApi.instance.isReachable{
            self.registeDevice()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkNetwork()
            }
        }
    }
    
    func registeDevice(){
        ToastManager.shared.makeToastActivity(self.view)
        debugPrint("registeDevice excuting.")
        
        IMApi.instance.registeDevice { (resp) in
            let notifyCenter = NotificationCenter.default
            notifyCenter.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
            notifyCenter.addObserver(self, selector: #selector(self.viewWillAppear), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
            
            if let signature = resp.signature{
                PropHelper.instance.signature = signature
                if resp.updateFlag == 0 {
                    // 不需升级
                    self.registeDeviceDone()
                } else if resp.updateFlag == 1 {
                    // 需要升级
                    ToastManager.shared.hideToastActivity()
                    self.alertHasShown = true
                    
                    let controller = UIAlertController(title: "软件版本更新", message: resp.updateSummary, preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
                        self.alertHasShown = false
                        self.registeDeviceDone()
                    }))
                    controller.addAction(UIAlertAction(title: "升级", style: .cancel, handler: { (action) in
                        self.alertHasShown = false
                        showInAppStore()
                    }))
                    
                    self.present(controller, animated: true, completion: nil)
                } else if resp.updateFlag == 2 {
                    // 强制升级
                    ToastManager.shared.hideToastActivity()
                    self.alertHasShown = true
                    
                    let controller = UIAlertController(title: "软件版本更新", message: resp.updateSummary, preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "升级", style: .cancel, handler: { (action) in
                        self.alertHasShown = false
                        showInAppStore()
                    }))
                    
                    self.present(controller, animated: true, completion: nil)
                }
            }else{
                
                //self.initFinished = true
                //self.initializeCompleted()
                //return
                
                if IMApi.instance.isReachable{
                    ToastManager.shared.hideToastActivity()
                    self.alertHasShown = true
                    
                    let controller = UIAlertController(title: "注册服务失败，请重试", message: nil, preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
                        self.alertHasShown = false
                        self.registeDevice()
                    }))
                    
                    self.present(controller, animated: true, completion: nil)
                    
                }else{
                    ToastManager.shared.hideToastActivity()
                    self.alertHasShown = true
                    
                    let controller = UIAlertController(title: "网络不可用，请检查后重试！", message: nil, preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
                        self.alertHasShown = false
                        self.registeDevice()
                    }))
                }
            }
        }
    }
    
    func registeDeviceDone(){
        
        if PropHelper.instance.appInitialized{
            var waitForLogin = false
            if let mobile = PropHelper.instance.mobile{
                if let password = PropHelper.instance.password{
                    waitForLogin = true
                    self.autoLogin(mobile, password: password)
                }
            }
            
            if !waitForLogin{
                self.initFinished = true
                self.initializeCompleted()
            }
            
        }else{
            PropHelper.instance.deleteKeychainItem(KEYCHAIN_USERID_KEY)
            PropHelper.instance.deleteKeychainItem(KEYCHAIN_PASSWORD_KEY)
            PropHelper.instance.deleteKeychainItem(KEYCHAIN_USERTOKEN_KEY)
            
            //show guide splash things here.
            PropHelper.instance.appInitialized = true
            
            self.initFinished = true
            
            initializeCompleted()
        }
        
        
    }
    
    func initializeCompleted(){
        ToastManager.shared.hideToastActivity()
        if self.initFinished{
            self.performSegue(withIdentifier: "initialcomplete", sender: self)
        }
        
    }
    
    
    func autoLogin(_ mobile:String, password:String){
        IMApi.instance.userLogin(mobile, password: password) { (resp) in
            if resp.isSuccess{
                PropHelper.instance.mobile = mobile
                PropHelper.instance.password = password
                PropHelper.instance.userId = resp.userid
                PropHelper.instance.usertoken = resp.userToken
                PropHelper.instance.user = resp.userName
                
                debugPrint("registration id is:\(JPUSHService.registrationID()), now set alias.")
                //设置别名
                JPUSHService.setAlias(PropHelper.instance.userId!, callbackSelector: nil, object: nil)
                
            }else{
                PropHelper.instance.userId = ""
                PropHelper.instance.usertoken = ""
            }
            
            self.initFinished = true
            self.initializeCompleted()
        }
    }

   
}

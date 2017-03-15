//
//  RegisterViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/28.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSendVCode: UIButton!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtVerifyCode: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var buttonRegister: UIButton!
    
    var secondsRemain = 60
    var smsTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        self.navigationItem.title = "注册"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.buttonRegister.layer.cornerRadius = 4
        self.buttonRegister.layer.masksToBounds = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let frame = textField.frame
        let scrollPoint = CGPoint(x: 0, y: frame.origin.y - 80)
        scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPassword{
            self.doRegister(textField)
        }else if textField == txtUserName{
            self.txtPassword.becomeFirstResponder()
        }
        
        return true
    }
    
    
    func dismissKeyboard(){
        self.txtPassword.resignFirstResponder()
        self.txtMobile.resignFirstResponder()
        self.txtUserName.resignFirstResponder()
        self.txtVerifyCode.resignFirstResponder()
    }
    
    
    ///发送验证码
    @IBAction func sendVerifyCode(_ sender: AnyObject) {
        dismissKeyboard()
        
        if let mobile = checkMobile(self.txtMobile){
            
            ToastManager.shared.makeToastActivity(self.view)
            IMApi.instance.acquireVerifyCode(mobile, opcode: ACQUIRE_VCODE_FOR_REGISTER, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    //
                    self.btnSendVCode.isEnabled = false
                    self.smsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                    self.smsTimer?.fire()
                }else{
                    self.view.window?.makeToast("获取验证码失败，请重试。")
                }
            })
        }else{
            self.view.window?.makeToast("手机号码输入有误。")
        }
    }
    
    func timerAction(){
        self.btnSendVCode.setTitle("\(self.secondsRemain)秒后重新获取", for: UIControlState.disabled)
        
        self.secondsRemain = secondsRemain-1
        
        if(self.secondsRemain == 0){
            self.secondsRemain = 60
            self.btnSendVCode.isEnabled = true
            self.smsTimer?.invalidate()
            self.smsTimer = nil
        }
    }
    
    ///确认注册
    @IBAction func doRegister(_ sender: AnyObject) {
        dismissKeyboard()
        let password = self.txtPassword.text
        let userName = self.txtUserName.text
        let verifyCode = self.txtVerifyCode.text
        
        if let mobile = checkMobile(self.txtMobile){
            
            if verifyCode?.characters.count<4 || verifyCode?.characters.count>6{
                self.view.window?.makeToast("验证码格式不正确。")
                return
            }
            
            if password?.characters.count<6{
                self.view.window?.makeToast("密码不能少于6个数字或字母。")
                return
            }
            
            if userName?.characters.count<1{
                self.view.window?.makeToast("请填写一个用户名。")
                return
            }
            ToastManager.shared.makeToastActivity(self.view)
            
            IMApi.instance.registerUser(mobile: mobile, password: password!, userName: userName!, verifyCode: verifyCode!, inviteCode: "", completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    let controller = UIAlertController(title: "注册成功，现在使用您的新账号登录吧。", message: nil, preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                        self.navBackTapped(nil)
                    }))
                    
                    self.present(controller, animated: true, completion: nil)
                }
                else{
                    self.view.makeToast("注册用户失败，请重试。")
                }
            })
        }else{
            self.view.makeToast("手机号码输入有误。")
        }
    }
    
    ///显示用户协议
    @IBAction func showAgreement(_ sender: AnyObject) {
        let controller = EULAViewController()
        self.presentBackableController(controller)
    }
}

//
//  ResetPasswordController.swift
//  iMottoApp
//
//  Created by sunht on 2016/12/1.
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


class ResetPasswordController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtVCode: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSendVCode: UIButton!
    @IBOutlet weak var buttonSure: UIButton!
    
    var secondsRemain = 60
    var smsTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        self.navigationItem.title = "重设登录密码"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.buttonSure.layer.cornerRadius = 4
        self.buttonSure.layer.masksToBounds = true
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
            self.btnConfirmTapped(textField)
        }else if textField == txtMobile{
            self.txtVCode.becomeFirstResponder()
        }
        
        return true
    }


    func dismissKeyboard(){
        self.txtPassword.resignFirstResponder()
        self.txtMobile.resignFirstResponder()
        self.txtVCode.resignFirstResponder()
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
    
    @IBAction func btnSendVCodeTapped(_ sender: AnyObject) {
        dismissKeyboard()
        
        if let mobile = checkMobile(self.txtMobile){
            
            ToastManager.shared.makeToastActivity(self.view)
            IMApi.instance.acquireVerifyCode(mobile, opcode: ACQUIRE_VCODE_FOR_FINDPASS, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    //
                    self.btnSendVCode.isEnabled = false
                    self.smsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                    self.smsTimer?.fire()
                }else{
                    self.view.window?.makeToast(resp.msg)
                }
            })
        }else{
            self.view.window?.makeToast("请输入正确的手机号码")
        }

    }
    
    @IBAction func btnConfirmTapped(_ sender: AnyObject) {
        dismissKeyboard()
        let password = self.txtPassword.text
        let verifyCode = self.txtVCode.text
        
        if let mobile = checkMobile(self.txtMobile){
            
            if verifyCode?.characters.count != 6 {
                self.view.window?.makeToast("请输入您接收到的验证码")
                return
            }
            
            if password?.characters.count<6{
                self.view.window?.makeToast("密码不能少于6个字符")
                return
            }
            
            ToastManager.shared.makeToastActivity(self.view)
            IMApi.instance.resetPassword(mobile, vcode: verifyCode!, password: password!, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    let controller = UIAlertController(title: "密码已重置，现在使用您的新密码登录吧", message: nil, preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                        self.navBackTapped(nil)
                    }))
                    
                    self.present(controller, animated: true, completion: nil)
                }
                else{
                    self.view.makeToast(resp.msg)
                }

            })
            
        }else{
            self.view.makeToast("请输入正确的手机号码")
        }

    }
}

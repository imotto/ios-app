//
//  LoginViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/26.
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


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var loginSuccessCallback:(()->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        self.navigationItem.title = "登录"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.buttonLogin.layer.cornerRadius = 4
        self.buttonLogin.layer.masksToBounds = true
    }
    
    @IBAction func btnForgetTapped(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ResetPasswordController") as! ResetPasswordController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func doLogin(_ sender: UIButton?) {
        self.dismissKeyboard()
        let password = self.txtPassword.text
        
        if let mobile = checkMobile(self.txtMobile){
            
            if password?.characters.count<6{
                self.view.window?.makeToast("密码不能少于6个数字或字母。")
                return
            }
            
            ToastManager.shared.makeToastActivity(self.view)
            
            IMApi.instance.userLogin(mobile, password: password!, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    PropHelper.instance.mobile = mobile
                    PropHelper.instance.password = password
                    PropHelper.instance.userId = resp.userid
                    PropHelper.instance.usertoken = resp.userToken
                    PropHelper.instance.userThumb = resp.userThumb
                    
                    PropHelper.instance.user = resp.userName
                    
                    //设置JPUSH别名
                    JPUSHService.setAlias(resp.userid!, callbackSelector: nil, object: nil)
                    
                    //self.view.window?.makeToast("欢迎回来，\(resp.userName!)")
                    let window = UIApplication.shared.keyWindow!
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "LoadViewController") as! LoadViewController
                    window.rootViewController = controller
                    window.makeToast("欢迎回来，\(resp.userName!)")
//                    self.dismiss(animated: true, completion: nil)
//                    
//                    if self.loginSuccessCallback != nil{
//                        self.loginSuccessCallback!()
//                    }
                }
                else{
                    self.view.window?.makeToast(resp.msg)
                }
            })
        }
    }
    @IBAction func btnRegisterTapped(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let winHeight = UIApplication.shared.keyWindow!.frame.size.height
        if winHeight <= 480 {
            let frame = textField.frame
            let scrollPoint = CGPoint(x: 0,y: frame.origin.y - 80)
            
            scrollView.setContentOffset(scrollPoint, animated: true)
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    
    func dismissKeyboard(){
        self.txtMobile.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPassword{
            self.doLogin(nil)
        }
        textField.resignFirstResponder()
        
        return true
    }
    
}

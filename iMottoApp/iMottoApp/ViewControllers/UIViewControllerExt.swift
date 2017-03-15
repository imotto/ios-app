//
//  UIViewControllerExt.swift
//  iMottoApp
//
//  Created by sunht on 16/11/24.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation
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



extension UIViewController{
    func presentBackableController(_ controller:UIViewController){
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG), for: .default)
        navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:COLOR_NAV_TINT]
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func navBackTapped(_ sender: AnyObject?) {
        self.view.endEditing(true)
        
        if self.navigationController?.viewControllers.count > 1 {
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func gotoLoginController(usePush push:Bool){
        let loginStoryboard = UIStoryboard(name: "Account", bundle: nil);
        let loginvc = loginStoryboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        if(push){
            self.navigationController?.pushViewController(loginvc, animated: true)
        }else{
            self.presentBackableController(loginvc)
        }
    }
    
    func displayAlert(_ title:String?, message:String?){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "好的", style: .cancel, handler: nil))
        
        self.present(controller, animated: true, completion: nil)

    }
}

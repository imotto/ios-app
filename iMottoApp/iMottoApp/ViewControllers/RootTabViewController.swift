//
//  RootTabViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class RootTabViewController: UITabBarController {
    override func viewDidLoad() {
        self.tabBar.backgroundColor = COLOR_TAB_BG
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = COLOR_TAB_TINT
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

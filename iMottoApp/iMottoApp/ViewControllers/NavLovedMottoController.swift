//
//  NavLovedMottoController.swift
//  iMottoApp
//
//  Created by sunht on 16/9/18.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class NavLovedMottoController: UINavigationController {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationBar.tintColor = COLOR_NAV_TINT
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:COLOR_NAV_TINT]
    }
}

//
//  NavMeViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class NavMeViewController: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:COLOR_NAV_TINT]
        
        self.tabBarItem.image = FAKIonIcons.iosPersonOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        self.tabBarItem.selectedImage = FAKIonIcons.iosPersonIcon(withSize: 35).image(with: CGSize(width: 35, height: 35))

    }
}

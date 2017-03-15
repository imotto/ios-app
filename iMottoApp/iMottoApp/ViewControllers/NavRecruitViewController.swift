//
//  NavRecruitViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class NavRecruitViewController: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        
        //self.tabBarItem.image = FAKIonIcons.iosRoseOutlineIconWithSize(30).imageWithSize(CGSizeMake(30, 30))
        //self.tabBarItem.selectedImage = FAKIonIcons.iosRoseIconWithSize(35).imageWithSize(CGSizeMake(35, 35))
        self.tabBarItem.image = FAKIonIcons.iosStarOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        self.tabBarItem.selectedImage = FAKIonIcons.iosStarIcon(withSize: 35).image(with: CGSize(width: 35, height: 35))
    }
}

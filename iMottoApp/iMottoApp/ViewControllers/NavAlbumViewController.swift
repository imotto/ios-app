//
//  NavAlbumViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class NavAlbumViewController: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationBar.tintColor = COLOR_NAV_TINT
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:COLOR_NAV_TINT]
        self.tabBarItem.image = FAKIonIcons.iosAlbumsOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        self.tabBarItem.selectedImage = FAKIonIcons.iosAlbumsIcon(withSize: 35).image(with: CGSize(width: 35, height: 35))
    }
}

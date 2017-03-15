//
//  NavMakeAlbumViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/9/16.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class NavCollectMottoController: UINavigationController {
    
    var mottoId:Int64?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationBar.tintColor = COLOR_NAV_TINT
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:COLOR_NAV_TINT]
    }
}

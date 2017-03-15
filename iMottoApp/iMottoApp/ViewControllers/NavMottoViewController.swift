//
//  NavMottoViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class NavMottoViewController: UINavigationController {
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationBar.tintColor = COLOR_NAV_TINT
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:COLOR_NAV_TINT]
        
        self.tabBarItem.image = FAKIonIcons.iosPaperOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        self.tabBarItem.selectedImage = FAKIonIcons.iosPaperIcon(withSize: 35).image(with: CGSize(width: 35, height: 35))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

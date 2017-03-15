//
//  SelExchangeInfoCell.swift
//  iMottoApp
//
//  Created by sunht on 2016/12/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class SelExchangeInfoCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnSel: UIButton!
    
    override func awakeFromNib() {
        
        self.btnSel.setImage(FAKIonIcons.iosCircleOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        self.btnSel.tintColor = COLOR_BTN_TINT
    }


    func setCheckState(_ checked:Bool){
        if checked{
            self.btnSel.tintColor = COLOR_BTN_TINT_ACTIVED
            self.btnSel.setImage(FAKIonIcons.iosCheckmarkOutlineIcon(withSize: 36).image(with: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate), for: UIControlState())
        }else{
            self.btnSel.tintColor = COLOR_BTN_TINT
            self.btnSel.setImage(FAKIonIcons.iosCircleOutlineIcon(withSize: 36).image(with: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate), for: UIControlState())
            
        }
    }

}

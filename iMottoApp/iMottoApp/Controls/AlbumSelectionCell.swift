//
//  AlbumTableViewCell.swift
//  iMottoApp
//
//  Created by sunht on 16/9/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class AlbumSelectionCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnDel: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnDel.setImage(FAKIonIcons.iosTrashOutlineIcon(withSize: 24).image(with: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate), for: UIControlState())
        self.btnSelect.setImage(FAKIonIcons.iosCircleOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        self.btnDel.tintColor = COLOR_BTN_TINT
        self.btnSelect.tintColor = COLOR_BTN_TINT
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCheckState(_ checked:Bool){
        if checked{
            self.btnSelect.tintColor = COLOR_BTN_TINT_ACTIVED
            self.btnSelect.setImage(FAKIonIcons.iosCheckmarkOutlineIcon(withSize: 36).image(with: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate), for: UIControlState())
        }else{
            self.btnSelect.tintColor = COLOR_BTN_TINT
            self.btnSelect.setImage(FAKIonIcons.iosCircleOutlineIcon(withSize: 36).image(with: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate), for: UIControlState())

        }
    }
}

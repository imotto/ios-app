//
//  LovedAlbumTableViewCell.swift
//  iMottoApp
//
//  Created by sunht on 16/9/12.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class LovedAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblLoves: UILabel!
    @IBOutlet weak var btnLove: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnLove.tintColor = COLOR_BTN_TINT_ACTIVED
        self.btnLove.setImage(ImgIosHeart, for: UIControlState())
    }
}

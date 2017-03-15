//
//  MottoTableViewCell.swift
//  iMottoApp
//
//  Created by sunht on 16/6/6.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class MottoTableViewCell: UITableViewCell {

    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLove: UIButton!
    
    @IBOutlet weak var imgThumb: UIImageView!
    
    @IBOutlet weak var lblMotto: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLoveCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnLove.tintColor = COLOR_BTN_TINT
        self.btnComment.tintColor = COLOR_BTN_TINT
        self.btnBookmark.tintColor = COLOR_BTN_TINT
        self.btnMore.tintColor = COLOR_BTN_TINT
        
        self.btnLove.setImage(ImgIosHeartOutLine, for: UIControlState())
        self.btnComment.setImage(ImgIosChatboxesOutLine, for: UIControlState())
        self.btnBookmark.setImage(ImgIosBookmarkOutLine, for: UIControlState())
        self.btnMore.setImage(ImgIosMoreOutLine, for: UIControlState())
        
        
        self.imgThumb.image = FAKIonIcons.iosPersonOutlineIcon(withSize: 48).image(with: CGSize(width: 48, height: 48))
        self.imgThumb.layer.cornerRadius = self.imgThumb.frame.size.width/2
        self.imgThumb.clipsToBounds = true
        self.imgThumb.layer.borderWidth = 0.3
        self.imgThumb.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setLoveState(_ state:LovedState){
        switch state {
        case LovedState.loved:
            self.btnLove.setImage(ImgIosHeart, for: UIControlState())
            break
        default:
            break
        }
    }
    
    func setCollectState(_ state:CollectState){
        switch state {
        case .collected:
            self.btnBookmark.setImage(ImgIosBookmark, for: UIControlState())
        default:
            self.btnBookmark.setImage(ImgIosBookmarkOutLine, for: UIControlState())
        }
    }

}


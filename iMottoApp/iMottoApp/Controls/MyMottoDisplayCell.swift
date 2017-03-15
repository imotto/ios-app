//
//  MyMottoDisplayCell.swift
//  iMottoApp
//
//  Created by sunht on 16/10/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class MyMottoDisplayCell: UITableViewCell {
    
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnLove: UIButton!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var btnScore: UIButton!
    @IBOutlet weak var btnMark: UIButton!
    @IBOutlet weak var btnMore: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnLove.tintColor = COLOR_BTN_TINT
        self.btnReview.tintColor = COLOR_BTN_TINT
        self.btnMark.tintColor = COLOR_BTN_TINT
        self.btnMore.tintColor = COLOR_BTN_TINT
        
        self.btnLove.setImage(ImgIosHeartOutLine, for: UIControlState())
        self.btnReview.setImage(ImgIosChatboxesOutLine, for: UIControlState())
        self.btnMark.setImage(ImgIosBookmarkOutLine, for: UIControlState())
        self.btnMore.setImage(ImgIosMoreOutLine, for: UIControlState())
        
        self.btnScore.layer.masksToBounds = true
        self.btnScore.layer.borderColor = UIColor.orange.cgColor
        self.btnScore.layer.cornerRadius = 5.0
        self.btnScore.layer.borderWidth = 0.5
        
    }
    
    func setModel(_ motto:MottoModel, indexPath:IndexPath ){
        //属性设置
        self.lblTime.text = motto.addTime
        self.lblContent.text = motto.content
        self.btnLove.setTitle(String(motto.loves), for: UIControlState())
        self.btnReview.setTitle(String(motto.reviews), for: UIControlState())

        var score = motto.up - motto.down
        if score < 0 {
            score = 0
        }
        self.btnScore.setTitle(" \(score) ", for: UIControlState())
        
        self.btnLove.tag = (indexPath as NSIndexPath).row
        self.btnReview.tag = (indexPath as NSIndexPath).row
        self.btnMark.tag = (indexPath as NSIndexPath).row
        self.btnMore.tag = (indexPath as NSIndexPath).row
        
        self.setLoveState(motto.loved)
        self.setCollectState(motto.collect)
        self.setReviewState(motto.reviewed)
        
    }
    
    func setLoveState(_ state:LovedState){
        switch state {
        case LovedState.loved:
            self.btnLove.setImage(ImgIosHeart, for: UIControlState())
            break
        default:
            self.btnLove.setImage(ImgIosHeartOutLine, for: UIControlState())
            break
        }
    }
    
    func setReviewState(_ reviewed:Int){
        if reviewed == 1{
            self.btnReview.setImage(ImgIosChatboxes, for: UIControlState())
        }else{
            self.btnReview.setImage(ImgIosChatboxesOutLine, for: UIControlState())
        }
    }
    
    
    func setCollectState(_ state:CollectState){
        switch state {
        case .collected:
            self.btnMark.setImage(ImgIosBookmark, for: UIControlState())
        default:
            self.btnMark.setImage(ImgIosBookmarkOutLine, for: UIControlState())
        }
    }
    
}

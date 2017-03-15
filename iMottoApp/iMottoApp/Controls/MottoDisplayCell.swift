//
//  MottoDisplayCell.swift
//  iMottoApp
//
//  Created by sunht on 16/9/23.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class MottoDisplayCell: UITableViewCell {

    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnLove: UIButton!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var btnMark: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnRevenue: UIButton!
    var timeWithDate: Bool = false
    
    static var thumbPlaceholder:UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnLove.tintColor = COLOR_BTN_TINT
        self.btnReview.tintColor = COLOR_BTN_TINT
        self.btnMark.tintColor = COLOR_BTN_TINT
        self.btnMore.tintColor = COLOR_BTN_TINT
        
        //self.btnLove.imageView?.contentMode = .ScaleAspectFit
        self.btnLove.setImage(ImgIosHeart, for: UIControlState())
        self.btnReview.setImage(ImgIosChatboxesOutLine, for: UIControlState())
        self.btnMark.setImage(ImgIosBookmarkOutLine, for: UIControlState())
        self.btnMore.setImage(ImgIosMoreOutLine, for: UIControlState())
        
        self.imgThumb.layer.cornerRadius = 22
        self.imgThumb.clipsToBounds = true
        self.imgThumb.layer.borderWidth = 0.3
        self.imgThumb.layer.borderColor = UIColor.gray.cgColor
        
        if MottoDisplayCell.thumbPlaceholder == nil{
            let thumbIcon = FAKIonIcons.iosPersonIcon(withSize: 44)
            thumbIcon?.addAttributes([NSForegroundColorAttributeName: COLOR_BTN_TINT])
            MottoDisplayCell.thumbPlaceholder = thumbIcon?.image(with: CGSize(width: 44, height: 44))
        }
    }
    
    func setModel(_ motto:MottoModel, indexPath:IndexPath ){
        //属性设置
        if (timeWithDate) {
            self.lblTime.text = motto.addTime
        } else {
            self.lblTime.text = motto.getTime()
        }
        
        self.lblContent.text = motto.content
        self.btnLove.setTitle(String(motto.loves), for: UIControlState())
        self.btnReview.setTitle(String(motto.reviews), for: UIControlState())
        self.lblUserName.text = motto.userName
        var score = motto.up - motto.down
        if score < 0 {
            score = 0
        }
        self.btnRevenue.setTitle(" \(score) ", for: UIControlState())
        
        self.btnLove.tag = (indexPath as NSIndexPath).row
        self.btnReview.tag = (indexPath as NSIndexPath).row
        self.btnMark.tag = (indexPath as NSIndexPath).row
        self.btnMore.tag = (indexPath as NSIndexPath).row
        
        self.setLoveState(motto.loved)
        self.setCollectState(motto.collect)
        self.setReviewState(motto.reviewed)
    
        if motto.userThumb == ""{
            self.imgThumb.image = MottoDisplayCell.thumbPlaceholder
        }else{
            self.imgThumb.image = MottoDisplayCell.thumbPlaceholder
            self.imgThumb.load.request(with: motto.userThumb, onCompletion: { image, error, operation in
                if operation == .network {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionFade
                    self.imgThumb.layer.add(transition, forKey: nil)
                    self.imgThumb.image = image
                }
            })
        }
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

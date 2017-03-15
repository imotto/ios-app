//
//  ReviewTableViewCell.swift
//  iMottoApp
//
//  Created by sunht on 16/7/15.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblAddTime: UILabel!
    @IBOutlet weak var btnSupport: UIButton!
    @IBOutlet weak var btnOppose: UIButton!
    @IBOutlet weak var btnMoreAction: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /*
          当前逻辑，只能对评论进行支持，反对功能不作实现，所以，支持按钮隐藏，反对按按钮代替支持按钮。
         */
        
        self.btnSupport.isHidden = true
        self.btnOppose.setImage(ImgThumbUpOutLine, for: UIControlState())
        self.btnMoreAction.setImage(ImgIosMoreOutLine, for: UIControlState())
        
        self.imgThumb.layer.cornerRadius = self.imgThumb.frame.size.width/2
        self.imgThumb.clipsToBounds = true
        self.imgThumb.layer.borderWidth = 0.3
        self.imgThumb.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setSupportState(_ state:SupportState){
        switch state {
        case .supported:
            self.btnOppose.setImage(ImgThumbUp, for: UIControlState())
            break
        default:
            self.btnOppose.setImage(ImgThumbUpOutLine, for: UIControlState())
            break
        }
    }

}

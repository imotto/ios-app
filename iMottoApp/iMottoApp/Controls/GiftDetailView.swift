//
//  GiftDetailView.swift
//  iMottoApp
//
//  Created by sunht on 2016/12/7.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader


class GiftDetailView: UIView {

    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblVendor: UILabel!
    @IBOutlet weak var lblDetailLink: UILabel!
    @IBOutlet weak var lblShowReviews: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var constraintLabelReviewsHeight: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.lblSummary.preferredMaxLayoutWidth = lblSummary.bounds.width
//        self.lblName.preferredMaxLayoutWidth = lblName.bounds.width
//        
    }
    
    func setModel(_ model:GiftModel){
        self.lblName.text = model.name
        self.lblSummary.text = model.summary
        self.lblPrice.text = "\(model.price)"
        self.lblVendor.text = "由【\(model.vendor)】提供"
        self.lblAvailable.text = "\(model.avaiable)"
        
        if model.reviews>0{
            self.lblShowReviews.text="查看评价(\(model.reviews))"
            self.lblShowReviews.isUserInteractionEnabled = true
            self.lblShowReviews.textColor = COLOR_BTN_TINT_ACTIVED
        }else{
            self.lblShowReviews.text="还没有人评价"
        }
        constraintLabelReviewsHeight.constant = 0
        
        if model.url != ""{
            self.lblDetailLink.text="查看详细信息"
            self.lblDetailLink.textColor = COLOR_BTN_TINT_ACTIVED
            self.lblDetailLink.isUserInteractionEnabled = true
        }else{
            self.lblDetailLink.text="未提供详细信息"
        }
        
        
        if model.img == ""{
            self.imgView.image = ImgGiftPlaceholder
        }else{
            self.imgView.image = ImgGiftPlaceholder
            self.imgView.load.request(with: model.img, onCompletion: { image, error, operation in
                if operation == .network {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionFade
                    self.imgView.layer.add(transition, forKey: nil)
                    self.imgView.image = image
                }
            })
        }

    }

}

//
//  GiftDisplayCell.swift
//  iMottoApp
//
//  Created by sunht on 2016/12/6.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class GiftDisplayCell: UITableViewCell {

    @IBOutlet weak var imgGift: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setModel(_ gift:GiftModel){
        self.lblName.text = gift.name
        self.lblSummary.text = gift.summary
        self.lblPrice.text = "\(gift.price)"
        self.imgGift.image = UIImage(named: "placeholder")
        if gift.img.characters.count > 0 {
            self.imgGift.load.request(with: gift.img, onCompletion: { image, error, operation in
                if operation == .network {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionFade
                    self.imgGift.layer.add(transition, forKey: nil)
                    self.imgGift.image = image
                }
            })
        }
    }

}

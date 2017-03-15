//
//  TalkMsgCell.swift
//  iMottoApp
//
//  Created by sunht on 16/10/15.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class TalkMsgCell: UITableViewCell {
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgThumb.clipsToBounds = true
        self.imgThumb.layer.cornerRadius = self.imgThumb.width/2
        self.imgThumb.layer.borderColor = UIColor.lightGray.cgColor
        self.imgThumb.layer.borderWidth = 0.3
        
    }
    
    func setModel(_ msg:TalkMsgModel, forUser:String, withThumb:String){
        self.lblUserName.text = forUser
        self.lblContent.text = msg.content
        self.lblTime.text = friendlyTime(msg.sendTime)
        
        if withThumb == ""{
            self.imgThumb.image = ImgThumbPlaceholder
        }else{
            self.imgThumb.image = ImgThumbPlaceholder
            self.imgThumb.load.request(with: withThumb, onCompletion: { image, error, operation in
                if operation == .network {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionFade
                    self.imgThumb.layer.add(transition, forKey: nil)
                    self.imgThumb.image = image
                }
            })
        }
//        
//        if msg.direction == 0{
//            // my msg
//            
//        }else{
//            // other's msg
//            
//        }

    }
}

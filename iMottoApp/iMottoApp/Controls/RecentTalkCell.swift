//
//  RecentTalkCell.swift
//  iMottoApp
//
//  Created by sunht on 16/10/15.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class RecentTalkCell: UITableViewCell {

    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblMsgs: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblMsgs.clipsToBounds = true
        self.imgThumb.clipsToBounds = true
        self.imgThumb.layer.borderWidth = 0.3
        self.imgThumb.layer.borderColor = UIColor.gray.cgColor
        self.imgThumb.layer.cornerRadius = 28
    }
    
    func setModel(_ talk:RecentTalkModel){
        self.lblUserName.text = talk.userName
        self.lblTime.text = friendlyTime(talk.lastTime)
        self.lblMsg.text = talk.content
        
        if talk.msgs>0{
            var msgs = ""
            if(talk.msgs<100){
                msgs = String(talk.msgs)
            }
            self.lblMsgs.text = msgs
            self.lblMsgs.isHidden = false
        }else{
            self.lblMsgs.isHidden = true
        }
        
        self.imgThumb.image = ImgThumbPlaceholder
        
        self.lblMsgs.layer.cornerRadius = self.lblMsgs.width/2
        
        
        if talk.userThumb.characters.count > 0 {
            self.imgThumb.load.request(with: talk.userThumb, onCompletion: { image, error, operation in
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
}

//
//  NoticeCell.swift
//  iMottoApp
//
//  Created by sunht on 16/10/19.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var labelRed: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgThumb.contentMode = .center
    }
    
    func setModel(_ notice: NoticeModel){
        self.lblTitle.text = notice.title
        self.lblInfo.text = notice.content
        self.lblTime.text = friendlyTime(notice.sendTime)
        
        self.labelRed.layer.cornerRadius = 5
        self.labelRed.layer.masksToBounds = true
        if notice.state == 0{
            self.lblTitle.textColor = UIColor.black
            self.imgThumb.tintColor = COLOR_BTN_TINT_ACTIVED
            self.imgThumb.image = UIImage(named: "notice_icon")
            self.labelRed.isHidden = false
        }
        else{
            self.lblTitle.textColor = UIColor.gray
            self.imgThumb.tintColor = COLOR_BTN_TINT
            self.imgThumb.image = UIImage(named: "notice_icon")
            self.labelRed.isHidden = true
        }
    }
    
    ///根据消息类型变换图标？
    func setType(_ type: Int){
        switch type {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
    }

  
}

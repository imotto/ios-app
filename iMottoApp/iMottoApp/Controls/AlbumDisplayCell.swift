//
//  AlbumDisplayCell.swift
//  iMottoApp
//
//  Created by sunht on 16/9/22.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class AlbumDisplayCell: UITableViewCell {

    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    override func awakeFromNib() {
        self.imgThumb.clipsToBounds = true
        self.imgThumb.layer.borderWidth = 0.3
        self.imgThumb.layer.borderColor = UIColor.gray.cgColor
        self.imgThumb.layer.cornerRadius = 24
    }
    
    func setModel(_ model:AlbumModel){
        self.lblTitle.text = model.title
        self.lblSummary.text = model.summary
        self.lblInfo.text = "\(friendlyTime(model.createTime))创建 • 收录\(model.mottos)则偶得 • \(model.loves)人喜欢"
        
        self.imgThumb.image = ImgThumbPlaceholder
        if model.uthumb.characters.count > 0 {
            self.imgThumb.load.request(with: model.uthumb, onCompletion: { image, error, operation in
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

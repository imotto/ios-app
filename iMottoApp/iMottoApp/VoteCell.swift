//
//  VoteCell.swift
//  iMottoApp
//
//  Created by zhangkai on 22/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit

class VoteCell: UITableViewCell {

    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var buttonScore: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    
    static var avatarPlaceholder:UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewAvatar.layer.cornerRadius = 20
        imageViewAvatar.clipsToBounds = true
        imageViewAvatar.layer.borderWidth = 0.3
        imageViewAvatar.layer.borderColor = UIColor.gray.cgColor
        
        let thumbIcon = FAKIonIcons.iosPersonIcon(withSize: 40)
        thumbIcon?.addAttributes([NSForegroundColorAttributeName: COLOR_BTN_TINT])
        VoteCell.avatarPlaceholder = thumbIcon?.image(with: CGSize(width: 40, height: 40))
    }
    
    func setModel(_ motto:VoteModel){
        if motto.support == 1 && motto.oppose == 0 {
            self.buttonScore.setTitle(" +1", for: .normal)
            self.labelTime.text = "\(friendlyTime(motto.voteTime)) 觉得有趣"
        }
        
        if motto.oppose == 1 && motto.support == 0 {
            self.buttonScore.setTitle(" -1", for: .normal)
            self.labelTime.text = "\(friendlyTime(motto.voteTime)) 觉得无聊"
        }
        
        imageViewAvatar.image = DisplayMottoCell.avatarPlaceholder
        if motto.userThumb.characters.count > 0 {
            imageViewAvatar.load.request(with: motto.userThumb, onCompletion: { image, error, operation in
                if operation == .network {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionFade
                    self.imageViewAvatar.layer.add(transition, forKey: nil)
                    self.imageViewAvatar.image = image
                }
            })
        }
        
        labelUsername.text = motto.userName
    }
    
}

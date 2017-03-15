//
//  DisplayMottoCell.swift
//  iMottoApp
//
//  Created by zhangkai on 18/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit

class DisplayMottoCell: UITableViewCell {

    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var buttonScore: UIButton!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonMore: UIButton!
    @IBOutlet weak var buttonMark: UIButton!
    @IBOutlet weak var buttonComment: UIButton!
    @IBOutlet weak var buttonCollect: UIButton!
    @IBOutlet weak var constraintBottomViewHeight: NSLayoutConstraint!
    
    static var avatarPlaceholder:UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewAvatar.layer.cornerRadius = 15
        imageViewAvatar.clipsToBounds = true
        imageViewAvatar.layer.borderWidth = 0.3
        imageViewAvatar.layer.borderColor = UIColor.gray.cgColor
        
        let thumbIcon = FAKIonIcons.iosPersonIcon(withSize: 30)
        thumbIcon?.addAttributes([NSForegroundColorAttributeName: COLOR_BTN_TINT])
        DisplayMottoCell.avatarPlaceholder = thumbIcon?.image(with: CGSize(width: 30, height: 30))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(_ motto:MottoModel, indexPath:IndexPath ){
        let attributedString = NSMutableAttributedString(string: motto.content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8 // Whatever line spacing you want in points
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        labelContent.attributedText = attributedString;
        
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
        let score = motto.up - motto.down
        buttonScore.setTitle(" \(motto.formatCount(count: score))", for: .normal)
        labelTime.text = "\(friendlyTime(motto.addTime))"
        var title = " \(motto.formatCount(count: motto.loves))"
        buttonCollect.setTitle(title, for: .normal)
        title = " \(motto.formatCount(count: motto.reviews))"
        buttonComment.setTitle(title, for: .normal)
    }
}

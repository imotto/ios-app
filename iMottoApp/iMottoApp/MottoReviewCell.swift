//
//  MottoReviewCell.swift
//  iMottoApp
//
//  Created by zhangkai on 17/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit

class MottoReviewCell: UITableViewCell {

    @IBOutlet weak var labelMotto: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var buttonDislike: UIButton!
    @IBOutlet weak var buttonModerate: UIButton!
    @IBOutlet weak var constraintBottomViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        labelMotto.attributedText = attributedString;
    }
    
}

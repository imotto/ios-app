//
//  MyGiftCell.swift
//  iMottoApp
//
//  Created by zhangkai on 26/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit

class MyGiftCell: UITableViewCell {

    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var constraintButtonActionHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

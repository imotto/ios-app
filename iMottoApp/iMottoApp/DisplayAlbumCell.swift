//
//  DisplayAlbumCell.swift
//  iMottoApp
//
//  Created by zhangkai on 29/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit

class DisplayAlbumCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelIntro: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(_ model:AlbumModel){
        self.labelTitle.text = model.title
        
        let attributedString = NSMutableAttributedString(string: model.summary)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8 // Whatever line spacing you want in points
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.labelIntro.attributedText = attributedString;
        
        self.labelCount.text = "收录\(model.mottos)则偶得 • \(model.loves)人喜欢"
        self.labelName.text = model.uname
        self.labelTime.text = "\(friendlyTime(model.createTime))创建"
    }
    
}

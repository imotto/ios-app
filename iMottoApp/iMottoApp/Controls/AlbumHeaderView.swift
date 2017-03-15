//
//  AlbumHeaderView.swift
//  iMottoApp
//
//  Created by sunht on 16/9/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class AlbumHeaderView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var buttonLove: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "AlbumHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override func awakeFromNib() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblSummary.preferredMaxLayoutWidth = lblSummary.bounds.width
        self.lblTitle.preferredMaxLayoutWidth = lblTitle.bounds.width
    }
    
    
    func setLoveState(_ state:LovedState){
        switch state {
        case LovedState.loved:
            self.buttonLove.setImage(UIImage(named: "btn_collection_select"), for: .normal)
            break
        default:
            self.buttonLove.setImage(UIImage(named: "btn_collection"), for: .normal)
            break
        }

    }
}

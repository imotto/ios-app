//
//  EvaluatingMottoTableViewCell.swift
//  iMottoApp
//
//  Created by sunht on 16/7/2.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

/// 弃用，改用 MottoRankingCell
class EvaluatingMottoTableViewCell: UITableViewCell {
    @IBOutlet weak var lblMotto: UILabel!
    @IBOutlet weak var viewVote: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLoveCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var btnLove: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    var voteView:VoteView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnLove.tintColor = COLOR_BTN_TINT
        self.btnComment.tintColor = COLOR_BTN_TINT
        self.btnBookmark.tintColor = COLOR_BTN_TINT
        self.btnMore.tintColor = COLOR_BTN_TINT
        
        self.btnLove.setImage(ImgIosHeartOutLine, for: UIControlState())
        self.btnComment.setImage(ImgIosChatboxesOutLine, for: UIControlState())
        self.btnBookmark.setImage(ImgIosBookmarkOutLine, for: UIControlState())
        self.btnMore.setImage(ImgIosMoreOutLine, for: UIControlState())
        
        
        let rect = CGRect(x: 4, y: 0, width: 48, height: 66)
        self.voteView = VoteView(frame: rect)
        self.viewVote.addSubview(voteView)
        
    }
    
    func setLoveState(_ state:LovedState){
        switch state {
            case LovedState.loved:
                self.btnLove.setImage(ImgIosHeart, for: UIControlState())
                break
            default:
                self.btnLove.setImage(ImgIosHeartOutLine, for: UIControlState())
                break
        }
    }
    
    func setCollectState(_ state:CollectState){
        switch state {
        case .collected:
            self.btnBookmark.setImage(ImgIosBookmark, for: UIControlState())
        default:
            self.btnBookmark.setImage(ImgIosBookmarkOutLine, for: UIControlState())
        }
    }
    

}

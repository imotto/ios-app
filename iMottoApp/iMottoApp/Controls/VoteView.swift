//
//  VoteView.swift
//  iMottoApp
//
//  Created by sunht on 16/7/2.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit


class VoteView: UIView {
    var score = 0{
        didSet{
            self.lblScore.text = String(score)
        }
    }
    var color = COLOR_BTN_TINT
    let btnUp = UIButton(type: UIButtonType.system)
    let btnDown = UIButton(type: UIButtonType.system)
    let lblScore = UILabel()
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(btnUp)
        self.addSubview(btnDown)
        self.addSubview(lblScore)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = self.color.cgColor
        
        btnUp.frame = CGRect(x: 0, y: 0, width: frame.width, height: 22.0)
        lblScore.frame = CGRect(x: 0, y: 22, width: frame.width, height: 22.0)
        btnDown.frame = CGRect(x: 0, y: 44, width: frame.width, height: 22.0)
        
        self.lblScore.textAlignment = NSTextAlignment.center
        self.lblScore.layer.masksToBounds = true
        self.lblScore.layer.borderColor = self.layer.borderColor
        self.lblScore.layer.borderWidth = 0.3
        self.lblScore.textColor = self.color
        self.lblScore.tintColor = self.color
        self.lblScore.font = UIFont.systemFont(ofSize: 13)
        self.lblScore.text = String(self.score)
        
        btnUp.setImage(FAKIonIcons.arrowUpBIcon(withSize: 28).image(with: CGSize(width: 30, height: 30)), for: UIControlState())
        btnDown.setImage(FAKIonIcons.arrowDownBIcon(withSize: 28).image(with: CGSize(width: 30, height: 30)), for: UIControlState())
    }
    
    func setVoteState(_ state:VoteState){
        
        self.btnUp.tintColor = COLOR_BTN_TINT
        self.btnDown.tintColor = COLOR_BTN_TINT
        
        switch state {
            case VoteState.supported:
                self.btnUp.tintColor = COLOR_BTN_TINT_ACTIVED
                break
            case VoteState.opposed:
                self.btnDown.tintColor = COLOR_BTN_TINT_ACTIVED
                break
            default:
                break
        }
        
        
    }
}


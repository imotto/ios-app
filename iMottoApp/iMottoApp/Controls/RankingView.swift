//
//  RankingView.swift
//  iMottoApp
//
//  Created by sunht on 16/9/22.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class RankingView: UIView {

    var color = COLOR_BTN_TINT
    let btnUp = UIButton(type: UIButtonType.system)
    let btnDown = UIButton(type: UIButtonType.system)
    let viewScoreWrapper = UIView()
    let lblScore = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews(){
        self.addSubview(btnUp)
        self.addSubview(btnDown)
        self.addSubview(viewScoreWrapper)
    }
    
    override func layoutSubviews() {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = self.color.cgColor
        
        btnUp.frame = CGRect(x: 0, y: 0, width: 32, height: frame.height)
        viewScoreWrapper.frame = CGRect(x: 32, y: 0, width: 80, height: frame.height)
        btnDown.frame = CGRect(x: 112, y: 0, width: 32, height: frame.height)
        
        viewScoreWrapper.layer.masksToBounds = true
        viewScoreWrapper.layer.borderColor = self.layer.borderColor
        viewScoreWrapper.layer.borderWidth = 0.5
        
        let imgCoin = UIImageView(image: UIImage(named: "coins"))
        imgCoin.frame = CGRect(x: 8,y: 6,width: 20,height: 20)
        imgCoin.contentMode = .scaleAspectFit
        viewScoreWrapper.addSubview(imgCoin)
        
        lblScore.frame = CGRect(x: 40, y: 0, width: 40, height: frame.height)
        lblScore.textAlignment = NSTextAlignment.left
        lblScore.textColor = UIColor.orange
        lblScore.tintColor = UIColor.orange
        lblScore.font = UIFont.systemFont(ofSize: 16)

        viewScoreWrapper.addSubview(lblScore)
        
        btnUp.setImage(ImgIosPlusEmpty, for: UIControlState())
        btnDown.setImage(ImgIosMinusEmpty, for: UIControlState())
    }
    

}

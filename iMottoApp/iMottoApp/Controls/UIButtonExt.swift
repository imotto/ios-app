//
//  UIButtonExt.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

extension UIButton{
    func displayAsDatePicker(_ color:UIColor){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
        
        let img = FAKIonIcons.iosCalendarIcon(withSize: 18).image(with: CGSize(width: 18, height: 18)).withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.imageView?.tintColor = color
        self.tintColor = color
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setDateAsTitle()
        self.setImage(img, for: UIControlState())
        self.setTitleColor(color, for: UIControlState())
    }
    
    func setDateAsTitle(_ date:Date=Date()){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " yyyy/MM/dd"
        let text = dateFormatter.string(from: date)
        
        //self.setTitle(text, forState: UIControlState.Normal)
        
        UIView.transition(with: self, duration: 0.6, options: .transitionFlipFromBottom, animations: {
            self.setTitle(text, for: UIControlState())
            }) { _ in
                
        }
    }
    
    func getTheDay()->Int?{
        let title = self.currentTitle!
        let dayStr = title.substring(from: title.characters.index(title.startIndex, offsetBy: 1)).replacingOccurrences(of: "/", with: "")
        return Int(dayStr)
    }
}


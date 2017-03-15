//
//  UIView+Frame.swift
//  DoudouApp
//
//  Created by yushuyi on 15/5/24.
//  Copyright (c) 2015年 DoudouApp. All rights reserved.
//

import Foundation
import UIKit

public enum SYLayoutAlignCenter : Int {
    case x = 0
    case y
    case upDown
    case leftRight
    case xy
}

extension UIView {
    
    //MARK: toBottom
    func toBottom (offsetScale : CGFloat) {
        if let superView = self.superview {
            self.bottom = superView.height - (superView.height * offsetScale)
        }else {
            print("UIView+SYAutoLayout toBottom 没有 superview");
        }
    }
    /**
     将视图移动到父视图的底端
     
     - parameter offset: 可进行微调 大于0 则  小于0 则
     */
    func toBottom(offset : CGFloat = 0.0) {
        if let superView = self.superview {
            self.bottom = superView.height - offset
        }else {
            print("UIView+SYAutoLayout toBottom 没有 superview");
        }
    }
    
    func toFullyBottom() {
        self.toBottom()
        self.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleWidth]
    }
    
    //MARK: toRight
    
    func toRight(_ offset : CGFloat = 0.0) {
        if let superView = self.superview {
            self.right = superView.width - offset
        }else {
            print("UIView+SYAutoLayout toRight 没有 superview");
        }
    }
    
    
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame = CGRect(origin: self.frame.origin, size: newValue)
        }
    }
    
    public var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame = CGRect(origin: newValue, size: self.frame.size)
        }
    }
    
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame;
            frame.origin.x = newValue;
            self.frame = frame
        }
    }
    
    public var right: CGFloat{
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame;
            frame.origin.x = newValue - frame.size.width;
            self.frame = frame;
        }
    }
    
    public var top: CGFloat{
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame;
            frame.origin.y = newValue;
            self.frame = frame;
        }
    }
    
    public var bottom: CGFloat{
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame;
            frame.origin.y = newValue - frame.size.height;
            self.frame = frame;
        }
    }
    
    public var width: CGFloat{
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame;
            frame.size.width = newValue;
            self.frame = frame;
        }
    }
    
    public var height: CGFloat{
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame;
            frame.size.height = newValue;
            self.frame = frame;
        }
    }
    
    func alignCenter (_ alignCenter : SYLayoutAlignCenter) {
        
        assert(self.superview != nil, "SYAutoLayoutTips:this view not have supview")
        
        if let superview = self.superview {
            
            if (alignCenter == SYLayoutAlignCenter.y || alignCenter == SYLayoutAlignCenter.upDown) {
                self.center = CGPoint(x: self.center.x, y: superview.frame.height/2)
            }
            else if (alignCenter == SYLayoutAlignCenter.x || alignCenter == SYLayoutAlignCenter.leftRight) {
                self.center = CGPoint(x: superview.width/2, y: self.center.y)
            }
            else if (alignCenter == SYLayoutAlignCenter.xy) {
                self.center = CGPoint(x: superview.width/2, y: superview.height/2)
            }
        }
        
    }
    
}

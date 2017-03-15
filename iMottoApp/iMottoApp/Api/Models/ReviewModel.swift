//
//  ReviewModel.swift
//  iMottoApp
//
//  Created by sunht on 16/7/15.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class ReviewModel:IMModelProtocol{
    let mid:Int64
    let id:Int64
    let uid:String
    var content:String
    var up:Int
    var down:Int
    var addTime:String
    var userName:String
    var userThumb:String
    var supported:SupportState
    
    required init(data: NSDictionary) {
        self.mid = (data.object(forKey: "MID") as! NSNumber).int64Value
        self.id = (data.object(forKey: "ID") as! NSNumber).int64Value
        self.uid = getStringFrom(data, withKey: "UID")
        self.content = getStringFrom(data, withKey: "Content")
        self.up = data.object(forKey: "Up") as! Int
        self.down = data.object(forKey: "Down") as! Int
        self.addTime = getStringFrom(data, withKey: "AddTime")
        self.userName = getStringFrom(data, withKey: "UserName")
        self.userThumb = getStringFrom(data, withKey: "UserThumb")
        
        if let state = SupportState(rawValue: data.object(forKey: "Supported") as! Int){
            self.supported = state
        }else{
            self.supported = SupportState.notYet
        }
    }
    
    
}

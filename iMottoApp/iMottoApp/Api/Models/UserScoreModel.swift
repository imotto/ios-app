//
//  UserScoreModel.swift
//  iMottoApp
//
//  Created by sunht on 16/9/27.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation


class UserScoreModel: IMModelProtocol{
    
    var uid: String
    var uname: String
    var thumb: String
    var score: Int
    
    required init(data: NSDictionary) {
        self.uid = getStringFrom(data, withKey: "UID")
        self.uname = getStringFrom(data, withKey: "Name")
        self.thumb = getStringFrom(data, withKey: "Thumb")
        self.score = data.object(forKey: "Score") as! Int
    }
    
}

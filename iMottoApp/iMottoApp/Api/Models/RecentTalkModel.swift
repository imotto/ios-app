//
//  RecentTalkModel.swift
//  iMottoApp
//
//  Created by sunht on 16/10/14.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

/*
 recentTalk:
 
 WithUID, UserName,UserThumb,Content,Direction,Msgs, LastTime
 */

class RecentTalkModel: IMModelProtocol{
    var withUid: String
    var userName: String
    var userThumb: String
    var content: String
    var direction: Int
    var msgs: Int
    var lastTime: String
    
    required init(data: NSDictionary) {
        self.withUid = getStringFrom(data, withKey: "WithUID")
        self.userName = getStringFrom(data, withKey: "UserName")
        self.userThumb = getStringFrom(data, withKey: "UserThumb")
        self.content = getStringFrom(data, withKey: "Content")
        self.direction = data.object(forKey: "Direction") as! Int
        self.msgs = data.object(forKey: "Msgs") as! Int
        self.lastTime = getStringFrom(data, withKey: "LastTime")
    }
}

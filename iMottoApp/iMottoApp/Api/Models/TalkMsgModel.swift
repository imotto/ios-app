//
//  TalkMsgModel.swift
//  iMottoApp
//
//  Created by sunht on 16/10/14.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation
/*
 
 talk:
 
ID,WithUID,Direction,Content,SendTime
 
 */

class TalkMsgModel: IMModelProtocol{
    
    var id: Int64
    var withUID: String
    var direction: Int
    var content: String
    var sendTime: String
    
    required init(data: NSDictionary) {
        self.id = (data.object(forKey: "ID") as! NSNumber).int64Value
        self.withUID = getStringFrom(data, withKey: "WithUID")
        self.direction = data.object(forKey: "Direction") as! Int
        self.content = getStringFrom(data, withKey: "Content")
        self.sendTime = getStringFrom(data, withKey: "SendTime")
    }
}

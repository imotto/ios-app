//
//  NoticeModel.swift
//  iMottoApp
//
//  Created by sunht on 16/10/18.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation


class NoticeModel: IMModelProtocol {
    var id: Int64
    var title: String
    var content: String
    var type: Int
    var sendTime: String
    var state: Int
    var targetId: String?
    var targetInfo: String?
    
    required init(data: NSDictionary) {
        self.id = (data.object(forKey: "ID") as! NSNumber).int64Value
        self.title = getStringFrom(data, withKey: "Title")
        self.content = getStringFrom(data, withKey: "Content")
        self.type = data.object(forKey: "Type") as! Int
        self.sendTime = getStringFrom(data, withKey: "SendTime")
        self.state = data.object(forKey: "State") as! Int
        self.targetId = getStringFrom(data, withKey: "TargetId")
        self.targetInfo = getStringFrom(data, withKey: "TargetInfo")
    }
}

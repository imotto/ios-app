//
//  BillRecordModel.swift
//  iMottoApp
//
//  Created by sunht on 16/10/8.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class BillRecordModel:IMModelProtocol{
    
    var id: Int64
    var changeType: Int
    var changeAmount: Int
    var changeTime: String
    var summary: String
    
    required init(data: NSDictionary) {
        self.id = (data.object(forKey: "ID") as! NSNumber).int64Value
        self.changeType = data.object(forKey: "ChangeType") as! Int
        self.changeAmount = data.object(forKey: "ChangeAmount") as! Int
        self.changeTime = getStringFrom(data, withKey: "ChangeTime")
        self.summary = getStringFrom(data, withKey: "Summary")
    }
}

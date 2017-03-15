//
//  VoteModel.swift
//  iMottoApp
//
//  Created by zhangkai on 22/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit

class VoteModel: IMModelProtocol {
    let uid:String
    let mid:Int64
    var userName:String
    var userThumb:String
    var oppose:Int
    var support:Int
    let id:Int64
    var voteTime:String
    
    required init(data: NSDictionary) {
        self.mid = (data.object(forKey: "MID") as! NSNumber).int64Value
        self.id = (data.object(forKey: "ID") as! NSNumber).int64Value
        self.uid = getStringFrom(data, withKey: "UID")
        self.support = data.object(forKey: "Support") as! Int
        self.oppose = data.object(forKey: "Oppose") as! Int
        self.voteTime = getStringFrom(data, withKey: "VoteTime")
        self.userName = getStringFrom(data, withKey: "UserName")
        self.userThumb = getStringFrom(data, withKey: "UserThumb")
    }
}

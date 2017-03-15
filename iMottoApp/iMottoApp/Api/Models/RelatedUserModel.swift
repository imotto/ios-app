//
//  RelatedUser.swift
//  iMottoApp
//
//  Created by sunht on 16/10/13.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class RelatedUserModel: IMModelProtocol{
    var id: String
    var name: String
    var displayName: String
    var sex: Int
    var thumb: String
    var isMutual: Bool
    var mottos: Int
    var revenue: Int
    var follows: Int
    var followers: Int
    var followTime: String
    var relation: Int
    
    required init(data: NSDictionary) {
        self.id = getStringFrom(data, withKey: "ID")
        self.name = getStringFrom(data, withKey: "UserName")
        self.displayName = getStringFrom(data, withKey: "DisplayName")
        self.sex = data.object(forKey: "Sex") as! Int
        self.thumb = getStringFrom(data, withKey: "Thumb")
        self.isMutual = data.object(forKey: "IsMutual") as! Bool
        self.mottos = data.object(forKey: "Mottos") as! Int
        self.revenue = data.object(forKey: "Revenue") as! Int
        self.follows = data.object(forKey: "Follows") as! Int
        self.followers = data.object(forKey: "Followers") as! Int
        self.followTime = getStringFrom(data, withKey: "FollowTime")
        
        self.relation = data.object(forKey: "RelationState") as! Int
    }
}

//
//  UserModel.swift
//  iMottoApp
//
//  Created by sunht on 16/9/27.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class UserModel: IMModelProtocol{
    var id: String
    var name: String
    var displayName: String
    var thumb: String
    var rank: Int
    var change: Int
    var mottos = 0
    var albums = 0
    var lovedMottos = 0
    var lovedAlbums = 0
    var revenue = 0
    var balance = 0
    var bans = 0
    var follows = 0
    var followers = 0
    var sex = 0
    var relation = 0
    
    
    required init(data: NSDictionary) {
        self.id = getStringFrom(data, withKey: "Id")
        self.name = getStringFrom(data, withKey: "UserName")
        self.displayName = getStringFrom(data, withKey: "DisplayName")
        self.thumb = getStringFrom(data, withKey: "Thumb")
        self.rank = data.object(forKey: "Rank") as! Int
        self.change = data.object(forKey: "Change") as! Int
        self.sex = data.object(forKey: "Sex") as! Int
        self.relation = data.object(forKey: "RelationState") as! Int
        
        if let dic = data.object(forKey: "Statistics") as? NSDictionary{
            self.mottos = dic.object(forKey: "Mottos") as! Int
            self.albums = dic.object(forKey: "Collections") as! Int
            self.lovedAlbums = dic.object(forKey: "LovedCollections") as! Int
            self.lovedMottos = dic.object(forKey: "LovedMottos") as! Int
            self.revenue = dic.object(forKey: "Revenue") as! Int
            self.balance = dic.object(forKey: "Balance") as! Int
            self.bans = dic.object(forKey: "Bans") as! Int
            self.follows = dic.object(forKey: "Follows") as! Int
            self.followers = dic.object(forKey: "Followers") as! Int
        }
    }
}

class SimpleUser{
    var id: String
    var name: String
    var thumb: String
    
    init(userModel:UserModel){
        self.id = userModel.id
        self.name = userModel.displayName
        self.thumb = userModel.thumb
    }
    
    init(relatedUser:RelatedUserModel){
        self.id = relatedUser.id
        self.name = relatedUser.displayName
        self.thumb = relatedUser.thumb
    }
    
    init(id:String, name: String, thumb: String){
        self.id = id
        self.name = name
        self.thumb = thumb
    }
}

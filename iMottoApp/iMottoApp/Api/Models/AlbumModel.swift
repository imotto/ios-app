//
//  AlbumModel.swift
//  iMottoApp
//
//  Created by sunht on 16/9/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class AlbumModel: IMModelProtocol{
    let id:Int64
    var title:String
    var uid:String
    var uname:String
    var uthumb:String
    var tags:String
    var summary:String
    var mottos:Int
    var loves:Int
    var createTime:String
    var loved:LovedState
    var containsMID:Int64
    
    required init(data: NSDictionary) {
        self.id = (data.object(forKey: "ID") as! NSNumber).int64Value
        self.title = getStringFrom(data, withKey: "Title")
        self.tags = getStringFrom(data, withKey: "Tags")
        self.summary = getStringFrom(data, withKey: "Description")
        self.mottos = data.object(forKey: "Mottos") as! Int
        self.loves = data.object(forKey: "Loves") as! Int
        self.createTime = getStringFrom(data, withKey: "CreateTime")
        self.uid = data.object(forKey: "UID") as! String
        self.uname = getStringFrom(data, withKey: "UserName")
        self.uthumb = getStringFrom(data, withKey: "UserThumb")
        
        if let vloved = LovedState(rawValue: data.object(forKey: "Loved") as! Int){
            self.loved = vloved
        }else{
            self.loved = LovedState.nofeeling
        }
        
        self.containsMID = (data.object(forKey: "ContainsMID") as! NSNumber).int64Value
    }
}

//
//  GiftModel.swift
//  iMottoApp
//
//  Created by sunht on 2016/12/7.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class GiftModel:IMModelProtocol{
    
    var id:Int
    var name:String
    var vendor:String
    var summary:String
    var url:String
    var img:String
    var price:Int
    var amount:Int
    var rate:Int
    var avaiable:Int
    var addTime:String
    var endTime:String
    var status:Int
    var sales:Int
    var giftType:Int
    var limitType:Int
    var requireInfo:Int
    var reviews:Int

    required init(data: NSDictionary) {
        id = data.object(forKey: "ID") as! Int
        name = getStringFrom(data, withKey: "Name")
        vendor = getStringFrom(data, withKey: "Vendor")
        summary = getStringFrom(data, withKey: "Description")
        url = getStringFrom(data, withKey: "URL")
        img = getStringFrom(data, withKey: "Img")
        price = data.object(forKey: "Price") as! Int
        amount = data.object(forKey: "Amount") as! Int
        avaiable = data.object(forKey: "Available") as! Int
        rate = data.object(forKey: "Rate") as! Int
        addTime = getStringFrom(data, withKey: "AddTime")
        endTime = getStringFrom(data, withKey: "EndTime")
        status = data.object(forKey: "Status") as! Int
        sales = data.object(forKey: "Sales") as! Int
        giftType = data.object(forKey: "GiftType") as! Int
        limitType = data.object(forKey: "LimitType") as! Int
        requireInfo = data.object(forKey: "RequireInfo") as! Int
        reviews = data.object(forKey: "Reviews") as! Int
    }
}

class GiftExchangeModel:IMModelProtocol{
    
    var id:Int64
    var uid:String
    var giftId:Int
    var amount:Int
    var total:Int
    var exchangeTime:String
    var deliverState:Int
    var rate:Int
    var review:String
    var excode:String
    var giftName:String
    
    
    required init(data: NSDictionary) {
        id = (data.object(forKey: "ID") as! NSNumber).int64Value
        uid = getStringFrom(data, withKey: "UID")
        giftId = data.object(forKey: "GiftId") as! Int
        amount = data.object(forKey: "Amount") as! Int
        total = data.object(forKey: "Total") as! Int
        exchangeTime = getStringFrom(data, withKey: "ExchangeTime")
        deliverState = data.object(forKey: "DeliverState") as! Int
        rate = data.object(forKey: "Rate") as! Int
        review = getStringFrom(data, withKey: "Review")
        excode = getStringFrom(data, withKey: "ExCode")
        giftName = getStringFrom(data, withKey: "GiftName")
    }
}






//
//  PrepareExchangeResultModel.swift
//  iMottoApp
//
//  Created by WangAnnda on 2016/12/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

///礼品兑换预备信息 PrepareExchangeResultModel
class PEResultModel:RespBase{
    var balance:Int?
    var reqInfoType:Int?
    var reqInfoHint:String?
    var accounts:Array<RelAccountModel>?
    var addresses:Array<UserAddressModel>?
    
    required init(data resp: NSDictionary) {
        super.init(data: resp)
        if self.isSuccess{
            if let result = resp.object(forKey: "Data") as? NSDictionary{
                self.balance = result.object(forKey: "Balance") as? Int
                self.reqInfoType = result.object(forKey: "ReqInfoType") as? Int
                self.reqInfoHint = getStringFrom(result, withKey: "ReqInfoHint")
                
                self.accounts = Array<RelAccountModel>()
                if let array = result.object(forKey: "Accounts") as? NSArray{
                    for dic in array{
                        if let item = dic as? NSDictionary{
                            self.accounts?.append(RelAccountModel(data: item))
                        }
                    }
                }
                
                self.addresses = Array<UserAddressModel>()
                if let array = result.object(forKey: "Addresses") as? NSArray{
                    for dic in array{
                        if let item = dic as? NSDictionary{
                            self.addresses?.append(UserAddressModel(data:item))
                        }
                    }
                }
            }
        }
    }
}

class RelAccountModel:IMModelProtocol{
    var id:Int64
    var uid:String
    var platform:Int
    var accountNo:String
    var accountName:String
    required init(data: NSDictionary) {
        self.id = (data.object(forKey: "ID") as! NSNumber).int64Value
        self.uid = getStringFrom(data, withKey: "UID")
        self.platform = data.object(forKey: "Platform") as! Int
        self.accountNo = getStringFrom(data, withKey: "AccountNo")
        self.accountName = getStringFrom(data, withKey: "AccountName")
    }
}

class UserAddressModel:IMModelProtocol{
    var id:Int64
    var uid:String
    var province:String
    var city:String
    var district:String
    var address:String
    var zip:String
    var contact:String
    var mobile:String
    var isDefault:Bool?
    
    
    required init(data: NSDictionary) {
        self.id = (data.object(forKey: "ID") as! NSNumber).int64Value
        self.uid = getStringFrom(data, withKey: "UID")
        self.province = getStringFrom(data, withKey: "Province")
        self.city = getStringFrom(data, withKey: "City")
        self.district = getStringFrom(data, withKey: "District")
        self.address = getStringFrom(data, withKey: "Address")
        self.zip = getStringFrom(data, withKey: "Zip")
        self.contact = getStringFrom(data, withKey: "Contact")
        self.mobile = getStringFrom(data, withKey: "Mobile")
        self.isDefault = data.object(forKey: "IsDefault") as? Bool
    }
}








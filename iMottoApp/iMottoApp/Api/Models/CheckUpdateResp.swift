//
//  CheckUpdateResp.swift
//  iMottoApp
//
//  Created by sunht on 16/5/31.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class CheckUpdateResp:RespBase{
    var UpdateFlag:String?
    var CurVer:String?
    var CurVerCode:Int?
    var Url:String?
    var UpdateDes:String?
    var ReleaseTime:Date?
    
    required init(data resp:NSDictionary){
        super.init(data: resp)
        if(self.isSuccess){
            self.UpdateFlag = resp.object(forKey: "UpdateFlag") as? String
            self.CurVer = resp.object(forKey: "CurVer") as? String
            self.CurVerCode = resp.object(forKey: "CurVerCode") as? Int
            self.Url = resp.object(forKey: "Url") as? String
            self.UpdateDes = resp.object(forKey: "UpdateDes") as? String
            self.ReleaseTime = resp.object(forKey: "ReleaseTime") as? Date
        }
    }
}

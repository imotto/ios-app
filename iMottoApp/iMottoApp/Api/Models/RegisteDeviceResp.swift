//
//  RegisteDeviceResp.swift
//  iMottoApp
//
//  Created by sunht on 16/5/22.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class RegisteDeviceResp : RespBase{
    var signature:String?
    var updateFlag:Int?
    var updateSummary: String?
    
    required init(data resp:NSDictionary){
        super.init(data: resp)
        
        if self.isSuccess {
            self.signature = resp.object(forKey: "Sign") as? String
            self.updateFlag = resp.object(forKey: "UpdateFlag")  as? Int
            self.updateSummary = resp.object(forKey: "UpdateSummary")  as? String
        }
    }
}

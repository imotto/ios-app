//
//  AddExchangeInfoResp.swift
//  iMottoApp
//
//  Created by WangAnnda on 2016/12/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class AddExchangeInfoResp:RespBase{
    
    var infoId:Int64 = 0
    
    required init(data resp: NSDictionary) {
        super.init(data: resp)
        if self.isSuccess{
           self.infoId = (resp.object(forKey: "Data") as! NSNumber).int64Value
        }
    }

}

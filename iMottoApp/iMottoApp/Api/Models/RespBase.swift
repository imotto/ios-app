//
//  RespBase.swift
//  iMottoApp
//
//  Created by sunht on 16/5/22.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class RespBase:IMModelProtocol{
    var raw : NSDictionary
    var state : Int
    var msg : String
    var code : String
    
    var isSuccess:Bool{
        return self.state == 0
    }
    
    required init(data resp:NSDictionary){
        self.raw = resp
        self.code = getStringFrom(resp, withKey: "Code")
        self.state = resp.object(forKey: "State") as! Int
        self.msg = getStringFrom(resp, withKey: "Msg")
    }
    
    
    
}

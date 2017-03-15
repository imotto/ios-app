//
//  LoginResp.swift
//  iMottoApp
//
//  Created by sunht on 16/5/23.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class LoginResp : RespBase{
    var userid:String?
    var userName:String?
    var userToken:String?
    var userThumb:String?
    
    required init(data resp: NSDictionary) {
        super.init(data: resp)
        if self.isSuccess{
            self.userid = resp.object(forKey: "UserId") as? String
            self.userName = resp.object(forKey: "UserName") as? String
            self.userToken = resp.object(forKey: "UserToken") as? String
            self.userThumb = resp.object(forKey: "UserThumb") as? String
        }
    }
    
}

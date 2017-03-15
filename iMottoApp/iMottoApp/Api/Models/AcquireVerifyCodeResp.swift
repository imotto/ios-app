//
//  acquireVerifyCodeResp.swift
//  iMottoApp
//
//  Created by sunht on 16/5/31.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class AcquireVerifyCodeResp : RespBase{
    var content : String?
    
    required init(data resp : NSDictionary){
        super.init(data: resp)
        
        if self.isSuccess{
            self.content = resp.object(forKey: "Content") as? String
        }
    }
}

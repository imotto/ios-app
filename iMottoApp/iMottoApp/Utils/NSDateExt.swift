//
//  NSDateExt.swift
//  iMottoApp
//
//  Created by sunht on 16/6/15.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

extension Date{
    ///扩展方法 返回 HH:mm:ss
    func toShortString()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.string(from: self);
    }
    
    func toLocaleDate()->Date{
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: self)
        
        return self.addingTimeInterval(TimeInterval(interval))
    }
    
    func toDayString()->String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    static func fromString(_ dateStr:String) -> Date?{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateStr)
        debugPrint("\(date)")
        return date
    }
}

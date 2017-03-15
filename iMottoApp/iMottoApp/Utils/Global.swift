//
//  Global.swift
//  iMottoApp
//
//  Created by sunht on 16/6/4.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation
import UIKit

/// 从文本框中验证并读取用户输入的手机号码。
/// 
/// - parameter txtMobile: 用于输入手机号的TextField
///
/// - returns: 验证合法的手机号码或nil.
func checkMobile(_ txtMobile: UITextField )->String?{
    let regex = "^1[345789]\\d{9}$"
    let mobile = txtMobile.text
    
    let regextest = NSPredicate(format: "SELF MATCHES %@", regex)
    
    if regextest.evaluate(with: mobile){
        return mobile
    }else{
        return nil
    }
}

func getStringFrom(_ dict:NSDictionary, withKey key:String)->String{
    if let tmp = dict.object(forKey: key) as? String{
        return tmp
    }
    return ""
}

func ConvertToDate(fromtheday theday:Int) -> Date?{
    let calendar = Calendar.current
    var comps = DateComponents()
    comps.year = theday/10000
    comps.month = theday%10000/100
    comps.day = theday%100
    
    let date = calendar.date(from: comps)
    
    return date
}

func extractTheDay(_ dateStr: String)->Int{
    if dateStr.characters.count > 10 {
        let str = dateStr.replacingOccurrences(of: "-", with: "")
        if let tmp = Int(str.substring(to: str.characters.index(str.startIndex, offsetBy: 8))){
            return tmp
        }
    }
    
    return 0
}

func friendlyTime(_ dateTime: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "zh_CN")
    dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
    if let date = dateFormatter.date(from: dateTime) {
        let delta = Date().timeIntervalSince(date)
        
        if (delta <= 5) {
            return "刚刚"
        }
        else if (delta < 60) {
            return "\(Int(delta))秒前"
        }
        else if (delta < 3600) {
            return "\(Int(delta / 60))分钟前"
        }
        else {
            let calendar = Calendar.current
            let unitFlags: NSCalendar.Unit = [NSCalendar.Unit.year , NSCalendar.Unit.month , NSCalendar.Unit.day , NSCalendar.Unit.hour , NSCalendar.Unit.minute]
            let comp = (calendar as NSCalendar).components(unitFlags, from: Date())
            let currentYear = String(describing: comp.year!)
            let currentDay = String(describing: comp.day!)
            
            let comp2 = (calendar as NSCalendar).components(unitFlags, from: date)
            let year = String(describing: comp2.year!)
            let month = String(describing: comp2.month!)
            let day = String(describing: comp2.day!)
            var hour = String(describing: comp2.hour!)
            var minute = String(describing: comp2.minute!)
            
            if comp2.hour! < 10 {
                hour = "0" + hour
            }
            if comp2.minute! < 10 {
                minute = "0" + minute
            }
            
            if currentYear == year {
                if currentDay == day {
                    return "今天 \(hour):\(minute)"
                } else {
                    return "\(month)-\(day) \(hour):\(minute)"
                }
            } else {
                return "\(year)-\(month)-\(day) \(hour):\(minute)"
            }
        }
    }
    return ""
}

func showInAppStore() {
    let url = URL(string: "https://itunes.apple.com/app/id1191145702")
    UIApplication.shared.openURL(url!)
}

func printLog<T>(_ message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line) {
    //#if DEBUG
        //print("\n\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)\n")
    //#endif
}


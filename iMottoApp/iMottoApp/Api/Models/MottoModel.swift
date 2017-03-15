//
//  MottoModel.swift
//  iMottoApp
//
//  Created by sunht on 16/6/8.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

protocol IMModelProtocol {
    init(data:NSDictionary);
}

enum CastError:Error{
    case notExists
    case nullVlaue
}


class MottoModel:IMModelProtocol{
    let id:Int64
    let uid:String
    var score:Double
    var up:Int
    var down:Int
    var reviews:Int
    var loves : Int
    let recruitID : Int
    let recruitTitle : String?
    var content : String
    var addTime : String
    var userName: String
    var userThumb: String
    var state : MottoState
    var loved : LovedState
    var vote : VoteState
    var collect: CollectState
    var reviewed: Int
    //var voteTime : String
    
    required init(data:NSDictionary){
        self.id = (data.object(forKey: "ID") as! NSNumber).int64Value
        self.uid = getStringFrom(data, withKey: "UID")
        self.score = data.object(forKey: "Score") as! Double
        self.up = data.object(forKey: "Up") as! Int
        self.down = data.object(forKey: "Down") as! Int
        self.reviews = data.object(forKey: "Reviews") as! Int
        self.loves = data.object(forKey: "Loves") as! Int
        self.recruitID = data.object(forKey: "RecruitID") as! Int
        self.recruitTitle = data.object(forKey: "RecruitTitle") as? String
        self.content = getStringFrom(data, withKey: "Content")
        self.addTime = getStringFrom(data, withKey: "AddTime")
        self.userName = getStringFrom(data, withKey: "UserName")
        self.userThumb = getStringFrom(data, withKey: "UserThumb")
        self.reviewed =  data.object(forKey: "Reviewed") as! Int
        
        
        if let mstate = MottoState(rawValue: data.object(forKey: "State") as! Int){
            self.state = mstate
        }else{
            self.state = MottoState.permanent
        }
        
        if let lstate = LovedState(rawValue: data.object(forKey: "Loved") as! Int){
            self.loved = lstate
        }else{
            self.loved = LovedState.nofeeling
        }
        
        if let vstate = VoteState(rawValue: data.object(forKey: "Vote") as! Int){
            self.vote = vstate
        }else{
            self.vote = VoteState.noVote
        }
        
        if let vcollect = CollectState(rawValue: data.object(forKey: "Collected") as! Int){
            self.collect = vcollect
        }else{
            self.collect = CollectState.notYet
        }
    }
}

// reload == operator
func ==(m1:MottoModel, m2:MottoModel)->Bool{
    return m1.id == m2.id
}


extension MottoModel{
    func getTheDay()->Int?{
        if(self.addTime.characters.count>10){
            let day = self.addTime.substring(to: self.addTime.characters.index(self.addTime.startIndex, offsetBy: 10)).replacingOccurrences(of: "-", with: "")
            return Int(day)
        }
        return 0
    }
    
    func getTime(withDate:Bool = false)->String{
        if(!withDate && self.addTime.characters.count >= 19){
            return self.addTime.substring(from: self.addTime.characters.index(self.addTime.endIndex, offsetBy: -8))
        }
        
        return self.addTime
    }
    
    func formatCount(count:Int) -> String {
        if (count > 1000000) {
            let value:Float = Float(count) / Float(1000000)
            return "\(String(format: "%.1f", value))M"
        } else if (count > 1000) {
            let value:Float = Float(count) / Float(1000)
            return "\(String(format: "%.1f", value))K"
        }
        
        return String(count)
    }
}


class ReadResp<T:IMModelProtocol>:RespBase{
    var Data : Array<T>?
    
    required init(data resp: NSDictionary) {
        super.init(data: resp)
        if(self.isSuccess){
            self.Data = Array<T>()
            if let array = resp.object(forKey: "Data") as? NSArray{
                for dic in array{
                    if let item = dic as? NSDictionary{
                        self.Data?.append(T(data: item))
                    }
                }
            }else if let dic = resp.object(forKey: "Data") as? NSDictionary{
                self.Data?.append(T(data: dic))
            }
        }
    }
    
}

//
//  MottoState.swift
//  iMottoApp
//
//  Created by sunht on 16/6/15.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

///motto 状态
enum MottoState:Int{
    case evaluating = 0
    case permanent = 1
    
}

///motto album 喜欢状态
enum LovedState:Int{
    case nofeeling = 0
    case loved = 1
}

///Motto投票状态
enum VoteState:Int{
    case opposed = -1
    case middle = 0
    case supported = 1
    case noVote = 9
}

enum VoteAction:Int {
    case dislike = -1
    case moderate = 0
    case like = 1
}

///评论支持状态
enum SupportState:Int{
    case opposed = -1
    case notYet = 0
    case supported = 1
}

enum CollectState:Int{
    case notYet = 0
    case collected = 1
}

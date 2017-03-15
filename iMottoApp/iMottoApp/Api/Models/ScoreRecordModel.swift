//
//  ScoreRecordModel.swift
//  iMottoApp
//
//  Created by sunht on 16/10/8.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

class ScoreRecordModel: IMModelProtocol{

    var theDay: Int
    var mottos: Int
    var revenue: Int
    var score: Int
    
    required init(data: NSDictionary) {
        self.theDay = data.object(forKey: "TheDay") as! Int
        self.mottos = data.object(forKey: "Mottos") as! Int
        self.revenue = data.object(forKey: "Revenue") as! Int
        self.score = data.object(forKey: "Score") as! Int
    }
}

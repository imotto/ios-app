//
//  RankingViewDelegate.swift
//  iMottoApp
//
//  Created by sunht on 16/9/22.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation

protocol RankingViewDelegate {
    func support(_ rowIndex: Int)
    func oppose(_ rowIndex: Int)
}

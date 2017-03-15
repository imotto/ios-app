//
//  UITableViewExt.swift
//  iMottoApp
//
//  Created by sunht on 16/9/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAndLayoutTableHeaderView(_ header: UIView) {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        self.tableHeaderView = header
    }
    
    func displayMsg(_ msg:String, forRowCount rowCount:Int){
        if (rowCount == 0) {
            // Display a message when the table is empty
            // 没有数据的时候，UILabel的显示样式
            let lblMsg = UILabel()
            lblMsg.text = msg;
            lblMsg.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            lblMsg.textColor = UIColor.lightGray
            lblMsg.textAlignment = .center
            lblMsg.sizeToFit()
            
            self.backgroundView = lblMsg
            self.separatorStyle = .none
        } else {
            self.backgroundView = nil;
            self.separatorStyle = .singleLine;
        }
    }
}

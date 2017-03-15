//
//  NoticeController.swift
//  iMottoApp
//
//  Created by sunht on 16/10/19.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class NoticeController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    
    var notice: NoticeModel!
    var stateChangedCallBack: (()->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.title = "系统提醒"
        self.lblAction.isHidden = true
        
        setup()
    }

    func setup(){
        self.lblTitle.text = "积分结算通知"
        if notice.state == 0{
            self.imgState.image = ImgEmail
            self.lblState.text = "未读"
        }else{
            self.imgState.image = ImgEmailOpen
            self.imgState.tintColor = COLOR_BTN_TINT
            self.lblState.text = "已读"
        }
        self.lblTime.text = friendlyTime(notice.sendTime)
        self.lblContent.text = notice.content
        
        if(self.notice.state == 0){
            IMApi.instance.setNoticeRead(notice.id) { (resp) in
                if resp.isSuccess{
                    self.notice.state = 1
                    if(self.stateChangedCallBack != nil){
                        self.stateChangedCallBack!()
                    }
                }
            }
        }
    }
}

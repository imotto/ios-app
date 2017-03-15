//
//  GiftDetailController.swift
//  iMottoApp
//
//  Created by sunht on 2016/12/8.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import SnapKit

class GiftDetailController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnExchange: UIButton!
    
    var gift:GiftModel!
    var prepareResult:PEResultModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationItem.title = gift.name
        
        setup()
        
        //prepare
        prepareExchange()
    }
    
    func setup(){
        let nib = UINib(nibName: "GiftDetailView", bundle: nil)
        let detailView = nib.instantiate(withOwner: nil, options: nil)[0] as! GiftDetailView
        
        detailView.setModel(gift)
        self.scrollView.addSubview(detailView)
        detailView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.margins.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        self.scrollView.contentSize = CGSize(width: self.view.width, height: detailView.size.height)
        
        self.lblBalance.text = "0"
    }
    
    func prepareExchange(){
        IMApi.instance.prepareExchange(gift.id, reqInfoType: gift.requireInfo) { (resp) in
            if resp.isSuccess{
                self.lblBalance.text="\(resp.balance!)"
                self.prepareResult = resp
                self.btnExchange.isEnabled = true
            }else{
                self.view.makeToast("无法读取您的可用金币")
            }
        }
    }
    
    @IBAction func btnExchangeTapped(_ sender: AnyObject) {
        if prepareResult != nil{
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            
            let controller = storyboard.instantiateViewController(withIdentifier: "SelExchangeInfoController") as! SelExchangeInfoController
            controller.prepareModel = self.prepareResult
            controller.giftId = self.gift.id
            controller.exchangedCallback = {
                self.view.window?.makeToast("兑换成功,请静候礼品发放")
                self.prepareExchange()
            }
            self.navigationController?.pushViewController(controller, animated: true)

            
//            if prepareResult?.balance >= gift.price{
//                let controller = SelExchangeInfoController()
//                controller.prepareModel = self.prepareResult
//                self.navigationController?.pushViewController(controller, animated: true)
//            }else{
//                self.view.makeToast("可用金币不足")
//            }
        }else{
            prepareExchange()
        }
    }
    

}

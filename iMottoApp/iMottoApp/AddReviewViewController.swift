//
//  AddReviewViewController.swift
//  iMottoApp
//
//  Created by zhangkai on 27/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import Cosmos
import KMPlaceholderTextView

class AddReviewViewController: UIViewController {
    var exchangeId:String = ""
    var labelTips:UILabel!
    var ratingView:CosmosView!
    var textView:KMPlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        let saveImg = FAKIonIcons.iosPaperplaneOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        let buttonSend = UIBarButtonItem(image: saveImg, style: .plain, target: self, action: #selector(buttonSendClicked))
        buttonSend.tintColor = COLOR_NAV_TINT
        self.navigationItem.rightBarButtonItem = buttonSend
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationItem.title = "填写评价"
        
        self.view.backgroundColor = UIColor.white
        
        labelTips = UILabel()
        labelTips.font = UIFont.systemFont(ofSize: 15)
        labelTips.textColor = UIColor("#999999")
        labelTips.numberOfLines = 0
        self.view.addSubview(labelTips)
        labelTips.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(8)
            make.right.equalTo(-8)
        }
        
        let tips = "您的评价将决定此礼品后期是否继续提供，以及此赞助商资格的存续，敬请公正客观。"
        let attributedString = NSMutableAttributedString(string: tips)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        labelTips.attributedText = attributedString;
        
        ratingView = CosmosView()
        ratingView.settings.starSize = 40
        ratingView.settings.filledColor = COLOR_NAV_BG
        ratingView.settings.emptyBorderColor = COLOR_NAV_BG
        ratingView.settings.filledBorderColor = COLOR_NAV_BG
        ratingView.settings.fillMode = .half
        ratingView.settings.minTouchRating = 0
        ratingView.rating = 5
        self.view.addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.top.equalTo(labelTips.snp.bottom).offset(8)
            make.left.equalTo(8)
        }
        
        textView = KMPlaceholderTextView()
        textView.placeholder = "填写评价信息"
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor("#999999").cgColor
        self.view.addSubview(textView)
        textView.snp.makeConstraints{ (make) in
            make.top.equalTo(ratingView.snp.bottom).offset(8)
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.height.equalTo(100)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func buttonSendClicked(_ sender:UIButton) {
        self.dismissKeyboard()
        
        ToastManager.shared.makeToastActivity(self.view)
        
        IMApi.instance.doExchangeComment(exchangeId, rate: Float(ratingView.rating), comment: textView.text) { (resp) in
            ToastManager.shared.hideToastActivity()
            if resp.isSuccess{
                _ = self.navigationController?.popViewController(animated: true)
            }
            else{
                self.view.window?.makeToast("发送失败，请重试。")
            }
        }
    }
    
    func dismissKeyboard(){
        textView.resignFirstResponder()
    }
    
    func keyboardWillChangeFrame(_ notification : Notification) {
        if self.view.window == nil { return }
        if !self.view.window!.isKeyWindow { return }
        
        if textView.isFirstResponder {
            var userInfo = (notification as NSNotification).userInfo as! [String : AnyObject]
            let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardFrame = keyboardFrameValue.cgRectValue
            printLog("keyboardFrame: \(keyboardFrame)")
            let y1 = keyboardFrame.origin.y
            let y2 = 64 + textView.frame.origin.y + textView.frame.size.height
            if y1 < y2 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                    self.labelTips.snp.updateConstraints({ (make) in
                        make.top.equalTo(y1 - y2)
                    })
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                    self.labelTips.snp.updateConstraints({ (make) in
                        make.top.equalTo(8)
                    })
                }, completion: nil)
            }
            
        }
    }

}

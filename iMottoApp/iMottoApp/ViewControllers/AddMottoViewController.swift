//
//  AddMottoViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/6/5.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class AddMottoViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var txtMotto: UITextView!
    var placeHolder:String = "在这里，记下你的偶得..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        
        let saveImg = FAKIonIcons.iosPaperplaneOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        let saveBtn = UIBarButtonItem(image: saveImg, style: .plain, target: self, action: #selector(sendMyMotto))
        saveBtn.tintColor = COLOR_NAV_TINT
        
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.rightBarButtonItem = saveBtn
        self.navigationItem.title = "创作"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        txtMotto.text = placeHolder
        txtMotto.layer.borderWidth = 0.5
        txtMotto.layer.cornerRadius = 4
        txtMotto.layer.borderColor = UIColor("#C7C7CD").cgColor
    }
    
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeHolder{
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == ""{
            textView.text = placeHolder
            textView.textColor = UIColor.gray
        }
        
        return true
    }
    

    func sendMyMotto(_ sender: AnyObject) {
        if self.txtMotto.text == ""{
            self.view.endEditing(true)
            return
        }
        
        if self.txtMotto.text.characters.count<5{
            displayAlert("内容不能少于5个字。", message: nil)
            return
        }
        
        if self.txtMotto.text.characters.count>500{
            displayAlert("作品内容最多500个字，请精简一下吧。", message: nil)
            return
        }
        
        self.txtMotto.resignFirstResponder()
        ToastManager.shared.makeToastActivity(self.view)
        
        IMApi.instance.addMotto(0, content: self.txtMotto.text) { (resp) in
            ToastManager.shared.hideToastActivity()
            if resp.isSuccess{
                let controller = UIAlertController(title: "您的作品已开始接受评估，七天后结算积分。", message: nil, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                    self.navBackTapped(nil)
                }))
                
                self.present(controller, animated: true, completion: nil)
            }
            else{
                self.view.window?.makeToast("发送失败，请重试。")
            }
        }
        
    }
}

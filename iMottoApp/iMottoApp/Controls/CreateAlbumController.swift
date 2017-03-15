//
//  CreateAlbumViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/9/17.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class CreateAlbumController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtSummary: UITextView!
    var placeHolder="输入珍藏简要说明"
    var successCallback:(()->Void)?
    var album: AlbumModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        let saveImg = FAKIonIcons.iosPaperplaneOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        let saveBtn = UIBarButtonItem(image: saveImg, style: .plain, target: self, action: #selector(saveTapped))
        saveBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.rightBarButtonItem = saveBtn
        
        self.txtSummary.delegate = self
        txtSummary.layer.borderWidth = 0.5
        txtSummary.layer.cornerRadius = 4
        txtSummary.layer.borderColor = UIColor("#C7C7CD").cgColor
        
        if (album != nil) {
            self.navigationItem.title = "修改珍藏"
            self.txtTitle.text = album.title
            self.txtSummary.text = album.summary
            self.txtSummary.textColor = UIColor("#333333")
        } else {
            self.navigationItem.title = "创建珍藏"
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeHolder{
            textView.text = ""
            textView.textColor = UIColor("#333333")
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == ""{
            textView.text = placeHolder
            textView.textColor = UIColor("#C7C7CD")
        }
        
        return true
    }
    
    
    func saveTapped(_ sender:AnyObject?){
        if self.txtTitle.text == ""{
            self.view.endEditing(true)
            return
        }
        
        self.txtTitle.resignFirstResponder()
        self.txtSummary.resignFirstResponder()
        ToastManager.shared.makeToastActivity(self.view)
        
        if (album != nil) {
            IMApi.instance.updateCollection(album.id, title: self.txtTitle.text!, tags: "", summary: self.txtSummary.text, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                
                if resp.isSuccess{
                    self.view.window?.makeToast("珍藏修改成功")
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NotificationNameUpdateCollection, object:nil)
                }else{
                    self.view.window?.makeToast("发生错误")
                }
            })
        } else {
            IMApi.instance.addCollectin(self.txtTitle.text!, tags: "", summary: self.txtSummary.text, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                
                if resp.isSuccess{
                    self.view.window?.makeToast("珍藏创建成功")
                    
                    if self.successCallback != nil{
                        self.successCallback!()
                    }
                    
                    self.navBackTapped(nil)
                }else{
                    self.view.window?.makeToast("发生错误")
                }
            })
        }
    }
   
}

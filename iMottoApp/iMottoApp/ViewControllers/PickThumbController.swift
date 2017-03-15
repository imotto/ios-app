//
//  PickThumbController.swift
//  iMottoApp
//
//  Created by sunht on 16/9/29.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class PickThumbController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var btnGallary: UIButton!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var btnCamera: UIButton!
    var userInfo:UserModel?
    var callback: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnGallary.setImage(FAKIonIcons.iosPhotosOutlineIcon(withSize: 24).image(with: CGSize(width: 24, height: 24)), for: UIControlState())
        btnCamera.setImage(FAKIonIcons.iosCameraOutlineIcon(withSize: 28).image(with: CGSize(width: 28, height: 28)), for: UIControlState())
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        let okImg = FAKIonIcons.androidDoneIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        let okBtn = UIBarButtonItem(image: okImg, style: .plain, target: self, action: #selector(okTapped))
        okBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.rightBarButtonItem = okBtn
        
        self.navigationItem.title = "设置用户头像"
        
        self.imgThumb.layer.cornerRadius = self.imgThumb.frame.size.width/2
        self.imgThumb.clipsToBounds = true
        self.imgThumb.layer.borderWidth = 0.3
        self.imgThumb.layer.borderColor = UIColor.gray.cgColor
        
    }
    @IBAction func btnCameraTapped(_ sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = self
        controller.allowsEditing = true
        
        self.present(controller, animated: true, completion: nil)
        
    }
    @IBAction func btnGallaryTapped(_ sender: AnyObject) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        
        controller.delegate = self
        controller.allowsEditing = true
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imgThumb.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func okTapped(_ senfer: AnyObject?){
        if let thumb = self.imgThumb.image{
            ToastManager.shared.makeToastActivity(self.view)
            IMApi.instance.modifyThumb(thumb, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    PropHelper.instance.userThumb = resp.msg
                    
                    if self.userInfo != nil{
                        self.userInfo?.thumb = resp.msg
                    }
                    self.view.window?.makeToast("用户头像更新成功")
                    self.callback?()
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.view.window?.makeToast("发生错误：\(resp.msg)")
                }
            })
        }
    }
    
}

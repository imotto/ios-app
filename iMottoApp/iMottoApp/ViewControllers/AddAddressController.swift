//
//  AddAddressController.swift
//  iMottoApp
//
//  Created by WangAnnda on 2016/12/10.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class AddAddressController: UIViewController, AddressPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSelCity: UIButton!
    @IBOutlet weak var txtAddr: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    
    var pickerView:AddressPickerView!
    
    var province:String?
    var city:String?
    var district:String?
    var addressAdded:((UserAddressModel)->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView?.tintColor = COLOR_NAV_TINT
        self.navigationItem.title = "添加地址"
        
        let btnBack = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        btnBack.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = btnBack
        
        let okImg = FAKIonIcons.androidDoneIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        let okBtn = UIBarButtonItem(image: okImg, style: .plain, target: self, action: #selector(doneTapped))
        okBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.rightBarButtonItem = okBtn
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.view.addSubview(getPickerView())
    }
    
    func dismissKeyboard(){
        self.txtMobile.resignFirstResponder()
        self.txtContact.resignFirstResponder()
        self.txtZip.resignFirstResponder()
        self.txtAddr.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let frame = textField.frame
        let scrollPoint = CGPoint(x: 0,y: frame.origin.y - 80)
        
        scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtAddr{
            self.txtZip.becomeFirstResponder()
        }else if textField == txtZip{
            self.txtContact.becomeFirstResponder()
        }else if textField == txtContact{
            self.txtMobile.becomeFirstResponder()
        }else{
            self.doneTapped(nil)
        }
        
        return true
    }
    
    func getPickerView()->AddressPickerView{
        if pickerView == nil{
            let screen = UIScreen.main
            pickerView = AddressPickerView(frame: CGRect(x: 0, y: screen.bounds.height, width: screen.bounds.width, height: 255))
            pickerView.delegate = self
        }
        
        return pickerView
    }
    
    func doneTapped(_ sender: AnyObject?){
        
        dismissKeyboard()
        
        if(province == nil){
            self.view.window?.makeToast("请选择城市")
            return
        }
        
        let addr = txtAddr.text!
        let zip = txtZip.text!
        let contact = txtContact.text!
        let mobile = txtMobile.text!
        
        if addr == ""{
            self.view.window?.makeToast("请填写具体地址")
            return
        }
        
        if contact == ""{
            self.view.window?.makeToast("请填写收件人")
            return
        }
        
        if mobile == ""{
            self.view.window?.makeToast("请填写收件人手机号码")
            return
        }
        
        ToastManager.shared.makeToastActivity(self.view)
        IMApi.instance.addAddress(province!, city: city!, district: district!, addr: addr, zip: zip, contact: contact, mobile: mobile) { (resp) in
            ToastManager.shared.hideToastActivity()
            if resp.isSuccess{
                
                let data = NSDictionary(objects: [self.province!,self.city!,self.district!,addr,zip,contact,mobile,NSNumber(value: resp.infoId as Int64), PropHelper.instance.userId!],
                                        forKeys: ["Province" as NSCopying,"City" as NSCopying,"District" as NSCopying,"Address" as NSCopying,"Zip" as NSCopying,"Contact" as NSCopying,"Mobile" as NSCopying,"ID" as NSCopying,"UID" as NSCopying])
                
                let uaddress = UserAddressModel(data: data)
                if(self.addressAdded != nil){
                    self.addressAdded(uaddress)
                }
                
                self.navBackTapped(nil)
                
            }else{
                self.view.window?.makeToast(resp.msg)
            }
        }
    }
    
    
    @IBAction func btnSelCityTapped(_ sender: AnyObject) {
        
        let screen = UIScreen.main
        
        UIView.animate(withDuration: 0.5, animations: {
            if self.btnSelCity.isSelected{
                self.pickerView.frame = CGRect(x: 0, y: screen.bounds.height, width: screen.bounds.width, height: 255);
            }else{
                self.pickerView.frame = CGRect(x: 0, y: screen.bounds.height-255, width: screen.bounds.width, height: 255);
            }
            self.btnSelCity.isSelected = !self.btnSelCity.isSelected
        }) 
        
    }
    
    func sureBtnClickReturnProvince(_ province: String!,city: String!,area: String!) {
        
        self.province = province
        self.city = city
        self.district = area
        
        let mcity = "\(province) \(city) \(area)"
        self.btnSelCity.setTitle("选择城市", for: .selected)
        self.btnSelCity.setTitle(mcity, for: UIControlState())
        btnSelCityTapped(self.btnSelCity)
    }
    
    func cancelBtnClick() {
        btnSelCityTapped(self.btnSelCity)
    }
}

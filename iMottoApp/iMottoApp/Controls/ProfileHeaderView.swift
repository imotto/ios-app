//
//  ProfileHeaderView.swift
//  iMottoApp
//
//  Created by sunht on 16/7/25.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class ProfileHeaderView: UIView {

    var imgThumb: UIImageView!
    var sexThumb: UIImageView!
    var lblUserName: UILabel!
    var accountDelegate: AccountActionDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = COLOR_NAV_BG
        
        let personIcon = FAKIonIcons.iosPersonIcon(withSize: 56)
        let iconV = UIImageView(image: personIcon?.image(with: CGSize(width: 56, height: 56)).withRenderingMode(.alwaysTemplate))
        iconV.tintColor = COLOR_NAV_TINT
        iconV.frame = CGRect(x: 0, y: 34, width: 61, height: 61);
        iconV.center = CGPoint(x: self.center.x, y: 67+34);
        
        iconV.layer.cornerRadius = iconV.frame.size.width/2
        iconV.clipsToBounds = true
        iconV.layer.borderWidth = 1
        iconV.layer.borderColor = COLOR_NAV_TINT.cgColor
        
        self.addSubview(iconV)
        
        imgThumb = iconV;
        
        let sexV = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        sexV.tintColor = COLOR_NAV_TINT
        sexV.center = CGPoint(x: self.center.x+32, y: 67+34+23)
        sexV.backgroundColor = COLOR_NAV_TINT
        sexV.contentMode = .center
        sexV.layer.cornerRadius = sexV.frame.size.width/2
        sexV.clipsToBounds = true
        
        self.addSubview(sexV)
        self.sexThumb = sexV
        
        //登录-注册
        let btnW = frame.size.width/4;
        
        let registerBtn = UIButton(type: .custom)
        registerBtn.setTitle("注册", for: UIControlState())
        registerBtn.tag = 101
        registerBtn.backgroundColor = UIColor.clear
        registerBtn.frame = CGRect(x: btnW, y: iconV.frame.maxY + 5, width: btnW, height: 40)
        registerBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        self.addSubview(registerBtn)
        
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("登录", for: UIControlState())
        loginBtn.tag = 102
        loginBtn.backgroundColor = UIColor.clear
        loginBtn.frame = CGRect(x: btnW * 2, y: iconV.frame.maxY + 5, width: btnW, height: 40)
        loginBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        self.addSubview(loginBtn)
        
        setBtnState(hidden: true)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: iconV.frame.maxY + 5, width: frame.size.width, height: 20)
        label.text = PropHelper.instance.user
        label.textColor = COLOR_NAV_TINT
        label.textAlignment = .center
        self.addSubview(label)
        
        lblUserName = label;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func refreshState(_ thumb: String?){
        if PropHelper.instance.isLogin{
            setNameLabelState(hidden: false)
            setBtnState(hidden: true)
            
            self.lblUserName.text = PropHelper.instance.user
            
            let personIcon = FAKIonIcons.iosPersonIcon(withSize: 56)
            let placeholder = personIcon?.image(with: CGSize(width: 56, height: 56)).withRenderingMode(.alwaysTemplate)
            
            if thumb == nil || thumb == ""{
                self.imgThumb.image = placeholder
            }else{
                self.imgThumb.image = placeholder
                self.imgThumb.load.request(with: thumb!, onCompletion: { image, error, operation in
                    if operation == .network {
                        let transition = CATransition()
                        transition.duration = 0.5
                        transition.type = kCATransitionFade
                        self.imgThumb.layer.add(transition, forKey: nil)
                        self.imgThumb.image = image
                    }
                })
            }
        }else{
            setNameLabelState(hidden: true)
            setBtnState(hidden: false)
            setSex(0)
            let personIcon = FAKIonIcons.iosPersonIcon(withSize: 56)
            self.imgThumb.image = personIcon?.image(with: CGSize(width: 56, height: 56)).withRenderingMode(.alwaysTemplate)
        }

    }
    
    
    func btnTapped(_ btn:UIButton?){
        if btn?.tag == 101{
            // register
            accountDelegate?.doRegister()
        }else{
            // login
            accountDelegate?.doLogin()
        }
    }
    
    func setBtnState(hidden:Bool){
        let registerBtn = self.viewWithTag(101) as! UIButton
        let loginBtn = self.viewWithTag(102) as! UIButton
        
        loginBtn.isHidden = hidden
        registerBtn.isHidden = hidden
    }
    
    func setNameLabelState(hidden:Bool){
        lblUserName.isHidden = hidden
    }
    
    func setSex(_ sex:Int){
        let imgSize:CGFloat = 12.0
        switch sex {
        case 1:
            self.sexThumb.image = FAKIonIcons.femaleIcon(withSize: imgSize).image(with: CGSize(width: imgSize, height: imgSize)).withRenderingMode(.alwaysTemplate)
            self.sexThumb.tintColor = UIColor.magenta
            self.sexThumb.isHidden = false
            break
        case 2:
            self.sexThumb.image = FAKIonIcons.maleIcon(withSize: imgSize).image(with: CGSize(width: imgSize, height: imgSize)).withRenderingMode(.alwaysTemplate)
            self.sexThumb.tintColor = COLOR_NAV_BG
            self.sexThumb.isHidden = false
            break
        default:
            self.sexThumb.image = nil
            self.sexThumb.isHidden = true
            break
        }
    }
    


}

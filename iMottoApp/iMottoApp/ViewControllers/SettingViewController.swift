//
//  SettingViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/9/28.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class SettingViewController: UITableViewController, UIAlertViewDelegate {
    
    var userInfo: UserModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationItem.title = "设置"
        
        let nib = UINib(nibName: "ProfileDisplayCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyProfileDisplayCell)
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        switch section {
        case 0:
            title = "照片"
            break
        case 1:
            title = "用户名"
            break
        case 2:
            title = "性别"
            break
        default:
            title = "登录密码"
            break;
            
        }
        
        let view = UIView(frame: CGRect(x: 10.0, y: 0.0, width: self.view.width, height: 30.0));
        view.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 5, y: 3, width: 284, height: 24))
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = title
        view.addSubview(label)
        
        return view;

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell
        
        switch (indexPath as NSIndexPath).section {
            case 0:
                let mcell = tableView.dequeueReusableCell(withIdentifier: "UserThumbCell", for: indexPath) as! UserThumbCell
                
                let icon = FAKIonIcons.personIcon(withSize: 85)
                icon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray)
                let placeholder = icon?.image(with: CGSize(width: 85, height: 85))
                
                mcell.imgThumb.layer.cornerRadius = mcell.imgThumb.frame.size.width/2
                mcell.imgThumb.clipsToBounds = true
                mcell.imgThumb.layer.borderWidth = 0.3
                mcell.imgThumb.layer.borderColor = UIColor.gray.cgColor
                
                if userInfo.thumb == ""{
                    mcell.imgThumb.image = placeholder
                }else{
                    let URL = userInfo.thumb
                    mcell.imgThumb.image = placeholder
                    mcell.imgThumb.load.request(with: URL, onCompletion: { image, error, operation in
                        if operation == .network {
                            let transition = CATransition()
                            transition.duration = 0.5
                            transition.type = kCATransitionFade
                            mcell.imgThumb.layer.add(transition, forKey: nil)
                            mcell.imgThumb.image = image
                        }
                    })
                }
                
                cell = mcell
                break
            case 1:
                let mcell = tableView.dequeueReusableCell(withIdentifier: keyProfileDisplayCell, for: indexPath) as! ProfileDisplayCell
                
                mcell.imgThumb.image = FAKIonIcons.iosInformationOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                mcell.lblTitle.text = userInfo.displayName
                mcell.lblInfo.text = "更改"
                cell = mcell;
                break
            case 2:
                let mcell = tableView.dequeueReusableCell(withIdentifier: keyProfileDisplayCell, for: indexPath) as! ProfileDisplayCell
                if userInfo.sex == 1{
                    mcell.imgThumb.image = FAKIonIcons.femaleIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                    mcell.lblTitle.text = "女"
                }else if userInfo.sex == 2{
                    mcell.imgThumb.image = FAKIonIcons.maleIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                    mcell.lblTitle.text = "男"
                }
                else{
                    mcell.imgThumb.image = FAKIonIcons.iosCircleOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                    mcell.lblTitle.text = "保密"
                }
                
                mcell.lblInfo.text = "设置"
                cell = mcell
                break
            default:
                let mcell = tableView.dequeueReusableCell(withIdentifier: keyProfileDisplayCell, for: indexPath) as! ProfileDisplayCell
                
                mcell.imgThumb.image = FAKIonIcons.iosLockedOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                mcell.lblTitle.text = "******"
                mcell.lblInfo.text = "更改"
                cell = mcell;

                break
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
            case 0:
                //修改头像
                let storyboard = UIStoryboard(name: "Account", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PickThumbController") as! PickThumbController
                controller.userInfo = self.userInfo
                
                controller.callback = { 
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
                self.navigationController?.pushViewController(controller, animated: true)
                break
            case 1:
                //修改用户名称
                
                
                let dialog = UIAlertController(title: "修改用户名称", message: "", preferredStyle: .alert)
                var txtUserName: UITextField?
                
                dialog.addTextField(configurationHandler: { (textName) in
                    textName.placeholder = "用户名称"
                    txtUserName = textName
                })
                
                dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                    debugPrint("canceled")
                }))
                dialog.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                    if let name = txtUserName?.text{
                        if name != ""{
                            
                            ToastManager.shared.makeToastActivity(self.view)
                            IMApi.instance.modifyUserName(name, completion: { (resp) in
                                ToastManager.shared.hideToastActivity()
                                if resp.isSuccess{
                                    PropHelper.instance.user = name
                                    self.userInfo!.name = name
                                    self.userInfo!.displayName = name
                                    
                                    let indexPath = IndexPath(row: 0, section: 1)
                                    
                                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                                }else{
                                    self.view.window?.makeToast(resp.msg)
                                }
                            })
                        }
                    }
                }))
                
                self.present(dialog, animated: true, completion: nil)

                
                break
            case 2:
                //设置性别
                let dialog = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                dialog.addAction(UIAlertAction(title: "女", style: .default, handler: { (action) in
                    
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.modifySex(1, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.userInfo!.sex = 1
                            let indexPath = IndexPath(row: 0, section: 2)
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    })
                }))

                dialog.addAction(UIAlertAction(title: "男", style: .default, handler: { (action) in
                    
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.modifySex(2, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.userInfo!.sex = 2
                            let indexPath = IndexPath(row: 0, section: 2)
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    })
                }))
                
                
                dialog.addAction(UIAlertAction(title: "保密", style: .cancel, handler: { (action) in
                    
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.modifySex(0, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.userInfo!.sex = 0
                            let indexPath = IndexPath(row: 0, section: 2)
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    })
                }))
                
                self.present(dialog, animated: true, completion: nil)
                
                break
            default:
                //修改密码
                let dialog = UIAlertController(title: "修改密码", message: "", preferredStyle: .alert)
                var txtOldPass: UITextField?
                var txtNewPass: UITextField?
                
                dialog.addTextField(configurationHandler: { (textPassword) in
                    textPassword.placeholder = "原密码"
                    textPassword.isSecureTextEntry = true
                    txtOldPass = textPassword
                })
                
                dialog.addTextField(configurationHandler: { (textNewPass) in
                    textNewPass.placeholder = "新密码"
                    textNewPass.isSecureTextEntry = true
                    txtNewPass = textNewPass
                })
                
                dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                   debugPrint("canceled")
                }))
                dialog.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                    debugPrint("confirm \(txtOldPass?.text), \(txtNewPass?.text)")
                    if txtOldPass?.text != PropHelper.instance.password{
                        self.view.window?.makeToast("您的原密码输入有误，请重试")
                    }else if txtNewPass?.text == ""{
                        self.view.window?.makeToast("密码不能为空，请重试")
                    }else{
                        ToastManager.shared.makeToastActivity(self.view)
                        IMApi.instance.modifyPassword((txtOldPass?.text)!, newPass: (txtNewPass?.text)!, completion: { (resp) in
                            ToastManager.shared.hideToastActivity()
                            if resp.isSuccess{
                                PropHelper.instance.password = txtNewPass?.text
                                self.view.window?.makeToast("密码修改成功")
                            }else{
                                self.view.window?.makeToast(resp.msg)
                            }
                        })
                    }
                }))
                
                self.present(dialog, animated: true, completion: nil)
                
                break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

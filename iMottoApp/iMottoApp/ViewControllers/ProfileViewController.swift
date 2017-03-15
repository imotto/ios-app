//
//  ProfileViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/7/17.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ProfileViewController: UITableViewController,ParallaxHeaderViewDelegate,AccountActionDelegate {
    var lblTitle: UILabel!
    var userInfo: UserModel?
    var header: ProfileHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem?.image = FAKIonIcons.gearAIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        self.navigationItem.rightBarButtonItem?.tintColor = COLOR_NAV_TINT
        
        lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 28))
        lblTitle.textColor = COLOR_NAV_BG
        lblTitle.text = ""
        lblTitle.textAlignment = NSTextAlignment.center
        
        self.navigationItem.titleView = lblTitle
        
        self.navigationController?.navigationBar.setMyBackgroundColor(COLOR_NAV_BG)
        
        let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 110))
        headerView.contentMode = .scaleAspectFill
        
        let heardView = ParallaxHeaderView(style: .default, subView: headerView, headerViewSize: CGSize(width: self.tableView.bounds.width, height: 110), maxOffsetY: -210, delegate: self)
        
        headerView.accountDelegate = self
        headerView.refreshState(nil)
        self.tableView.tableHeaderView = heardView
        self.header = headerView
        
        self.tableView.separatorColor = UIColor(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 46, 0, 0)
        
        let nib = UINib(nibName: "ProfileDisplayCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyProfileDisplayCell)
        
        setupRefresh()
  
    }
    
    func setupRefresh(){
        let control = UIRefreshControl()
        self.refreshControl = control
        control.addTarget(self, action: #selector(refreshStateChange), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(control)
        
        self.refreshStateChange(control)
    }
    
    func refreshStateChange(_ control:UIRefreshControl){
        control.beginRefreshing()
        
        if PropHelper.instance.isLogin{
            IMApi.instance.readUserInfo(PropHelper.instance.userId!) { (resp) in
                if resp.isSuccess{
                    if resp.Data != nil && resp.Data?.count>0 {
                        self.userInfo = resp.Data![0]
                        
                        PropHelper.instance.user = self.userInfo?.displayName
                        self.header.refreshState(self.userInfo?.thumb)
                        self.header.setSex(self.userInfo!.sex)
                        self.tableView.reloadData()
                    }
                }
                
                control.endRefreshing()
            }
        }
        else{
            control.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if PropHelper.instance.isLogin {
            if section == 4 {
                return 10.0
            } else {
                return CGFloat.leastNormalMagnitude
            }
        } else {
            if section == 3 {
                return 10.0
            } else {
                return CGFloat.leastNormalMagnitude
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if PropHelper.instance.isLogin {
            return 5
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 3;
        case 1:
            return 2;
        case 2:
            return 3;
        case 3:
            return 2;
        case 4:
            return 1;
        default:
            return 0;
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: keyProfileDisplayCell) as! ProfileDisplayCell
        
        cell.imgThumb.tintColor = COLOR_NAV_BG
        cell.lblTitle.textColor = UIColor.black
        /*
         section 0:
             我的积分
             我的金币
             我的礼品
         section 1:
             我的作品
             我的珍藏
         
         section 2:
             -喜欢的作品
             -喜欢的珍藏
             我喜欢的人
             喜欢我的人
             黑名单
         
         section 3:
             邀请好友
             帮助中心
         
         section 4:
             退出登录
         */
        switch (indexPath as NSIndexPath).section {
        case 0:
            if (indexPath as NSIndexPath).row == 0{
                cell.lblTitle.text = "我的积分"
                cell.imgThumb.image = FAKMaterialIcons.chartIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.revenue)
                }
            } else if (indexPath as NSIndexPath).row == 1{
                cell.lblTitle.text = "我的金币"
                cell.imgThumb.image = FAKMaterialIcons.receiptIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.balance)
                }
            } else if indexPath.row == 2 {
                cell.lblTitle.text = "我的礼品"
                cell.imgThumb.image = UIImage(named: "icon_gift")
                cell.lblInfo.text = ""
            }
            break
        case 1:
            if (indexPath as NSIndexPath).row == 0{
                cell.lblTitle.text = "我的偶得"
                cell.imgThumb.image = FAKMaterialDesignIcons.documentIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.mottos)
                }
            }else if (indexPath as NSIndexPath).row == 1{
                cell.lblTitle.text = "我的珍藏"
                cell.imgThumb.image = FAKMaterialDesignIcons.libraryBooksIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.albums)
                }
            }
            break
        case 2:
            if (indexPath as NSIndexPath).row == 0{
                cell.lblTitle.text = "我喜欢的人"
                cell.imgThumb.image = FAKMaterialDesignIcons.accountStarVariantIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.follows)
                }
            }else if (indexPath as NSIndexPath).row == 1{
                cell.lblTitle.text = "喜欢我的人"
                cell.imgThumb.image = FAKMaterialDesignIcons.accountStarIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.followers)
                }
            }else if (indexPath as NSIndexPath).row == 2{
                cell.lblTitle.text = "黑名单"
                cell.imgThumb.image = FAKMaterialDesignIcons.accountAlertIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.bans)
                }
            }
            break
        case 3:
            if (indexPath as NSIndexPath).row == 0{
                cell.lblTitle.text = "邀请好友"
                cell.imgThumb.image = FAKMaterialDesignIcons.shareVariantIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
            }else if (indexPath as NSIndexPath).row == 1{
                cell.lblTitle.text = "关于偶得"
                cell.imgThumb.image = FAKMaterialDesignIcons.helpCircleIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
            }
            break
        case 4:
            cell.lblTitle.text = "退出登录"
            cell.imgThumb.image = FAKMaterialDesignIcons.logoutVariantIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
            
            cell.imgThumb.tintColor = UIColor.red
            cell.lblTitle.textColor = UIColor.red
            cell.lblInfo.text = ""
            break
        default:
            break
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
            case 0:
                if (indexPath as NSIndexPath).row == 0{
                    if PropHelper.instance.isLogin{
                        let controller = ScoreRecordController()
                        
                        self.presentBackableController(controller)
                    }else{
                        self.view.window?.makeToast("请登录后查看")
                    }
                }else if (indexPath as NSIndexPath).row == 1{
                    if PropHelper.instance.isLogin{
                        let controller = BillRecordController()
                        
                        self.presentBackableController(controller)
                    }else{
                        self.view.window?.makeToast("请登录后查看")
                    }

                } else if indexPath.row == 2 {
                    // 我的礼品
                    if PropHelper.instance.isLogin{
                        let controller = MyGiftViewController()
                        self.presentBackableController(controller)
                    }else{
                        self.view.window?.makeToast("请登录后查看")
                    }
                    
                }
                break
            case 1:
                if (indexPath as NSIndexPath).row == 0{
                    if PropHelper.instance.isLogin{
                        let controller = UserMottosController()
                        
                        self.presentBackableController(controller)
                    }else{
                        self.view.window?.makeToast("请登录后查看")
                    }
                }else if (indexPath as NSIndexPath).row == 1{
                    if PropHelper.instance.isLogin{
                        let controller = UserAlbumsController()
                        
                        self.presentBackableController(controller)
                    }else{
                        self.view.window?.makeToast("请登录后查看")
                    }
                }
                
                break
            case 2:
                if (indexPath as NSIndexPath).row == 0{
                    if PropHelper.instance.isLogin{
                        let controller = UserFollowController()
                        
                        self.presentBackableController(controller)
                    }
                    else{
                        self.view.window?.makeToast("请登录后查看")
                    }
                } else if (indexPath as NSIndexPath).row == 1{
                    if PropHelper.instance.isLogin{
                        let controller = UserFollowerController()
                        
                        self.presentBackableController(controller)
                    }
                    else{
                        self.view.window?.makeToast("请登录后查看")
                    }
                } else if (indexPath as NSIndexPath).row == 2{
                    if PropHelper.instance.isLogin{
                        let controller = UserBanController()
                        self.presentBackableController(controller)
                    }
                    else{
                        self.view.window?.makeToast("请登录后查看")
                    }
                }
                break
            case 3:
                if (indexPath as NSIndexPath).row == 0{
                    let textToShare = "这个叫偶得的App有点意思，来一起玩吧！"
                    if let shareUrl = URL(string: "https://www.imotto.net/"){
                        let objectsToShare = [textToShare, shareUrl] as [Any]
                        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                        
                        activityVC.excludedActivityTypes = [UIActivityType.airDrop,
                                                            UIActivityType.print,
                                                            UIActivityType.addToReadingList,
                                                            UIActivityType.openInIBooks,
                                                            UIActivityType.postToVimeo,
                                                            UIActivityType.copyToPasteboard,
                                                            UIActivityType.assignToContact]
                            
                        activityVC.popoverPresentationController?.sourceView = tableView
                        self.present(activityVC, animated: true, completion: nil)
                    }
                }else if (indexPath as NSIndexPath).row == 1{
                    //帮助中心
                    let controller = HelpCenterController()
                    self.presentBackableController(controller)
                }
            case 4:
                
                ToastManager.shared.makeToastActivity(self.view)
                IMApi.instance.userLogout({ (resp) in
                    ToastManager.shared.hideToastActivity()
                    if resp.isSuccess{
                        //清空JPush别名
                        JPUSHService.setAlias("", callbackSelector: nil, object: nil)
                        PropHelper.instance.mobile = ""
                        PropHelper.instance.password = ""
                        PropHelper.instance.usertoken = ""
                        
                        let window = UIApplication.shared.keyWindow!
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "LoadViewController") as! LoadViewController
                        window.rootViewController = controller
                        window.makeToast("可惜不是你，陪我到最后~")
                    } else {
                        self.view.window?.makeToast("如果说你真的要走，请再找个时间来告诉我~")
                    }
                })
                
                break
            default:
                break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! ParallaxHeaderView
        headerView.layoutHeaderViewWhenScroll(scrollView.contentOffset)
    }

    // MARK - AccountActionDelegate
    
    func doRegister() {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegisterViewController")
        
        self.presentBackableController(controller)
    }
    
    func doLogin() {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        
        controller.loginSuccessCallback = {
            self.refreshStateChange(self.refreshControl!)
        }
        
        self.presentBackableController(controller)
    }
    
    @IBAction func btnSettingTapped(_ sender: AnyObject) {
        
        if self.userInfo != nil{
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            controller.userInfo = self.userInfo
            
            self.presentBackableController(controller)
        }
        
    }
    

}

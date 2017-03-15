//
//  UserInfoController.swift
//  iMottoApp
//
//  Created by sunht on 16/10/11.
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


class UserInfoController: UITableViewController, ParallaxHeaderViewDelegate {
    var userId: String!
    var userInfo: UserModel!
    var header: UserInfoHeaderView!
    var loveBttn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        let loveImg = FAKMaterialDesignIcons.heartOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        let loveBtn = UIBarButtonItem(image: loveImg, style: .plain, target: self, action: #selector(loveBtnTapped))
        loveBtn.tintColor = COLOR_NAV_TINT
        self.loveBttn = loveBtn
        self.navigationItem.rightBarButtonItem = loveBtn
        
        self.navigationController?.navigationBar.setMyBackgroundColor(COLOR_NAV_BG)

        let headerView = UserInfoHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 110))
        headerView.contentMode = .scaleAspectFill
        
        let heardView = ParallaxHeaderView(style: .default, subView: headerView, headerViewSize: CGSize(width: self.tableView.bounds.width, height: 110), maxOffsetY: -210, delegate: self)
        
        self.tableView.tableHeaderView = heardView
        self.header = headerView
        
        self.tableView.separatorColor = UIColor(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 46, 0, 0)
        
        let nib = UINib(nibName: "ProfileDisplayCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyProfileDisplayCell)
        
        setupRefresh()
    }
    
    func setupRefresh(){
        if self.refreshControl == nil{
            let control = UIRefreshControl()
            self.refreshControl = control
            control.addTarget(self, action: #selector(refreshStateChange), for: UIControlEvents.valueChanged)
            self.tableView.addSubview(control)
            
            self.refreshStateChange(control)
        }
    }
    
    func refreshStateChange(_ control:UIRefreshControl){
        control.beginRefreshing()
        
        IMApi.instance.readUserInfo(self.userId) { (resp) in
            if resp.isSuccess{
                if resp.Data != nil && resp.Data?.count>0 {
                    self.userInfo = resp.Data![0]
                    
                    self.navigationItem.title = self.userInfo.name
                    self.header.refreshState(self.userInfo!)
                    self.setRelation(self.userInfo!.relation)
                    self.tableView.reloadData()
                }
            }
            
            control.endRefreshing()
        }
    }
    
    func setRelation(_ relation:Int){
        if relation == 3{
            self.loveBttn.image = FAKMaterialDesignIcons.heartPulseIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        }else if relation & 1 == 1{
            self.loveBttn.image = FAKMaterialDesignIcons.heartIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        }else if relation & 4 == 4{
            self.loveBttn.image = FAKMaterialDesignIcons.heartBrokenIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        }else{
            self.loveBttn.image = FAKMaterialDesignIcons.heartOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4{
            return 10.0
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 2
        case 4:
            return 2
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: keyProfileDisplayCell) as! ProfileDisplayCell
        
        cell.imgThumb.tintColor = COLOR_NAV_BG
        cell.lblTitle.textColor = UIColor.black
        /*
         section 0:
         他的积分
         他的排名
         section 1:
         他的作品
         他的珍藏
         section 2:
         他喜欢的作品
         他喜欢的珍藏
         
         section 3:
         他喜欢的人
         喜欢他的人
         
         section 4:
         发送消息给他
         
         */
        switch (indexPath as NSIndexPath).section {
        case 0:
            if (indexPath as NSIndexPath).row == 0{
                cell.lblTitle.text = "发送消息给TA"
                cell.imgThumb.image = FAKIonIcons.shareIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                
                cell.lblInfo.text = ""
                
                if self.userInfo?.relation == 1{
                    cell.lblInfo.text = "你喜欢TA"
                }else if self.userInfo?.relation == 2 {
                    cell.lblInfo.text = "TA喜欢你"
                }else if self.userInfo?.relation == 3{
                    cell.lblInfo.text = "互相喜欢"
                }else if self.userInfo?.relation == 6{
                    cell.lblInfo.text = "尴尬关系"
                }else if self.userInfo?.relation == 0{
                    cell.lblInfo.text = "匆匆过客"
                }
            }
            break
        case 1:
            if (indexPath as NSIndexPath).row == 0{
                cell.lblTitle.text = "TA的积分"
                cell.imgThumb.image = FAKMaterialIcons.chartIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = "\(self.userInfo!.revenue)"
                }
            }
            break
        case 2:
            if (indexPath as NSIndexPath).row == 0{
                cell.lblTitle.text = "TA的偶得"
                cell.imgThumb.image = FAKMaterialDesignIcons.documentIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.mottos)
                }
            }else if (indexPath as NSIndexPath).row == 1{
                cell.lblTitle.text = "TA的珍藏"
                cell.imgThumb.image = FAKMaterialDesignIcons.libraryBooksIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.albums)
                }
            }
         break
        case 3:
            if (indexPath as NSIndexPath).row == 0{
                cell.lblTitle.text = "TA喜欢的偶得"
                cell.imgThumb.image = FAKMaterialDesignIcons.documentIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.lovedMottos)
                }
            }else if (indexPath as NSIndexPath).row == 1{
                cell.lblTitle.text = "TA喜欢的珍藏"
                cell.imgThumb.image = FAKMaterialDesignIcons.libraryBooksIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.lovedAlbums)
                }
            }
            break
        case 4:
           
            if (indexPath as NSIndexPath).row == 0{
                cell.lblTitle.text = "TA喜欢的人"
                cell.imgThumb.image = FAKMaterialDesignIcons.accountStarVariantIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.follows)
                }
            }else if (indexPath as NSIndexPath).row == 1{
                cell.lblTitle.text = "喜欢TA的人"
                cell.imgThumb.image = FAKMaterialDesignIcons.accountStarIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
                cell.lblInfo.text = ""
                if self.userInfo != nil{
                    cell.lblInfo.text = String(self.userInfo!.followers)
                }
            }
            break
       
        default:
            break
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            //跳转至对话页面
            if (indexPath as NSIndexPath).row == 0{
                let storyboard = UIStoryboard(name: "Account", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "TalkController") as! TalkController
                controller.talk2user = SimpleUser(userModel: self.userInfo)
                
                self.presentBackableController(controller)
            }
            break
        case 1:
            if (indexPath as NSIndexPath).row == 0{
                let msg = "\(self.userInfo.displayName)的累计积分为\(self.userInfo.revenue)。"
                self.view.window?.makeToast(msg)
            }
            break
        case 2:
            if (indexPath as NSIndexPath).row == 0{
                let controller = UserMottosController()
                controller.user = SimpleUser(userModel: self.userInfo)
                self.presentBackableController(controller)
            }else if (indexPath as NSIndexPath).row == 1{
                let controller = UserAlbumsController()
                controller.user = SimpleUser(userModel: self.userInfo)
                self.presentBackableController(controller)
            }
            
            break
        case 3:
            if (indexPath as NSIndexPath).row == 0{
                //TA喜欢的作品
                let storyboard = UIStoryboard(name: "Motto", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "LovedMottoController") as! LovedMottoController
                controller.user = self.userInfo
                self.presentBackableController(controller)
            
            }else if (indexPath as NSIndexPath).row == 1{
                //TA喜欢的珍藏
                let storyboard = UIStoryboard(name:"Album", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "LovedAlbumsController") as! LovedAlbumsController
                
                controller.user = self.userInfo
                self.presentBackableController(controller)
            }
            break
        case 4:
            if (indexPath as NSIndexPath).row == 0{
                let controller = UserFollowController()
                controller.user = SimpleUser(userModel: self.userInfo)
                self.presentBackableController(controller)
                
            } else if (indexPath as NSIndexPath).row == 1{
                let controller = UserFollowerController()
                controller.user = SimpleUser(userModel: self.userInfo)
                self.presentBackableController(controller)
            }
        
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.tableView.tableHeaderView != nil){
            let headerView = self.tableView.tableHeaderView as! ParallaxHeaderView
            headerView.layoutHeaderViewWhenScroll(scrollView.contentOffset)
        }
    }
    
    //设置喜欢
    func loveBtnTapped(_ sender: AnyObject){
        
        if self.userInfo == nil{
            return
        }
        var relation:String?
        
        if self.userInfo?.relation == 1{
            relation = "TA是你喜欢的人，你想要将TA："
        }else if self.userInfo?.relation == 2 {
            relation = "TA喜欢你，你想要将TA："
        }else if self.userInfo?.relation == 3{
            relation = "你和TA互相喜欢，你想要将TA："
        }else if self.userInfo?.relation == 4{
            relation = "TA在你的黑名单里，你想要将TA："
        }
        else if self.userInfo?.relation == 6{
            relation = "TA喜欢你，却呆在你的黑名单里，你想要将TA："
        }
        
        if PropHelper.instance.isLogin{
            let dialog = UIAlertController(title: relation, message: nil, preferredStyle: .actionSheet)
            
            if self.userInfo.relation & 1 == 1{
                dialog.addAction(UIAlertAction(title: "移出喜欢的人", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.unfollowUser(self.userInfo.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
                
                dialog.addAction(UIAlertAction(title: "加入黑名单", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.addBanUser(self.userInfo.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                           self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
            }
            else if self.userInfo.relation & 4 == 4{
                dialog.addAction(UIAlertAction(title: "添加为喜欢的人", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.followUser(self.userInfo.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                           self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
                
                dialog.addAction(UIAlertAction(title: "移出黑名单", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.removeBanUser(self.userInfo.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
            }else{
                dialog.addAction(UIAlertAction(title: "添加为喜欢的人", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.followUser(self.userInfo.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
                
                //
                dialog.addAction(UIAlertAction(title: "加入黑名单", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.addBanUser(self.userInfo.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
            }
            
            
            dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            
            self.present(dialog, animated: true, completion: nil)
        }else{
            self.view.window?.makeToast("请先登录后再添加喜欢的人")
        }
    }
    
    
}


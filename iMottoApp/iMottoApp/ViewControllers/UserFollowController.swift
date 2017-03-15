//
//  UserFollowController.swift
//  iMottoApp
//
//  Created by sunht on 16/10/10.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class UserFollowController: UITableViewController {
    var follows = [RelatedUserModel]()
    var user: SimpleUser?
    
    var infiniteScrollingView: UIView!
    var page = 1
    var allDataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        
        if self.user != nil{
            self.navigationItem.title = "\(user!.name)喜欢的人"
        }else{
            self.navigationItem.title = "我喜欢的人"
        }
        
        let nib = UINib(nibName: "RelatedUserDisplayCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyRelateduserDisplayCell)
        
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 117
        self.tableView.separatorColor = UIColor.clear
        
        setupRefresh()
        setInfiniteScrollingView()
    }
    
    // MARK: - Pull to refresh
    
    func setupRefresh(){
        let control = UIRefreshControl()
        self.refreshControl = control
        control.addTarget(self, action: #selector(refreshStateChange), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(control)
        
        self.refreshStateChange(control)
    }
    
    func refreshStateChange(_ control:UIRefreshControl){
        control.beginRefreshing()
        self.page = 1
        self.allDataLoaded = false
        var uid = PropHelper.instance.userId
        if user != nil{
            uid = user?.id
        }
        
        IMApi.instance.readUserFollows(uid!, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.follows = marray
                    self.tableView.reloadData()
                }
            }
            
            control.endRefreshing()
        }
    }
    
    func setInfiniteScrollingView(){
        self.infiniteScrollingView = UIView(frame: CGRect(x: 0,y: self.tableView.contentSize.height, width: self.tableView.bounds.size.width, height: 60))
        self.infiniteScrollingView!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.infiniteScrollingView!.backgroundColor = UIColor.white
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityViewIndicator.color = UIColor.darkGray
        let aframe = activityViewIndicator.frame
        activityViewIndicator.frame = CGRect(x: self.infiniteScrollingView!.frame.width/2 - aframe.width/2, y: self.infiniteScrollingView!.frame.height/2 - aframe.height/2, width: aframe.width, height: aframe.height)
        activityViewIndicator.startAnimating()
        self.infiniteScrollingView!.addSubview(activityViewIndicator)
    }
    
    
    func loadMore(){
        page = page + 1
        self.infiniteScrollingView?.isHidden = false
        var uid = PropHelper.instance.userId
        if user != nil{
            uid = user?.id
        }
        
        IMApi.instance.readUserFollows(uid!, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.follows.append(contentsOf: marray)
                    self.tableView.reloadData()
                }
            }
            
            self.infiniteScrollingView?.isHidden = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.follows.count)
        return self.follows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: keyRelateduserDisplayCell, for: indexPath) as! RelateduserDisplayCell
        
        let follow = self.follows[(indexPath as NSIndexPath).row]
        cell.setModel(follow)
        cell.btnLove.tag = (indexPath as NSIndexPath).row
        cell.btnMotto.tag = (indexPath as NSIndexPath).row
        cell.btnMottos.tag = (indexPath as NSIndexPath).row
        cell.btnFollower.tag = (indexPath as NSIndexPath).row
        cell.btnFollowers.tag = (indexPath as NSIndexPath).row
        cell.btnFollow.tag = (indexPath as NSIndexPath).row
        cell.btnFollows.tag = (indexPath as NSIndexPath).row

        //cell.btnLove.addTarget(self, action: #selector(btnLoveTapped), forControlEvents: .TouchUpInside)
        cell.btnMotto.addTarget(self, action: #selector(btnMottoTapped), for: .touchUpInside)
        cell.btnMottos.addTarget(self, action: #selector(btnMottoTapped), for: .touchUpInside)
        cell.btnFollow.addTarget(self, action: #selector(btnFollowTapped), for: .touchUpInside)
        cell.btnFollows.addTarget(self, action: #selector(btnFollowTapped), for: .touchUpInside)
        cell.btnFollower.addTarget(self, action: #selector(btnFollowerTapped), for: .touchUpInside)
        cell.btnFollowers.addTarget(self, action: #selector(btnFollowerTapped), for: .touchUpInside)
        
        if(!allDataLoaded){
            //加载更多
            if (indexPath as NSIndexPath).row == self.follows.count-1 {
                self.tableView.tableFooterView = self.infiniteScrollingView
                loadMore()
            }
        }else{
            let footerView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.width,height: 60))
            self.tableView.tableFooterView = footerView
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)){
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let user = self.follows[(indexPath as NSIndexPath).row]
        
        if PropHelper.instance.userId != user.id {
            let controller = UserInfoController()
            controller.userId = user.id
            self.presentBackableController(controller)
        }
    }
    
    // MARK: - Cell actions
    
    func btnLoveTapped(_ sender: UIButton){
        let idx = sender.tag
        let user = self.follows[idx]
        var relation:String?
        
        if user.relation == 1{
            relation = "TA是你喜欢的人，你想要将TA："
        }else if user.relation == 2 {
            relation = "TA喜欢你，你想要将TA："
        }else if user.relation == 3{
            relation = "你和TA互相喜欢，你想要将TA："
        }else if user.relation == 6{
            relation = "TA喜欢你，却呆在你的黑名单里，你想要将TA："
        }
        
        if PropHelper.instance.isLogin{
            let dialog = UIAlertController(title: relation, message: nil, preferredStyle: .actionSheet)
            
            if user.relation & 1 == 1{
                dialog.addAction(UIAlertAction(title: "移出喜欢的人", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.unfollowUser(user.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
                
                dialog.addAction(UIAlertAction(title: "加入黑名单", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.addBanUser(user.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
            }
            else if user.relation & 4 == 4{
                dialog.addAction(UIAlertAction(title: "添加为喜欢的人", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.followUser(user.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
                
                dialog.addAction(UIAlertAction(title: "移出黑名单", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.removeBanUser(user.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
            }else{
                dialog.addAction(UIAlertAction(title: "添加为喜欢的人", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.followUser(user.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.refreshStateChange(self.refreshControl!)
                        }
                    })
                }))
                
                //
                dialog.addAction(UIAlertAction(title: "加入黑名单", style: .default, handler: { (action) in
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.addBanUser(user.id, completion: { (resp) in
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
    
    func btnMottoTapped(_ sender: UIButton?){
        if let idx = sender?.tag{
            let controller = UserMottosController()
            let ruser = self.follows[idx]
            controller.user = SimpleUser(relatedUser: ruser)
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    func btnFollowTapped(_ sender: UIButton?){
        if let idx = sender?.tag{
            let controller = UserFollowController()
            let ruser = self.follows[idx]
            controller.user = SimpleUser(relatedUser: ruser)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func btnFollowerTapped(_ sender: UIButton?){
        if let idx = sender?.tag{
            let controller = UserFollowerController()
            let ruser = self.follows[idx]
            controller.user = SimpleUser(relatedUser: ruser)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//
//  UserAlbumsController.swift
//  iMottoApp
//
//  Created by sunht on 16/10/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class UserAlbumsController: UITableViewController {

    var infiniteScrollingView: UIView!
    var albums = [AlbumModel]()
    var page = 1
    var allDataLoaded = false
    var user:SimpleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        
        if self.user != nil{
            self.navigationItem.title = "\(user!.name)的珍藏"
        }else{
            self.navigationItem.title = "我的珍藏"
        }
        
        let nib = UINib(nibName: "DisplayAlbumCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyAlbumDisplayCell)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 146.0
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
        
        IMApi.instance.readUserAlbum(uid!, mid:0, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.albums = marray
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
        
        IMApi.instance.readUserAlbum(uid!, mid:0, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.albums.append(contentsOf: marray)
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
        self.tableView.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.albums.count)
        return self.albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: keyAlbumDisplayCell, for: indexPath) as! DisplayAlbumCell
        
        let album = self.albums[(indexPath as NSIndexPath).row]
        cell.setModel(album)
        
        if(!allDataLoaded){
            //加载更多
            if (indexPath as NSIndexPath).row == self.albums.count-1 {
                self.tableView.tableFooterView = self.infiniteScrollingView
                loadMore()
            }
        }else{
            let footerView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.width,height: 60))
            self.tableView.tableFooterView = footerView
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album:AlbumModel = self.albums[(indexPath as NSIndexPath).row]
        
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AlbumDetailController") as! AlbumDetailController
        
        controller.album = album
        self.presentBackableController(controller)
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

}

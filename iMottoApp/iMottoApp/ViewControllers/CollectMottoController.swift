//
//  CollectMottoController.swift
//  iMottoApp
//
//  Created by sunht on 16/9/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class CollectMottoController: UITableViewController, UIAlertViewDelegate {
    var mottoToCollect : MottoModel?
    var albums = [AlbumModel]()
    var page = 1
    var allDataLoaded = false
    var createAlbumView : UIView?
    var infiniteScrollingView : UIView?
    var _window : UIWindow?
    var mid:Int64 = 0

    var addToCollectionCallback:((_ collected:Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView?.tintColor = COLOR_NAV_TINT
        self.navigationItem.title = "加入珍藏"
        
        let btnBack = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        btnBack.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = btnBack
        
        let imgAdd = FAKIonIcons.plusIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        let btnAdd = UIBarButtonItem(image:imgAdd, style: .plain, target: self, action: #selector(btnOKTapped))
        btnAdd.tintColor = COLOR_NAV_TINT
        self.navigationItem.rightBarButtonItem = btnAdd
        
        setupRefresh()
        setInfiniteScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.addToCollectionCallback != nil) {
            for album in albums {
                if album.containsMID > 0 {
                    self.addToCollectionCallback!(true)
                    return
                }
            }
            self.addToCollectionCallback!(false)
        }
    }
    
    
    func setInfiniteScroll(){
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

    func showCreateButton(){
        let button = UIButton(type: .system)
        button.setImage(FAKIonIcons.iosPlusEmptyIcon(withSize: 48).image(with: CGSize(width: 48, height: 48)), for: UIControlState())
        button.tintColor = COLOR_NAV_TINT
        
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        button.addTarget(self, action: #selector(createAlbum), for: .touchUpInside)
        let size = self.view.size
        self._window = UIWindow(frame: CGRect(x: size.width - 66, y: size.height - 66, width: 48, height: 48))
        
        self._window?.windowLevel = UIWindowLevelAlert + 1
        self._window?.backgroundColor = COLOR_NAV_BG
        self._window?.layer.cornerRadius = 24
        self._window?.layer.masksToBounds = true
        self._window?.addSubview(button)
        self._window?.makeKeyAndVisible()
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
        self.page = 1
        allDataLoaded = false
        
        IMApi.instance.readUserAlbum(PropHelper.instance.userId!, mid: self.mid, pindex: self.page, psize: DEFAULT_PAGE_SIZE){ (resp) in
            self.albums = [AlbumModel]()
            if(resp.isSuccess){
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.albums = marray
                }
            }
            
            self.tableView.reloadData()
            control.endRefreshing()
        }
    }
    
    
    func loadMore(){
        page = page + 1
        
        self.infiniteScrollingView?.isHidden = false
        IMApi.instance.readUserAlbum(PropHelper.instance.userId!, mid: self.mid, pindex: self.page, psize: DEFAULT_PAGE_SIZE) { (resp) in
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
    
    func createAlbum(_ sender:UIButton?){
        
        if let createAlbumController = self.storyboard?.instantiateViewController(withIdentifier: "createAlbumController") as? CreateAlbumController{
            
            createAlbumController.successCallback = {
                [unowned self] in
                self.refreshStateChange(self.refreshControl!)
            }
            
            self.navigationController?.pushViewController(createAlbumController, animated: true)
            
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumSelectionCell", for: indexPath) as! AlbumSelectionCell
        
        let album = self.albums[(indexPath as NSIndexPath).row]
        
        cell.lblTitle.text = album.title
        cell.lblSummary.text = album.summary
        cell.lblInfo.text = "已收录\(album.mottos)则作品 • \(album.loves)人喜欢"
        
        cell.btnDel.tag = (indexPath as NSIndexPath).row
        cell.btnDel.addTarget(self, action: #selector(delAlbum), for: .touchUpInside)
        cell.btnDel.isHidden = true
        
        cell.btnSelect.tag = (indexPath as NSIndexPath).row
        cell.btnSelect.addTarget(self, action: #selector(selAlbum), for: .touchUpInside)
        cell.setCheckState(album.containsMID > 0)
                
        if(!allDataLoaded){
            //加载更多
            if (indexPath as NSIndexPath).row == self.albums.count-1 {
                self.tableView.tableFooterView = self.infiniteScrollingView
                loadMore()
            }
        }else{
            //let footerView = UIView(frame: CGRectMake(0,0,self.view.width,60))
            //self.tableView.tableFooterView = footerView
        }

        
        return cell
    }
    
    func selAlbum(_ sender:UIButton?){
        if mid > 0{
            if let tag = sender?.tag{
                let album = self.albums[tag]
                ToastManager.shared.makeToastActivity(self.view)
                if album.containsMID > 0{
                    IMApi.instance.removeMottoFromCollection(mid, cid: album.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            album.mottos = album.mottos - 1
                            album.containsMID = 0
                            self.refreshCellAtRowIndex(tag)
                        }
                    })
   
                }else{
                    IMApi.instance.addMottoToCollection(mid, cid: album.id, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            album.mottos = album.mottos + 1
                            album.containsMID = self.mid
                            self.refreshCellAtRowIndex(tag)
                        }
                    })
                }

                
            }
        }else{
            self.view.window?.makeToast("出了点问题，请返回重试")
        }

    }
    
    func refreshCellAtRowIndex(_ index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func delAlbum(_ sender:UIButton?){
        let controller = UIAlertController(title: "删除珍藏？", message: "删除后将不可恢复", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        controller.addAction(UIAlertAction(title: "删除", style: .default, handler: { (action) in
            debugPrint("begin delete album")
        }))
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let cell = tableView.cellForRow(at: indexPath) as? AlbumSelectionCell{
            self.selAlbum(cell.btnSelect)
        }
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

    func btnOKTapped(_ sender: AnyObject) {
       self.createAlbum(nil)
    }
    
    func resignWindow(){
        self._window?.resignKey()
        self._window = nil
    }


}

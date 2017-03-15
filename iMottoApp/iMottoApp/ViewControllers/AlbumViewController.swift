//
//  AlbumViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var segAlubmType : UISegmentedControl?
    var spotAlbums = [AlbumModel]()
    var lovedAlbums = [AlbumModel]()
    var infiniteScrollingView:UIView?
    var infiniteScrollingView2:UIView?
    var refreshControl:UIRefreshControl?
    var refreshControl2:UIRefreshControl?
    var page = 1
    var page2 = 1
    var lovedTableInited = false
 
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var exploreTableView: UITableView!
    @IBOutlet weak var lovedTableView: UITableView!
    
    var offset : CGFloat = 0.0{
        didSet{
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollContainer.contentOffset = CGPoint(x:self.offset, y :0.0)
            }) 
            self.lazyInitLovedTableData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.navigationItem.rightBarButtonItem?.tintColor = COLOR_NAV_TINT
//        self.navigationItem.rightBarButtonItem?.image = FAKIonIcons.iosSearchIconWithSize(30).imageWithSize(CGSizeMake(30, 30))
        self.navigationItem.rightBarButtonItem = nil
        
        segAlubmType = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 24))
        segAlubmType?.insertSegment(withTitle: "发现", at: 0, animated: true)
        segAlubmType?.insertSegment(withTitle: "喜欢", at: 1, animated: true)
        
        segAlubmType?.isMomentary = false
        segAlubmType?.isMultipleTouchEnabled = false
        segAlubmType?.selectedSegmentIndex = 0
        segAlubmType?.tintColor = COLOR_NAV_TINT
        segAlubmType?.addTarget(self, action: #selector(segAlumbTypeChange(_:)), for: UIControlEvents.valueChanged)
            
        self.navigationItem.titleView = segAlubmType
    }
    
    func segAlumbTypeChange(_ seg:UISegmentedControl){
        let idx = seg.selectedSegmentIndex
        self.offset = CGFloat(idx) * self.view.frame.width
    }
    
    func lazyInitLovedTableData(){
        if !self.lovedTableInited {
            self.lovedTableInited = true
            self.lovedTableView.es_startPullToRefresh()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.exploreTableView.dataSource = self
        self.exploreTableView.delegate = self
        self.lovedTableView.dataSource = self
        self.lovedTableView.delegate = self
        
        let nib = UINib(nibName: "DisplayAlbumCell", bundle: nil)
        self.lovedTableView.register(nib, forCellReuseIdentifier: keyAlbumDisplayCell)
        self.exploreTableView.register(nib, forCellReuseIdentifier: keyAlbumDisplayCell)
        
        self.exploreTableView.rowHeight = UITableViewAutomaticDimension
        self.exploreTableView.estimatedRowHeight = 140
        self.exploreTableView.separatorColor = UIColor.clear
        self.lovedTableView.rowHeight = UITableViewAutomaticDimension
        self.lovedTableView.estimatedRowHeight = 140
        self.lovedTableView.separatorColor = UIColor.clear
        
        let swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(swipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        swipeLeft.numberOfTouchesRequired = 1
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeRight.numberOfTouchesRequired = 1
        
        scrollContainer.addGestureRecognizer(swipeLeft)
        scrollContainer.addGestureRecognizer(swipeRight)
        
        let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        let _ = self.exploreTableView.es_addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        let _ = self.exploreTableView.es_addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        
        let header2 = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let footer2 = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        let _ = self.lovedTableView.es_addPullToRefresh(animator: header2) { [weak self] in
            self?.refresh()
        }
        let _ = self.lovedTableView.es_addInfiniteScrolling(animator: footer2) { [weak self] in
            self?.loadMore()
        }
        
        self.exploreTableView.es_startPullToRefresh()
        
        //setupRefresh()
        //setInfiniteScrollingView()
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(refresh),
                                               name: NotificationNameUpdateCollection,
                                               object: nil)
    }
    
    func refresh() {
        if self.segAlubmType!.selectedSegmentIndex == 0 {
            // 发现
            self.page = 1
            self.spotAlbums.removeAll()
            
            IMApi.instance.readAlbum(page, psize: DEFAULT_PAGE_SIZE, completion: { (resp) in
                if resp.isSuccess{
                    let marray = resp.Data!
                    self.spotAlbums.append(contentsOf: marray)
                    self.exploreTableView.reloadData()
                    self.exploreTableView.es_stopPullToRefresh(completion: true)
                    
                    if marray.count < DEFAULT_PAGE_SIZE {
                        self.exploreTableView.es_noticeNoMoreData()
                    }
                } else {
                    self.exploreTableView.es_stopPullToRefresh(completion: true)
                }
            })
            
        } else {
            // 喜欢
            self.page2 = 1
            self.lovedAlbums.removeAll()
            
            if PropHelper.instance.isLogin {
                IMApi.instance.readLovedAlbums(PropHelper.instance.userId!, pindex: page2, psize: DEFAULT_PAGE_SIZE, completion: { (resp) in
                    if resp.isSuccess {
                        let marray = resp.Data!
                        self.lovedAlbums.append(contentsOf: marray)
                        self.lovedTableView.reloadData()
                        self.lovedTableView.es_stopPullToRefresh(completion: true)
                        
                        if marray.count < DEFAULT_PAGE_SIZE {
                            self.lovedTableView.es_noticeNoMoreData()
                        }
                    } else {
                        self.lovedTableView.es_stopPullToRefresh(completion: true)
                    }
                })
            } else {
                self.lovedTableView.es_stopPullToRefresh(completion: true)
                self.view.window?.makeToast("登录之后才会显示您喜欢的珍藏")
                self.lovedTableView.reloadData()
            }
        }
    }
    
    func loadMore() {
        if self.segAlubmType!.selectedSegmentIndex == 0 {
            // 发现
            self.page += 1
            
            IMApi.instance.readAlbum(page, psize: DEFAULT_PAGE_SIZE, completion: { (resp) in
                if resp.isSuccess{
                    let marray = resp.Data!
                    self.spotAlbums.append(contentsOf: marray)
                    self.exploreTableView.reloadData()
                    
                    if marray.count < DEFAULT_PAGE_SIZE {
                        self.exploreTableView.es_noticeNoMoreData()
                    } else {
                        self.exploreTableView.es_stopLoadingMore()
                    }
                } else {
                    self.exploreTableView.es_stopLoadingMore()
                }
            })
        } else {
            // 喜欢
            self.page2 += 1
            
            IMApi.instance.readLovedAlbums(PropHelper.instance.userId!, pindex: page2, psize: DEFAULT_PAGE_SIZE, completion: { (resp) in
                if resp.isSuccess {
                    let marray = resp.Data!
                    self.lovedAlbums.append(contentsOf: marray)
                    self.lovedTableView.reloadData()
                    
                    if marray.count < DEFAULT_PAGE_SIZE {
                        self.lovedTableView.es_noticeNoMoreData()
                    } else {
                        self.lovedTableView.es_stopLoadingMore()
                    }
                } else {
                    self.lovedTableView.es_stopLoadingMore()
                }
            })
        }
    }
    
    func swipe(_ gesture:UISwipeGestureRecognizer){
        if gesture.direction == .left{
            offset = self.view.frame.width
            self.segAlubmType!.selectedSegmentIndex = 1
        }else{
            offset = 0.0
            self.segAlubmType!.selectedSegmentIndex = 0
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 101{
            self.exploreTableView.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.spotAlbums.count)
            return self.spotAlbums.count
        }else{
            self.lovedTableView.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.lovedAlbums.count)
            return self.lovedAlbums.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if tableView.tag == 101{
            //explore
            let cell = tableView.dequeueReusableCell(withIdentifier: keyAlbumDisplayCell, for: indexPath) as! DisplayAlbumCell
            
            let album = self.spotAlbums[(indexPath as NSIndexPath).row]
            cell.setModel(album)
            
            return cell
        } else{
            //loved
            let cell = tableView.dequeueReusableCell(withIdentifier: keyAlbumDisplayCell , for: indexPath) as! DisplayAlbumCell
            
            let album = self.lovedAlbums[(indexPath as NSIndexPath).row]
            cell.setModel(album)
            
            return cell
        }
    }
    
    func showSpotUser(_ sender:UITapGestureRecognizer){
        if let idx = sender.view?.tag{
            let album = self.spotAlbums[idx]
            let controller = UserInfoController()
            controller.userId = album.uid
            self.presentBackableController(controller)
            //self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showLovedUser(_ sender:UITapGestureRecognizer){
        if let idx = sender.view?.tag{
            let album = self.lovedAlbums[idx]
            let controller = UserInfoController()
            controller.userId = album.uid
            self.presentBackableController(controller)
            //self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var album:AlbumModel
        if tableView.tag == 101{
            album = self.spotAlbums[(indexPath as NSIndexPath).row]
        }else{
            album = self.lovedAlbums[(indexPath as NSIndexPath).row]
        }
        
        let storyboard = UIStoryboard(name: "Album", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AlbumDetailController") as! AlbumDetailController
        
        controller.album = album
        self.presentBackableController(controller)
    }
    
    
    // MARK - 以下内容用于记住scorllContainer位置
    var lastContentOffset:CGPoint=CGPoint.zero
    override func viewWillDisappear(_ animated: Bool) {
        self.lastContentOffset = self.scrollContainer.contentOffset
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scrollContainer.contentOffset = CGPoint.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollContainer.contentOffset = self.lastContentOffset
    }
}

//
//  MessageViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var segMessageType: UISegmentedControl?
    var messages = [RecentTalkModel]()
    var notices = [NoticeModel]()
    var page1 = 1
    var page2 = 1
    var noticeTableInited = false
    
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var tableMessage: UITableView!
    @IBOutlet weak var tableNotice: UITableView!
    
    var offset : CGFloat = 0.0{
        didSet{
            UIView.animate(withDuration: 0.3, animations: { 
                self.scrollContainer.contentOffset = CGPoint(x: self.offset, y: 0.0)
            }) 
            self.lazyInitNoticeTableData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let btn = UIBarButtonItem(image: nil, style: .Plain, target: self, action: #selector(btnTapped))
//        self.navigationItem.rightBarButtonItem = btn
//        self.navigationItem.rightBarButtonItem?.tintColor = COLOR_NAV_TINT
//        self.navigationItem.rightBarButtonItem?.image = FAKIonIcons.iosPeopleOutlineIconWithSize(30).imageWithSize(CGSizeMake(30, 30))
        self.navigationItem.rightBarButtonItem = nil
        
        
        segMessageType = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 24))
        segMessageType?.insertSegment(withTitle: "私信", at: 0, animated: true)
        segMessageType?.insertSegment(withTitle: "提醒", at: 1, animated: true)
        
        segMessageType?.isMomentary = false
        segMessageType?.isMultipleTouchEnabled = false
        segMessageType?.selectedSegmentIndex = 0
        segMessageType?.tintColor = COLOR_NAV_TINT
        segMessageType?.addTarget(self, action: #selector(segMessageTypeChange(_:)), for: UIControlEvents.valueChanged)
        
        self.navigationItem.titleView = segMessageType
    }
    
    func btnTapped(_ sender:AnyObject?){
        let aview = self.view.createToastActivityView()
        PopupContainer.generatePopupWithView(aview).show()
        
        let delayInSeconds:Int64 = 3
        let popTime = DispatchTime.now() + Double(delayInSeconds * (Int64)(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) { 
            let container = aview.superview as! PopupContainer
            container.close()
        }
    }
    
    
    func lazyInitNoticeTableData(){
        if !self.noticeTableInited {
            self.noticeTableInited = true
            self.tableNotice.es_startPullToRefresh()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableMessage.dataSource = self
        self.tableMessage.delegate = self
        self.tableNotice.dataSource = self
        self.tableNotice.delegate = self
        
        let swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(swipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        swipeLeft.numberOfTouchesRequired = 1
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeRight.numberOfTouchesRequired = 1
        
        scrollContainer.addGestureRecognizer(swipeLeft)
        scrollContainer.addGestureRecognizer(swipeRight)
        
        
        let nib = UINib(nibName: "RecentTalkCell", bundle: nil)
        self.tableMessage.register(nib, forCellReuseIdentifier: keyRecentTalkCell)
        let nib2 = UINib(nibName: "NoticeCell", bundle: nil)
        self.tableNotice.register(nib2, forCellReuseIdentifier: keyNoticeCell)
        
        self.tableNotice.separatorColor = UIColor.clear
        self.tableNotice.rowHeight = UITableViewAutomaticDimension
        self.tableNotice.estimatedRowHeight = 140
        self.tableMessage.separatorColor = UIColor.clear
        self.tableMessage.rowHeight = UITableViewAutomaticDimension
        self.tableMessage.estimatedRowHeight = 78
        
        let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        let _ = self.tableMessage.es_addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        let _ = self.tableMessage.es_addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        
        let header2 = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let footer2 = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        let _ = self.tableNotice.es_addPullToRefresh(animator: header2) { [weak self] in
            self?.refresh()
        }
        let _ = self.tableNotice.es_addInfiniteScrolling(animator: footer2) { [weak self] in
            self?.loadMore()
        }
    }
    
    // MARK: - Pull to refresh
    func refresh() {
        if self.segMessageType!.selectedSegmentIndex == 0 {
            // 私信
            self.page1 = 1
            self.messages.removeAll()
            
            if PropHelper.instance.isLogin {
                IMApi.instance.readRecentTalk(page1, psize: DEFAULT_PAGE_SIZE, completion: {(resp) in
                    if resp.isSuccess{
                        let marray = resp.Data!
                        self.messages.append(contentsOf: marray)
                        self.tableMessage.reloadData()
                        self.tableMessage.es_stopPullToRefresh(completion: true)
                        
                        if marray.count < DEFAULT_PAGE_SIZE {
                            self.tableMessage.es_noticeNoMoreData()
                        }
                    } else {
                        self.tableMessage.es_stopPullToRefresh(completion: true)
                    }
                })
            } else {
                self.tableMessage.es_stopPullToRefresh(completion: true)
                self.view.window?.makeToast("登录之后才会显示收到的私信")
                self.tableMessage.reloadData()
            }
        } else {
            // 提醒
            self.page2 = 1
            self.notices.removeAll()
            
            if PropHelper.instance.isLogin {
                IMApi.instance.readNotices(page2, psize: DEFAULT_PAGE_SIZE, completion: { (resp) in
                    if resp.isSuccess {
                        let marray = resp.Data!
                        self.notices.append(contentsOf: marray)
                        self.tableNotice.reloadData()
                        self.tableNotice.es_stopPullToRefresh(completion: true)
                        
                        if marray.count < DEFAULT_PAGE_SIZE {
                            self.tableNotice.es_noticeNoMoreData()
                        }
                    } else {
                        self.tableNotice.es_stopPullToRefresh(completion: true)
                    }
                })
            } else {
                self.tableNotice.es_stopPullToRefresh(completion: true)
                self.view.window?.makeToast("登录之后才会显示收到的提醒")
                self.tableNotice.reloadData()
            }
        }
    }
    
    func loadMore() {
        if self.segMessageType!.selectedSegmentIndex == 0 {
            // 私信
            self.page1 += 1
            
            IMApi.instance.readRecentTalk(page1, psize: DEFAULT_PAGE_SIZE, completion: {(resp) in
                if resp.isSuccess{
                    let marray = resp.Data!
                    self.messages.append(contentsOf: marray)
                    self.tableMessage.reloadData()
                    
                    if marray.count < DEFAULT_PAGE_SIZE {
                        self.tableMessage.es_noticeNoMoreData()
                    } else {
                        self.tableMessage.es_stopLoadingMore()
                    }
                } else {
                    self.tableMessage.es_stopLoadingMore()
                }
            })
        } else {
            // 提醒
            self.page2 += 1
            
            IMApi.instance.readNotices(page2, psize: DEFAULT_PAGE_SIZE, completion: { (resp) in
                if resp.isSuccess {
                    let marray = resp.Data!
                    self.notices.append(contentsOf: marray)
                    self.tableNotice.reloadData()
                    
                    if marray.count < DEFAULT_PAGE_SIZE {
                        self.tableNotice.es_noticeNoMoreData()
                    } else {
                        self.tableNotice.es_stopLoadingMore()
                    }
                } else {
                    self.tableNotice.es_stopLoadingMore()
                }
            })
        }
    }
    
    func swipe(_ gesture: UISwipeGestureRecognizer){
        if gesture.direction == .left{
            offset = self.view.frame.width
            self.segMessageType!.selectedSegmentIndex = 1
        }else{
            offset = 0.0
            self.segMessageType!.selectedSegmentIndex = 0
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 101:
            self.tableMessage.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.messages.count)
            return self.messages.count
        default:
            self.tableNotice.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.notices.count)
            return self.notices.count
        }
        
    }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 101{
            let cell = tableView.dequeueReusableCell(withIdentifier: keyRecentTalkCell, for: indexPath) as! RecentTalkCell
            let talk = self.messages[(indexPath as NSIndexPath).row]
            cell.setModel(talk)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(showUser))
            cell.imgThumb.tag = indexPath.row
            cell.imgThumb.addGestureRecognizer(tap)

            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: keyNoticeCell, for: indexPath) as! NoticeCell
            let notice = self.notices[(indexPath as NSIndexPath).row]
            cell.setModel(notice)
            
            return cell
        }
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.tag == 101{
            let talk = self.messages[(indexPath as NSIndexPath).row]
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TalkController") as! TalkController
            controller.talk2user = SimpleUser(id: talk.withUid, name: talk.userName, thumb: talk.userThumb)
            
            self.presentBackableController(controller)
        }else{
            let notice = self.notices[(indexPath as NSIndexPath).row]
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NoticeController") as! NoticeController
            controller.notice = notice
            
            controller.stateChangedCallBack = {
                notice.state = 1
                self.tableNotice.reloadRows(at: [indexPath], with: .automatic)
            }
            self.presentBackableController(controller)
            
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
    
    
    func segMessageTypeChange(_ seg:UISegmentedControl){
        let idx = seg.selectedSegmentIndex
        self.offset = CGFloat(idx) * self.view.frame.width
    }

    func showUser(_ sender:UITapGestureRecognizer){
        if let idx = sender.view?.tag{
            let talk = self.messages[idx]
            let controller = UserInfoController()
            controller.userId = talk.withUid
            
            self.presentBackableController(controller)
        }
    }

    // MARK: - 以下内容用于记住scorllContainer位置
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
        
        if PropHelper.instance.isLogin && self.segMessageType!.selectedSegmentIndex == 0 {
            self.tableMessage.es_startPullToRefresh()
        }
    }

}

//
//  UserMottosController.swift
//  iMottoApp
//
//  Created by sunht on 16/10/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class UserMottosController: UITableViewController {
    
    var infiniteScrollingView: UIView!
    var mottos = [MottoModel]()
    var page = 1
    var allDataLoaded = false
    var user:SimpleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        if self.user != nil{
            self.navigationItem.title = "\(user!.name)的偶得"
        }else{
            self.navigationItem.title = "我的偶得"
        }
        
        let nib = UINib(nibName: "DisplayMottoCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyMyMottoDisplayCell)
        
        self.tableView.allowsSelection = false
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
        if user != nil {
            uid = user?.id
        }
        
        IMApi.instance.readUserMottos(uid!, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.mottos = marray
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
        
        IMApi.instance.readUserMottos(uid!, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.mottos.append(contentsOf: marray)
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
        self.tableView.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.mottos.count)
        return self.mottos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: keyMyMottoDisplayCell, for: indexPath) as! DisplayMottoCell
        
        let motto = self.mottos[(indexPath as NSIndexPath).row]
        cell.setModel(motto, indexPath: indexPath)
        cell.buttonCollect.tag = indexPath.row
        cell.buttonCollect.addTarget(self, action: #selector(loveMotto), for: .touchUpInside)
        cell.buttonComment.tag = indexPath.row
        cell.buttonComment.addTarget(self, action: #selector(showReview), for: .touchUpInside)
        cell.buttonMark.tag = indexPath.row
        cell.buttonMark.addTarget(self, action: #selector(markMotto), for: .touchUpInside)
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        cell.buttonScore.tag = indexPath.row
        cell.buttonScore.addTarget(self, action: #selector(buttonScoreClicked), for: .touchUpInside)
        
        if motto.loved == .loved {
            cell.buttonCollect.setImage(UIImage(named: "btn_collection_select"), for: .normal)
        } else {
            cell.buttonCollect.setImage(UIImage(named: "btn_collection"), for: .normal)
        }
        
        if motto.collect == .collected {
            cell.buttonMark.setImage(UIImage(named: "btn_mark_select"), for: .normal)
        } else {
            cell.buttonMark.setImage(UIImage(named: "btn_mark"), for: .normal)
        }
        
        if motto.reviewed == 1 {
            cell.buttonComment.setImage(UIImage(named: "btn_comment_select"), for: .normal)
        } else {
            cell.buttonComment.setImage(UIImage(named: "btn_comment"), for: .normal)
        }
        
        if(!allDataLoaded){
            //加载更多
            if (indexPath as NSIndexPath).row == self.mottos.count-1 {
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
    
    // MARK: - mottocell actions
    
    func buttonScoreClicked(_ sender:UIButton) {
        let index = sender.tag
        let motto = self.mottos[index]
        
        let controller = VoteListViewController()
        controller.mid = motto.id
        controller.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func support(_ rowIndex: Int) {
        let motto = self.mottos[rowIndex]
        
        if PropHelper.instance.isLogin{
            
            if motto.vote != VoteState.noVote{
                self.view.window?.makeToast("您已投过票")
                return
            }
            
            IMApi.instance.addVote(motto.id, theDay: extractTheDay(motto.addTime) , support: true, completion: { (resp) in
                if resp.isSuccess{
                    motto.up = motto.up + 1
                    motto.vote = VoteState.supported
                    self.refreshCellAtRowIndex(rowIndex)
                }else{
                    debugPrint("support Motto failure: \(resp.msg)")
                }
            })
        }else{
            self.gotoLoginController(usePush: true)
        }
        
        
    }
    
    func oppose(_ rowIndex: Int) {
        let motto = self.mottos[rowIndex]
        
        if PropHelper.instance.isLogin{
            
            if motto.vote != VoteState.noVote{
                self.view.window?.makeToast("您已投过票")
                return
            }
            
            IMApi.instance.addVote(motto.id, theDay: extractTheDay(motto.addTime), support: false, completion: { (resp) in
                if resp.isSuccess{
                    motto.down = motto.down + 1
                    motto.vote = VoteState.opposed
                    self.refreshCellAtRowIndex(rowIndex)
                }else{
                    debugPrint("Oppose Motto failure: \(resp.msg)")
                }
            })
        }else{
            self.gotoLoginController(usePush: true)
        }
        
    }
    
    ///喜欢
    func loveMotto(_ sender:UIButton){
        let index = sender.tag
        let motto = self.mottos[index]
        
        if PropHelper.instance.isLogin{
            switch motto.loved {
            case .nofeeling:
                IMApi.instance.loveMotto(motto.id, theDay: extractTheDay(motto.addTime)) { (resp) in
                    if resp.isSuccess{
                        motto.loved = LovedState.loved
                        motto.loves = motto.loves + 1
                        self.refreshCellAtRowIndex(index)
                    }else{
                        self.view.window?.makeToast("添加至喜欢列表失败，请重试")
                    }
                }
                break
            case .loved:
                IMApi.instance.loveMotto(motto.id, theDay: extractTheDay(motto.addTime)) { (resp) in
                    if resp.isSuccess{
                        self.view.window?.makeToast("添加至喜欢列表成功")
                        motto.loved = LovedState.nofeeling
                        motto.loves = motto.loves - 1
                        self.refreshCellAtRowIndex(index)
                    }else{
                        self.view.window?.makeToast("添加至喜欢列表失败，请重试")
                    }
                }
                break
            }
        }
        else{
            self.gotoLoginController(usePush: true)
        }
    }
    
    ///加入珍藏
    func markMotto(_ sender:UIButton){
        let index = sender.tag
        let motto = self.mottos[index]
        
        if PropHelper.instance.isLogin{
            let albumStoryboard = UIStoryboard(name: "Album", bundle: nil);
            
            let controller = albumStoryboard.instantiateViewController(withIdentifier: "CollectMottoController") as! CollectMottoController
            
            controller.mid = motto.id
            controller.addToCollectionCallback = {(collect:Bool) -> Void in
                if collect {
                    motto.collect = .collected
                    self.refreshCellAtRowIndex(index)
                } else {
                    motto.collect = .notYet
                    self.refreshCellAtRowIndex(index)
                }
            }
            
            self.presentBackableController(controller)
            
        }
        else{
            self.gotoLoginController(usePush: true)
        }
    }
    
    ///显示评论列表
    func showReview(_ sender:UIButton){
        let index = sender.tag
        let motto = self.mottos[index]
        
        let storyboard = UIStoryboard(name: "Motto", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ReviewController") as! ReviewViewController
        controller.motto = motto
        controller.addReviewCallback = {
            motto.reviewed = 1
            motto.reviews += 1
            self.refreshCellAtRowIndex(index)
        }
        
        self.presentBackableController(controller)
    }
    
    
    ///更多操作
    func moreAction(_ sender:UIButton){
        let motto = self.mottos[sender.tag]
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(title: "复制到剪贴板", style: .default, handler: { (action) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = "\(motto.content)[\(motto.userName)@偶得]"
            
            self.view.window?.makeToast("复制到剪贴板成功。")
        }))
        
        controller.addAction(UIAlertAction(title: "分享到...", style: .default, handler: { (action) in
            let textToShare = "\(motto.content)[\(motto.userName)@偶得]"
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
                
                activityVC.popoverPresentationController?.sourceView = self.tableView
                self.present(activityVC, animated: true, completion: nil)
            }
            
        }))
        
        controller.addAction(UIAlertAction(title: "举报不良信息", style: .default, handler: { (action) in
            let alertView = UIAlertController(title: "填写举报原因", message: nil, preferredStyle: .alert)
            var txtReason: UITextField?
            alertView.addTextField(configurationHandler: { (txtField) in
                txtField.placeholder = "侵权或其它违规行为"
                txtReason = txtField
            })
            
            alertView.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                if txtReason?.text != ""{
                    ToastManager.shared.makeToastActivity(self.view)
                    IMApi.instance.addReport(String(motto.id), type: 0, reason: txtReason!.text!, completion: { (resp) in
                        ToastManager.shared.hideToastActivity()
                        if resp.isSuccess{
                            self.view.window?.makeToast("举报信息已提交，我们会及时处理并向您反馈处理结果。")
                        }else{
                            self.view.window?.makeToast("发生错误，请稍后重试。")
                        }
                    })
                }
            }))
            
            self.present(alertView, animated: true, completion: nil)
        }))
        
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    func refreshCellAtRowIndex(_ index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//
//  AlbumDetailController.swift
//  iMottoApp
//
//  Created by sunht on 16/9/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class AlbumDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate, RankingViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tableHeader: AlbumHeaderView!
    var album: AlbumModel!
    var mottos = [MottoModel]()
    var refreshControl: UIRefreshControl!
    var infiniteScrollingView: UIView!
    var page = 1
    var allDataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn

        let userId = PropHelper.instance.userId!
        if album.uid == userId {
            let loveImg = FAKIonIcons.iosComposeOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
            let buttonItem = UIBarButtonItem(image: loveImg, style: .plain, target: self, action: #selector(buttonEditClicked))
            buttonItem.tintColor = COLOR_NAV_TINT
            self.navigationItem.rightBarButtonItem = buttonItem
        }
        
        self.navigationItem.title = "\(album.uname)的珍藏"
        
        setupTableView()
        
    }
    
    func setupTableView(){
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        
        let nib = UINib(nibName: "MottoReviewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyMottoRankingCell)
        let nib2 = UINib(nibName: "DisplayMottoCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: keyMottoDisplayCell)
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.separatorColor = UIColor.clear
        
        if let headerView = AlbumHeaderView.instanceFromNib() as? AlbumHeaderView{
            //headerView.height = UITableViewAutomaticDimension
            headerView.lblTitle.text = album.title
            headerView.lblSummary.text = album.summary
            
            headerView.labelName.text = album.uname
            headerView.lblInfo.text = "收录\(album.mottos)则偶得"
            headerView.labelTime.text = "\(friendlyTime(album.createTime))创建"

            headerView.buttonLove.setTitle(" \(album.loves)", for: UIControlState())
            headerView.setLoveState(album.loved)
            headerView.buttonLove.addTarget(self, action: #selector(btnLoveTapped), for: .touchUpInside)
            
            self.tableView.setAndLayoutTableHeaderView(headerView)
            self.tableHeader = headerView
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(showAlbumCreator))
            headerView.labelName.isUserInteractionEnabled = true
            headerView.labelName.addGestureRecognizer(tap)
        }
        
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
        let cid = self.album.id
        self.page = 1
        self.allDataLoaded = false
        
        IMApi.instance.readAlbumMottos(cid, pindex: 1, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if(resp.isSuccess){
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.mottos = marray
                }
            }
            
            self.tableView.reloadData()
            control.endRefreshing()
        }
    }
    
    func setInfiniteScrollingView(){
        self.infiniteScrollingView = UIView(frame: CGRect(x: 0,y: self.tableView.contentSize.height, width: self.tableView.bounds.size.width, height: 60))
        self.infiniteScrollingView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.infiniteScrollingView.backgroundColor = UIColor.white
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
        IMApi.instance.readAlbumMottos(self.album.id, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    for motto in marray{
                        let idx = self.mottos.index{$0.id == motto.id}
                        if idx == nil{
                            self.mottos.append(motto)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
            
            self.infiniteScrollingView?.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.mottos.count)
        return self.mottos.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mcell: UITableViewCell
        let motto = self.mottos[(indexPath as NSIndexPath).row]
        
        if (motto.state == .evaluating && motto.vote == .noVote) {
            let cell = tableView.dequeueReusableCell(withIdentifier: keyMottoRankingCell, for: indexPath) as! MottoReviewCell
        cell.constraintBottomViewHeight.constant = 0
            cell.setModel(motto, indexPath: indexPath)
            cell.buttonLike.tag = indexPath.row
            cell.buttonLike.addTarget(self, action: #selector(buttonLikeClicked), for: .touchUpInside)
            cell.buttonDislike.tag = indexPath.row
            cell.buttonDislike.addTarget(self, action: #selector(buttonDislikeClicked), for: .touchUpInside)
            cell.buttonModerate.tag = indexPath.row
            cell.buttonModerate.addTarget(self, action: #selector(buttonModerateClicked), for: .touchUpInside)
            
            mcell = cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: keyMottoDisplayCell, for: indexPath) as! DisplayMottoCell
           cell.constraintBottomViewHeight.constant = 0
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
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(showUser))
            cell.imageViewAvatar.tag = (indexPath as NSIndexPath).row
            cell.imageViewAvatar.addGestureRecognizer(tap)
            
            mcell = cell
        }
        
        return mcell
    }
    
    func buttonScoreClicked(_ sender:UIButton) {
        let index = sender.tag
        let motto = self.mottos[index]
        
        let controller = VoteListViewController()
        controller.mid = motto.id
        controller.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showUser(_ sender:UITapGestureRecognizer){
        
        if let idx = sender.view?.tag{
            var uid = self.album.uid
            if idx >= 0{
                let motto = self.mottos[idx]
                uid = motto.uid
            }
            
            if PropHelper.instance.userId != uid {
                let controller = UserInfoController()
                controller.userId = uid
                self.presentBackableController(controller)
            }
        }
    }
    
    func showAlbumCreator() {
        if PropHelper.instance.userId != self.album.uid {
            let controller = UserInfoController()
            controller.userId = self.album.uid
            self.presentBackableController(controller)
        }
    }
    
    func buttonLikeClicked(_ sender:UIButton) {
        let index = sender.tag
        let motto = self.mottos[index]
        
        if PropHelper.instance.isLogin{
            
            if motto.vote != VoteState.noVote{
                self.view.window?.makeToast("您已投过票")
                return
            }
            
            ToastManager.shared.makeToastActivity(self.view)
            IMApi.instance.supportMotto(motto.id, theDay: extractTheDay(motto.addTime) , action:.like, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    motto.up = motto.up + 1
                    motto.vote = VoteState.supported
                    self.refreshCellAtRowIndex(index)
                }else{
                    debugPrint("support Motto failure: \(resp.msg)")
                }
            })
        }else{
            self.gotoLoginController(usePush: false)
        }
    }
    
    func buttonDislikeClicked(_ sender:UIButton) {
        let index = sender.tag
        let motto = self.mottos[index]
        
        if PropHelper.instance.isLogin{
            
            if motto.vote != VoteState.noVote{
                self.view.window?.makeToast("您已投过票")
                return
            }
            
            ToastManager.shared.makeToastActivity(self.view)
            IMApi.instance.supportMotto(motto.id, theDay: extractTheDay(motto.addTime) , action:.dislike, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    motto.up = motto.up - 1
                    motto.vote = VoteState.supported
                    self.refreshCellAtRowIndex(index)
                }else{
                    debugPrint("support Motto failure: \(resp.msg)")
                }
            })
        }else{
            self.gotoLoginController(usePush: false)
        }
    }
    
    func buttonModerateClicked(_ sender:UIButton) {
        let index = sender.tag
        let motto = self.mottos[index]
        
        if PropHelper.instance.isLogin{
            
            if motto.vote != VoteState.noVote{
                self.view.window?.makeToast("您已投过票")
                return
            }
            
            ToastManager.shared.makeToastActivity(self.view)
            IMApi.instance.supportMotto(motto.id, theDay: extractTheDay(motto.addTime) , action:.moderate, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    motto.vote = VoteState.supported
                    self.refreshCellAtRowIndex(index)
                }else{
                    debugPrint("support Motto failure: \(resp.msg)")
                }
            })
        }else{
            self.gotoLoginController(usePush: false)
        }
    }

    func loveMotto(_ sender:UIButton){
        let index = sender.tag
        let motto = self.mottos[index]
        
        if PropHelper.instance.isLogin{
            switch motto.loved {
            case .nofeeling:
                IMApi.instance.loveMotto(motto.id, theDay: extractTheDay(motto.addTime) ) { (resp) in
                    if resp.isSuccess{
                        motto.loved = LovedState.loved
                        motto.loves = motto.loves + 1
                        self.refreshCellAtRowIndex(index)
                    }else{
                        self.view.window?.makeToast("添加至喜欢列表出错，请重试")
                    }
                }
                break
            case .loved:
                IMApi.instance.loveMotto(motto.id, theDay: extractTheDay(motto.addTime)) { (resp) in
                    if resp.isSuccess{
                        motto.loved = LovedState.nofeeling
                        motto.loves = motto.loves - 1
                        self.refreshCellAtRowIndex(index)
                    }else{
                        self.view.window?.makeToast("取消喜欢出错，请重试")
                    }
                }
                break
            }
        }
        else{
            self.gotoLoginController(usePush: true)
        }

    }
    
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

    
    func btnLoveTapped(_ sender:AnyObject?){
        if PropHelper.instance.isLogin{
            
//            if self.album.uid == PropHelper.instance.userId{
//                return
//            }
            
            if self.album.loved == LovedState.loved{
                IMApi.instance.unloveCollection(self.album.id, completion: { (resp) in
                    if resp.isSuccess{
                        self.album.loves = self.album.loves-1
                        self.album.loved = LovedState.nofeeling
                        self.refreshLoveState()
                    }else{
                        debugPrint("failure: \(resp.msg)")
                        self.view.window?.makeToast("将珍藏移出喜欢列表时出错，请重试。")
                    }
                })
            }
            else{
                IMApi.instance.loveCollection(self.album.id, completion: { (resp) in
                    if resp.isSuccess{
                        self.album.loves = self.album.loves+1
                        self.album.loved = LovedState.loved
                        self.refreshLoveState()
                    }else{
                        debugPrint("failure: \(resp.msg)")
                        self.view.window?.makeToast("将珍藏加入喜欢列表时出错，请重试。")
                    }
                })
            }
            
        }else{
            self.gotoLoginController(usePush: true)
        }
    }
    
    func refreshLoveState(){
        self.tableHeader.buttonLove.setTitle(String(self.album.loves), for: UIControlState())
        self.tableHeader.setLoveState(self.album.loved)
    }
    
    
    // MARK: - Ranking Delegate
    
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
    
    func refreshCellAtRowIndex(_ index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func buttonEditClicked() {
        if let createAlbumController = self.storyboard?.instantiateViewController(withIdentifier: "createAlbumController") as? CreateAlbumController{
            createAlbumController.album = self.album
            createAlbumController.successCallback = {
                [unowned self] in
                self.refreshStateChange(self.refreshControl!)
            }
            
            self.navigationController?.pushViewController(createAlbumController, animated: true)
            
        }
    }
}

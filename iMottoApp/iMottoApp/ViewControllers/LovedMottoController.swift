//
//  LovedMottoController.swift
//  iMottoApp
//
//  Created by sunht on 16/9/18.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class LovedMottoController: UITableViewController, RankingViewDelegate {
    var user: UserModel?
    var mottos = [MottoModel]()
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView?.tintColor = COLOR_NAV_TINT
        
        if self.user != nil{
            self.navigationItem.title = "\(self.user!.displayName)喜欢的偶得"
        }else{
            self.navigationItem.title="我喜欢的偶得"
        }
        
        let btnBack = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        btnBack.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = btnBack
    
        let nib = UINib(nibName: "MottoReviewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyMottoRankingCell)
        let nib2 = UINib(nibName: "DisplayMottoCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: keyMottoDisplayCell)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0
        self.tableView.separatorColor = UIColor.clear
        
        let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        let _ = self.tableView.es_addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        let _ = self.tableView.es_addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        
        self.tableView.es_startPullToRefresh()
    }
    
    // MARK: - Pull to refresh
    
    private func refresh() {
        self.page = 1
        self.mottos.removeAll()
        
        var uid = PropHelper.instance.userId!
        if self.user != nil{
            uid = self.user!.id
        }
        
        IMApi.instance.readLovedMottos(uid, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess {
                let marray = resp.Data!
                self.mottos.append(contentsOf: marray)
                self.tableView.reloadData()
                self.tableView.es_stopPullToRefresh(completion: true)
                
                if marray.count < DEFAULT_PAGE_SIZE {
                    self.tableView.es_noticeNoMoreData()
                }
            } else {
                self.tableView.es_stopPullToRefresh(completion: true)
            }
        }
    }
    
    private func loadMore() {
        self.page += 1
        
        var uid = PropHelper.instance.userId!
        if self.user != nil{
            uid = self.user!.id
        }
        
        IMApi.instance.readLovedMottos(uid, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if(resp.isSuccess){
                let marray = resp.Data!
                
                for motto in marray{
                    let idx = self.mottos.index{$0.id == motto.id}
                    if idx == nil{
                        self.mottos.append(motto)
                    }
                }
                self.tableView.reloadData()
                
                if marray.count < DEFAULT_PAGE_SIZE {
                    self.tableView.es_noticeNoMoreData()
                } else {
                    self.tableView.es_stopLoadingMore()
                }
            } else {
                self.tableView.es_stopLoadingMore()
            }
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mcell:UITableViewCell
        let motto = self.mottos[(indexPath as NSIndexPath).row]
        
        if (motto.state == .evaluating && motto.vote == .noVote) {
            let cell = tableView.dequeueReusableCell(withIdentifier: keyMottoRankingCell, for: indexPath) as! MottoReviewCell
            cell.setModel(motto, indexPath: indexPath)
            cell.buttonLike.tag = indexPath.row
            cell.buttonLike.addTarget(self, action: #selector(buttonLikeClicked), for: .touchUpInside)
            cell.buttonDislike.tag = indexPath.row
            cell.buttonDislike.addTarget(self, action: #selector(buttonDislikeClicked), for: .touchUpInside)
            cell.buttonModerate.tag = indexPath.row
            cell.buttonModerate.addTarget(self, action: #selector(buttonModerateClicked), for: .touchUpInside)
            
            mcell = cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: keyMottoDisplayCell, for: indexPath) as! DisplayMottoCell
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
    
    func showUser(_ sender:UITapGestureRecognizer){
        if let idx = sender.view?.tag{
            let motto = self.mottos[idx]
            if PropHelper.instance.userId != motto.uid {
                let controller = UserInfoController()
                controller.userId = motto.uid
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
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
                        //self.view.window?.makeToast("添加至喜欢列表成功")
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

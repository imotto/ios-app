//
//  ReviewViewController.swift
//  iMottoApp
//
//  Created by sunht on 16/7/12.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
import ImageLoader

class ReviewViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,SYKeyboardTextFieldDelegate {
    var thumbPlaceholder:UIImage!
    
    var infiniteScrollingView:UIView?
    var reviews = [ReviewModel]()
    var page = 1
    var allDataLoaded = false
    
    var motto:MottoModel?
    var keyboardTextField:SYKeyboardTextField!
    var refreshControl:UIRefreshControl?
    @IBOutlet weak var tableView: UITableView!
    
    var addReviewCallback:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.navigationItem.titleView?.tintColor = COLOR_NAV_TINT
        self.navigationItem.title = "评论列表"
        
        let btnBack = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        btnBack.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = btnBack

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addInputControl()
        
        self.tableView.estimatedRowHeight = 120.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
        
        setupRefresh()
        setInfiniteScrollingView()
        
        let thumbIcon = FAKIonIcons.iosPersonIcon(withSize: 24)
        thumbIcon?.addAttribute(NSForegroundColorAttributeName, value: COLOR_BTN_TINT)
        self.thumbPlaceholder = thumbIcon?.image(with: CGSize(width: 24, height: 24))
    }
    
    func addInputControl(){
        keyboardTextField = SYKeyboardTextField(point: CGPoint(x: 0, y: 0), width: self.view.width)
        keyboardTextField.backgroundColor = UIColor.red
        keyboardTextField.delegate = self
        keyboardTextField.leftButtonHidden = true
        keyboardTextField.rightButtonHidden = false
        keyboardTextField.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleTopMargin]
        keyboardTextField.backgroundColor = COLOR_TAB_BG
        keyboardTextField.placeholderLabel.text = "输入评论内容"
        
        keyboardTextField.rightButton.tintColor = COLOR_TAB_TINT
        
        self.view.addSubview(keyboardTextField)
        keyboardTextField.toFullyBottom()
    }
    
    // MARK: - Pull to refresh
    
    func setupRefresh(){
        let control = UIRefreshControl()
        self.refreshControl = control
        control.addTarget(self, action: #selector(refreshStateChange), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(control)
        
        control.beginRefreshing()
        self.refreshStateChange(control)
    }
    
    func refreshStateChange(_ control:UIRefreshControl){
        
        self.page = 1
        self.allDataLoaded = false
        
        IMApi.instance.readReviews(self.motto!.id, pindex: 1, psize: DEFAULT_PAGE_SIZE) { (resp) in
            
            if(resp.isSuccess){
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.reviews = marray
                }
            }else{
                debugPrint(resp.msg)
            }
            
            self.tableView.reloadData()
            
            if self.reviews.count == 0 {
                self.keyboardTextField.textView.becomeFirstResponder()
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
        IMApi.instance.readReviews(self.motto!.id, pindex: page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.reviews.append(contentsOf: marray)
                    
                    self.tableView.reloadData()
                }
            }else{
                debugPrint(resp.msg)
            }
            
            self.infiniteScrollingView?.isHidden = true
        }
    }
    
    func keyboardTextFieldPressRightButton(_ keyboardTextField :SYKeyboardTextField){
        
        let review = keyboardTextField.text.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if review == ""{
            return
        }
        
        if PropHelper.instance.isLogin{
            if let theday = self.motto?.getTheDay(){
                ToastManager.shared.makeToastActivity(self.view)
                IMApi.instance.addReview(self.motto!.id, theDay: theday, content: review, completion: { (resp) in
                    ToastManager.shared.hideToastActivity()
                    if resp.isSuccess{
                        //refresh data
                        keyboardTextField.text=""
                        self.view.window?.makeToast("评论提交成功。")
                        self.keyboardTextField.textView.resignFirstResponder()
                        self.refreshStateChange(self.refreshControl!)
                        
                        if (self.addReviewCallback != nil) {
                            self.addReviewCallback!()
                        }
                    }else{
                        debugPrint(resp.msg)
                        self.view.window?.makeToast("提交评论时出了点问题，请稍后重试。")
                    }
                })
            }
        }
        else{
            self.gotoLoginController(usePush: true)
        }
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.reviews.count)
        return self.reviews.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
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
        let review = self.reviews[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewcell", for: indexPath) as! ReviewTableViewCell
        //注意，支持按钮（btnSupport）隐藏，反对按钮(btnOppose)代替支持按钮
        cell.lblAddTime.text = friendlyTime(review.addTime)
        cell.lblReview.text = review.content
        cell.lblUserName.text = "\(review.userName):"
        //cell.btnSupport.setTitle("\(review.up)", forState: .Normal)
        cell.btnOppose.setTitle("\(review.up)", for: UIControlState())
        cell.setSupportState(review.supported)
        
        cell.btnOppose.tag = (indexPath as NSIndexPath).row
        cell.btnMoreAction.tag = (indexPath as NSIndexPath).row
        cell.imgThumb.tag = (indexPath as NSIndexPath).row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showUser))
        cell.imgThumb.addGestureRecognizer(tapGesture)
        
        if review.userThumb == ""{
            cell.imgThumb.image = thumbPlaceholder
        }else{
            cell.imgThumb.image = thumbPlaceholder
            cell.imgThumb.load.request(with: review.userThumb, onCompletion: { image, error, operation in
                if operation == .network {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionFade
                    cell.imgThumb.layer.add(transition, forKey: nil)
                    cell.imgThumb.image = image
                }
            })
        }

        
        cell.btnOppose.addTarget(self, action: #selector(btnSupportTapped), for: .touchUpInside)
        cell.btnMoreAction.addTarget(self, action: #selector(btnMoreTapped), for: .touchUpInside)
        
        if(!allDataLoaded){
            //加载更多
            if (indexPath as NSIndexPath).row == self.reviews.count - 1{
                self.tableView.tableFooterView = self.infiniteScrollingView
                loadMore()
            }
        }
        
        return cell
    }
    
    func refreshCellAtRowIndex(_ index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showUser(_ sender:UITapGestureRecognizer){
        if let idx = sender.view?.tag{
            let review = self.reviews[idx]
            if PropHelper.instance.userId != review.uid {
                let controller = UserInfoController()
                controller.userId = review.uid
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func btnSupportTapped(_ sender:UIButton?){
        if let index = sender?.tag{
            if index >= reviews.count{
                debugPrint("btnSupport tag out of range.")
                return
            }
            
            let review = self.reviews[index]
            IMApi.instance.addReviewVote(review.mid, rid: review.id, support: SupportState.notYet == review.supported, completion: { (resp) in
                if resp.isSuccess{
                    if SupportState.notYet ==  review.supported{
                        review.up = review.up + 1
                        review.supported = SupportState.supported
                    }else{
                        review.up = review.up - 1
                        review.supported = SupportState.notYet
                    }
                    
                    self.refreshCellAtRowIndex(index)
                    
                }else{
                    debugPrint(resp.msg)
                    self.view.window?.makeToast("出了点问题，请稍后再试。")
                }
            })

        }
    }
    
    func btnMoreTapped(_ sender:UIButton){
        let review = self.reviews[sender.tag]
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(title: "复制到剪贴板", style: .default, handler: { (action) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = "\(review.content)[\(review.userName)@偶得]"
            
            self.view.window?.makeToast("复制到剪贴板成功。")
        }))
        
        controller.addAction(UIAlertAction(title: "分享到...", style: .default, handler: { (action) in
            let textToShare = "\(review.content)[\(review.userName)@偶得]"
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
                    IMApi.instance.addReport(String(review.id), type: 1, reason: txtReason!.text!, completion: { (resp) in
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

}

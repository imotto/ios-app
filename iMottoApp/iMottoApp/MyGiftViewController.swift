//
//  MyGiftViewController.swift
//  iMottoApp
//
//  Created by zhangkai on 25/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit

class MyGiftViewController: UIViewController, UITableViewDataSource {
    var mid:Int64!
    var page = 1
    var gifts = [GiftExchangeModel]()
    
    lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        let giftImg = FAKIonIcons.iosCartOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        let giftBtn = UIBarButtonItem(image: giftImg, style: .plain, target: self, action: #selector(giftBtnTapped))
        giftBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.rightBarButtonItem = giftBtn
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationItem.title = "我的礼品"
        
        self.view.backgroundColor = UIColor.white
        
        tableView.dataSource = self;
        let nib = UINib(nibName: "MyGiftCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyGiftCell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        let _ = self.tableView.es_addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        let _ = self.tableView.es_addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.es_startPullToRefresh()
    }
    
    // MARK: - Private
    
    private func refresh() {
        self.page = 1
        self.gifts.removeAll()
        
        IMApi.instance.readUserExchanges(self.page, psize: 10) { (resp) in
            if resp.isSuccess {
                let marray = resp.Data!
                self.gifts.append(contentsOf: marray)
                self.tableView.reloadData()
                self.tableView.es_stopPullToRefresh(completion: true)
                
                if marray.count < DEFAULT_PAGE_SIZE {
                    self.tableView.es_noticeNoMoreData()
                }
            } else {
                debugPrint("support Motto failure: \(resp.msg)")
                self.tableView.es_stopPullToRefresh(completion: true)
            }
        }
    }
    
    private func loadMore() {
        self.page += 1
        
        IMApi.instance.readUserExchanges(self.page, psize: 10) { (resp) in
            if resp.isSuccess {
                let marray = resp.Data!
                self.gifts.append(contentsOf: marray)
                self.tableView.reloadData()
                self.tableView.es_stopPullToRefresh(completion: true)
                
                if marray.count < DEFAULT_PAGE_SIZE {
                    self.tableView.es_noticeNoMoreData()
                } else {
                    self.tableView.es_stopLoadingMore()
                }
            } else {
                debugPrint("support Motto failure: \(resp.msg)")
                self.tableView.es_stopLoadingMore()
            }
        }
    }
    
    func giftBtnTapped(_ sender: AnyObject){
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GiftsController")
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func buttonReceiveClicked(_ sender:UIButton) {
        let controller = UIAlertController(title: "礼品签收", message: "确认已经收到礼品了？", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "是的", style: .cancel, handler: { (action) in
            ToastManager.shared.makeToastActivity(self.view)
            let gift = self.gifts[sender.tag]
            IMApi.instance.doSignature("\(gift.id)", completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    self.tableView.es_startPullToRefresh()
                } else {
                    self.view.window?.makeToast("发送失败，请重试。")
                }
            })
        }))
        controller.addAction(UIAlertAction(title: "还没有", style: .default, handler: { (action) in
            
        }))
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func buttonReviewClicked(_ sender:UIButton) {
        let gift = self.gifts[sender.tag]
        let controller = AddReviewViewController()
        controller.exchangeId = "\(gift.id)"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gifts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGiftCell") as! MyGiftCell
        
        let model = self.gifts[indexPath.row]
        cell.imageViewLogo.image = ImgGiftPlaceholder
        cell.labelName.text = model.giftName
        
        cell.buttonAction.isHidden = true
        cell.constraintButtonActionHeight.constant = 0
        var status = ""
        var statusHint = ""
        switch model.deliverState {
        case 0:
            status = "待发放"
            statusHint = "请耐心等待礼品发放"
            break
        case 1:
            status = "运送中"
            statusHint = "请耐心等待礼品投递"
            cell.buttonAction.isHidden = false
            cell.constraintButtonActionHeight.constant = 30
            cell.buttonAction.setTitle("礼品签收", for: .normal)
            cell.buttonAction.tag = indexPath.row
            cell.buttonAction.addTarget(self, action: #selector(buttonReceiveClicked), for: .touchUpInside)
            break
        case 2:
            status = "已签收"
            statusHint = "已经确认签收"
            cell.buttonAction.isHidden = false
            cell.constraintButtonActionHeight.constant = 30
            cell.buttonAction.setTitle("填写评价", for: .normal)
            cell.buttonAction.tag = indexPath.row
            cell.buttonAction.addTarget(self, action: #selector(buttonReviewClicked), for: .touchUpInside)
            break
        case 3:
            status = "已退货"
            statusHint = "已经进行退货处理"
            break
        case 9:
            status = "已评价"
            statusHint = "交易已完成"
            break
        default:
            status = ""
            statusHint = "已无法跟踪状态"
        }
        
        cell.labelStatus.text = status
        let info = "您在\(friendlyTime(model.exchangeTime))使用\(model.total)枚金币兑换\(model.amount)件此礼品，\(statusHint)"
        cell.labelDesc.text = info
        
        return cell
    }
    
    // MARK: -

}

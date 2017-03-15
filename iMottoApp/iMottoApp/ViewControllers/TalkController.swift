//
//  TalkController.swift
//  iMottoApp
//
//  Created by sunht on 16/10/15.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class TalkController: UIViewController, UITableViewDelegate, UITableViewDataSource, SYKeyboardTextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    var keyboardTextField: SYKeyboardTextField!
    var talks = [TalkMsgModel]()
    
    var talk2user: SimpleUser!
    
    var startIndex: Int64 {
        get{
            if let tmp = self.talks.first?.id{
                return tmp
            }else{
                return 0
            }
        }
    }
    var endIndex: Int64 {
        get{
            if let tmp = self.talks.last?.id{
                return tmp
            }
            else{
                return 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "\(talk2user.name)"
        
        let btnBack = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        btnBack.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = btnBack
        
        self.addInputControl()
        self.tableView.estimatedRowHeight = 78
//        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: "TalkMsgCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyTalkMsgCell)
        
        let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        header.pullToRefreshDescription = "显示更多消息"
        header.releaseToRefreshDescription = "显示更多消息"
        let _ = self.tableView.es_addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        
        self.tableView.es_startPullToRefresh()
    }
    
    func addInputControl(){
        keyboardTextField = SYKeyboardTextField(point: CGPoint(x: 0, y: 0), width: self.view.width)
        keyboardTextField.delegate = self
        keyboardTextField.leftButtonHidden = true
        keyboardTextField.rightButtonHidden = false
        keyboardTextField.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleTopMargin]
        keyboardTextField.backgroundColor = COLOR_TAB_BG
        keyboardTextField.placeholderLabel.text = "输入消息内容"
        
        keyboardTextField.rightButton.tintColor = COLOR_TAB_TINT
        
        self.view.addSubview(keyboardTextField)
        keyboardTextField.toFullyBottom()
    }
    
    // MARK: - Pull to refresh
    func refresh() {
        IMApi.instance.readTalkMsgs(talk2user.id, start: startIndex, take: 0-DEFAULT_PAGE_SIZE, completion: {(resp) in
            if resp.isSuccess{
                let marray = resp.Data!
                if  self.talks.count > 0 {
                    self.talks.insert(contentsOf: marray, at: 0)
                    self.tableView.reloadData()
                } else {
                    self.talks.append(contentsOf: marray)
                    self.tableView.reloadData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if self.talks.count > 0 {
                            let indexPath = IndexPath(row: self.talks.count - 1, section: 0)
                            self.tableView?.scrollToRow(at: indexPath, at:.bottom, animated: false)
                        }
                    }
                }
                self.tableView.es_stopPullToRefresh(completion: true)
            } else {
                self.tableView.es_stopPullToRefresh(completion: true)
            }
        })
    }
    
    func keyboardTextFieldPressRightButton(_ keyboardTextField :SYKeyboardTextField){
        
        let msg = keyboardTextField.text.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if msg == ""{
            return
        }
        
        
        self.keyboardTextField.textView.resignFirstResponder()
        
        if PropHelper.instance.isLogin{
            ToastManager.shared.makeToastActivity(self.view)
            IMApi.instance.sendMsg(talk2user.id, content: msg, completion: { (resp) in
                ToastManager.shared.hideToastActivity()
                if resp.isSuccess{
                    //refresh data
                    keyboardTextField.text = ""
                    self.talks.removeAll()
                    
                    self.tableView.es_startPullToRefresh()
                }else{
                    debugPrint(resp.msg)
                    self.view.window?.makeToast("发送消息时出了点问题，请稍后重试。")
                }
            })
        }
        else{
            self.gotoLoginController(usePush: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.talks.count)
        return self.talks.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: keyTalkMsgCell, for: indexPath) as! TalkMsgCell
        cell.selectionStyle = .none
        let msg = self.talks[(indexPath as NSIndexPath).row]
        if msg.direction == 1{
            cell.setModel(msg, forUser: talk2user.name, withThumb: talk2user.thumb)
        }else {
            cell.setModel(msg, forUser: "我", withThumb: PropHelper.instance.userThumb!)
        }
        
        return cell
    }
}

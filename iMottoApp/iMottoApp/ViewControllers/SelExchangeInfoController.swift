//
//  SelExchangeInfoController.swift
//  iMottoApp
//
//  Created by sunht on 2016/12/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class SelExchangeInfoController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnOk: UIButton!
    var prepareModel:PEResultModel!
    var giftId:Int?
    var amount:Int = 1
    var selectedIndex:Int = 0
    
    var exchangedCallback:(()->Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView?.tintColor = COLOR_NAV_TINT
        self.navigationItem.title = prepareModel.reqInfoHint
        
        let btnBack = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        btnBack.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = btnBack
        
        let imgAdd = FAKIonIcons.plusIcon(withSize: 30).image(with: CGSize(width: 30, height: 30))
        let btnAdd = UIBarButtonItem(image:imgAdd, style: .plain, target: self, action: #selector(btnCreateTapped))
        btnAdd.tintColor = COLOR_NAV_TINT
        self.navigationItem.rightBarButtonItem = btnAdd
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib(nibName: "SelExchangeInfoCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keySelExchangeInfoCell)
        
        self.tableView.estimatedRowHeight = 72
    }


    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(prepareModel.reqInfoType == 0){
            self.tableView.displayMsg("没有相关记录，点击右上角+号添加", forRowCount: (prepareModel.addresses?.count)!)
            return (prepareModel.addresses?.count)!
        }else{
            self.tableView.displayMsg("没有相关记录，点击右上角+号添加", forRowCount: (prepareModel.accounts?.count)!)
            return (prepareModel.accounts?.count)!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: keySelExchangeInfoCell, for: indexPath) as! SelExchangeInfoCell
        
        let checkState = (indexPath as NSIndexPath).row == selectedIndex
        
        if(prepareModel.reqInfoType == 0){
            let addr = prepareModel.addresses![(indexPath as NSIndexPath).row]
            
            cell.lblTitle.text = "\(addr.contact)(\(addr.mobile))"
            cell.lblInfo.text = addr.province + addr.city + addr.district + addr.address
            
            cell.setCheckState(checkState)
        }else{
            let acct = prepareModel.accounts![(indexPath as NSIndexPath).row]
            cell.lblTitle.text = acct.accountName
            cell.lblInfo.text = acct.accountNo
            cell.setCheckState(checkState)
        }

        return cell
    }
    
    
    func refreshCellAtRowIndex(_ index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if selectedIndex != (indexPath as NSIndexPath).row{
            selectedIndex = (indexPath as NSIndexPath).row
            self.tableView.reloadData()
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

    @IBAction func btnOkTapped(_ sender: AnyObject) {
        
        var infoId:Int64?
        
        if(prepareModel.reqInfoType == 0){
            if prepareModel.addresses?.count <= 0 {
                self.view.window?.makeToast(prepareModel.reqInfoHint!)
                return
            }
            
            infoId = prepareModel.addresses![selectedIndex].id
        }
        else{
            if prepareModel.accounts?.count <= 0{
                self.view.window?.makeToast(prepareModel.reqInfoHint!)
                return
            }
            
            infoId = prepareModel.accounts![selectedIndex].id
        }
        
        ToastManager.shared.makeToastActivity(self.view)
        IMApi.instance.doExchange(self.giftId!, reqInfoId: infoId!, amount: self.amount) { (resp) in
            ToastManager.shared.hideToastActivity()
            if (resp.isSuccess){
                if(self.exchangedCallback != nil){
                    self.exchangedCallback()
                }
                
                self.navigationController?.popViewController(animated: true)
                
            }else{
                self.view.window?.makeToast(resp.msg)
            }
            
        }
        
        
    }
    
    @IBAction func btnCancelTapped(_ sender: AnyObject) {
        //do callback stuff?
        self.navigationController?.popViewController(animated: true)
    }
   
    
    func btnCreateTapped(_ sender: AnyObject) {
        if prepareModel.reqInfoType == 0{
            //添加地址
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AddAddressController") as! AddAddressController
            controller.addressAdded = {(uaddrModel) in
                self.prepareModel.addresses?.insert(uaddrModel, at: 0)
                self.selectedIndex = 0
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else {
            //需要关联账号
            doAddAccount()
        }
    }
    
    func doAddAccount(){
        let dialog = UIAlertController(title: prepareModel.reqInfoHint, message: "", preferredStyle: .alert)
        var txtAccountNo: UITextField?
        var txtAccountName: UITextField?
        
        dialog.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "账号"
            txtAccountNo = textField
        })
        
        dialog.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "用户名称"
            txtAccountName = textField
        })
        
        dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            debugPrint("canceled")
        }))
        dialog.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            debugPrint("confirm \(txtAccountNo?.text), \(txtAccountName?.text)")
            if txtAccountNo?.text == ""{
                self.view.window?.makeToast("账号不能为空，请重新输入")
            }else if txtAccountName?.text == ""{
                self.view.window?.makeToast("用户名称不能为空,请重新输入")
            }else{
                ToastManager.shared.makeToastActivity(self.view)
                let accountNo = (txtAccountNo?.text)!
                let accountName = (txtAccountName?.text)!
                IMApi.instance.addRelAccount(self.prepareModel.reqInfoType!, accountNo: accountNo, accountName: accountName, completion: { (resp) in
                    ToastManager.shared.hideToastActivity()
                    if resp.isSuccess{
                        let data = NSDictionary(objects: [NSNumber(value: resp.infoId as Int64),PropHelper.instance.userId!,self.prepareModel.reqInfoType!, accountNo,accountName],
                            forKeys: ["ID" as NSCopying,"UID" as NSCopying,"Platform" as NSCopying,"AccountNo" as NSCopying,"AccountName" as NSCopying])
                        let account = RelAccountModel(data: data)
                        self.prepareModel.accounts?.insert(account, at: 0)
                        self.selectedIndex = 0
                        self.tableView.reloadData()
                    }else{
                        self.view.window?.makeToast(resp.msg)
                    }
                })
            }
        }))
        
        self.present(dialog, animated: true, completion: nil)
    }

}

//
//  ScoreRecordController.swift
//  iMottoApp
//
//  Created by sunht on 16/10/8.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class ScoreRecordController: UITableViewController {

    var scoreRecords = [ScoreRecordModel]()
    var infiniteScrollingView: UIView!
    var page = 1
    var allDataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationItem.title = "我的积分记录"
        
        let nib = UINib(nibName: "ScoreDisplayCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: keyScoreDisplayCell)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 46.0
        
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
        
        IMApi.instance.readScoreRecord(page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.scoreRecords = marray
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
        
        IMApi.instance.readScoreRecord(page, psize: DEFAULT_PAGE_SIZE) { (resp) in
            if resp.isSuccess{
                if let marray = resp.Data{
                    if marray.count < DEFAULT_PAGE_SIZE{
                        self.allDataLoaded = true
                    }
                    
                    self.scoreRecords.append(contentsOf: marray)
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
        self.tableView.displayMsg(TABLEVIEW_NO_DATA_HINT, forRowCount: self.scoreRecords.count)
        return self.scoreRecords.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: keyScoreDisplayCell, for: indexPath) as! ScoreDisplayCell

        let score = self.scoreRecords[(indexPath as NSIndexPath).row]
        
        cell.lblTime.text = String(score.theDay)
        cell.lblScore.text = "+\(score.revenue)"
        cell.lblInfo.text = "\(score.mottos)则作品"
        
        if(!allDataLoaded){
            //加载更多
            if (indexPath as NSIndexPath).row == self.scoreRecords.count-1 {
                self.tableView.tableFooterView = self.infiniteScrollingView
                loadMore()
            }
        }else{
            let footerView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.width,height: 60))
            self.tableView.tableFooterView = footerView
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

}

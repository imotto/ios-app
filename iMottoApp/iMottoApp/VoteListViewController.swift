//
//  VoteListViewController.swift
//  iMottoApp
//
//  Created by zhangkai on 22/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit
import SnapKit

class VoteListViewController: UIViewController, UITableViewDataSource {

    var mid:Int64!
    var page = 1
    var votes = [VoteModel]()
    
    lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        backBtn.tintColor = COLOR_NAV_TINT
        self.navigationItem.leftBarButtonItem = backBtn
        
        self.title = "偶得积分"
        self.view.backgroundColor = UIColor.white
        
        tableView.dataSource = self;
        let nib = UINib(nibName: "VoteCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VoteCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
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
        
        self.tableView.es_startPullToRefresh()
    }
    
    // MARK: - Private

    private func refresh() {
        self.page = 1
        self.votes.removeAll()
        
        IMApi.instance.readVotes(mid, pindex: self.page, psize: 10) { (resp) in
            if resp.isSuccess {
                let marray = resp.Data!
                self.votes.append(contentsOf: marray)
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
        
        IMApi.instance.readVotes(mid, pindex: self.page, psize: 10) { (resp) in
            if resp.isSuccess {
                let marray = resp.Data!
                self.votes.append(contentsOf: marray)
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
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.votes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell") as! VoteCell
        
        let model = self.votes[indexPath.row]
        cell.setModel(model)
        
        return cell
    }

    // MARK: -
}

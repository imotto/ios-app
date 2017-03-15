//
//  HelpCenterController.swift
//  iMottoApp
//
//  Created by sunht on 16/9/30.
//  Copyright © 2016年 imotto. All rights reserved.
//

import UIKit

class HelpCenterController: UIViewController, UIWebViewDelegate {
    var explorer:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        
        backBtn.tintColor = COLOR_NAV_TINT
        
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationItem.title = "关于偶得"
        
        setupWebView()
    }
    
    func setupWebView() {
        let webView = UIWebView()
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let url = URL(string: URL_HELP_CENTER)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        webView.loadRequest(request)
        webView.delegate = self
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        ToastManager.shared.makeToastActivity(self.view)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ToastManager.shared.hideToastActivity()
    }
}

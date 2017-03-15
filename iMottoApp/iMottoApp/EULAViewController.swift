//
//  EULAViewController.swift
//  iMottoApp
//
//  Created by zhangkai on 25/12/2016.
//  Copyright © 2016 imotto. All rights reserved.
//

import UIKit

class EULAViewController: UIViewController, UIWebViewDelegate {
    var explorer:UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backBtn = UIBarButtonItem(image: ImgGoBack, style: .plain, target: self, action: #selector(navBackTapped))
        
        backBtn.tintColor = COLOR_NAV_TINT
        
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: NAV_BG_IMG) , for: .default)
        self.navigationItem.title = "用户协议"
        
        let webView = UIWebView()
        webView.delegate = self
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let url = URL(string: URL_EULA)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        ToastManager.shared.makeToastActivity(self.view)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ToastManager.shared.hideToastActivity()
    }

}

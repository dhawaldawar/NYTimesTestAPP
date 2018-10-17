//
//  ArticleDetailViewController.swift
//  Test-NYTimes
//
//  Created by Dhawal ideavate on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import UIKit
import WebKit

protocol ArticleDetailView : class{
    func showLoading()
    func showError(_ error : String)
    func loadWebViewWithURL(_ urlRequest : URLRequest)
}

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    @IBOutlet weak var viewError : UIView!
    @IBOutlet weak var lblError : UILabel!
    
    var configurator : ArticleDetailConfigurator!
    var viewModel : ArticleDetailViewModel!
    
    //MARK:- Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(view: self)
        viewModel.viewDidLoad()
        webView.navigationDelegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.stopLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Actions
    @IBAction func btnTryAgainTapped(){
        viewModel.loadRequest()
    }
}

extension ArticleDetailViewController : ArticleDetailView{
    func showLoading(){
        activity.isHidden = false
        viewError.isHidden = true
        webView.isHidden = false
    }
    
    func showWebView(){
        activity.isHidden = true
        webView.isHidden = false
    }
    
    func showError(_ error : String){
        activity.isHidden = true
        webView.isHidden = true
        viewError.isHidden = false
        lblError.text = error
    }
    
    func loadWebViewWithURL(_ urlRequest : URLRequest){
        webView.load(urlRequest)
    }
}

extension ArticleDetailViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        showWebView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        showError("We could not complete your request at the moment, please try again later")
    }
}

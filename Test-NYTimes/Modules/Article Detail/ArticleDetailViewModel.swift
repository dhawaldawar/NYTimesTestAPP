//
//  ArticleDetailViewModel.swift
//  Test-NYTimes
//
//  Created by Dhawal ideavate on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation

protocol ArticleDetailViewModel : class{
    func loadRequest()
    func viewDidLoad()
}

class ArticleDetailViewModelImplementation{
    private weak var view : ArticleDetailView!
    private var article : Article!
    
    init(view : ArticleDetailView, article : Article) {
        self.view = view
        self.article = article
    }
}

extension ArticleDetailViewModelImplementation : ArticleDetailViewModel{
    func viewDidLoad(){
        loadRequest()
    }
    
    func loadRequest() {
        if(!ReachabilityManager.shared.isInternetAvailable){
            view.showError("Internet is not available, please connect and try again.")
            return;
        }
        let request = URLRequest(url: article.webPageURL)
        view.loadWebViewWithURL(request)
    }
}

//
//  ArticleDetailConfigurator.swift
//  Test-NYTimes
//
//  Created by Dhawal ideavate on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation

protocol ArticleDetailConfigurator : class{
    func configure(view : ArticleDetailViewController)
}

// This class is responsible to configure all the dependencies like View, ModelView and API
class ArticleDetailConfiguratorImplementation : ArticleDetailConfigurator{
    
    private var article : Article!
    
    init(article : Article) {
        self.article = article
    }
    
    func configure(view : ArticleDetailViewController){
        let viewModel = ArticleDetailViewModelImplementation(view: view, article: article)
        view.viewModel = viewModel
    }
}

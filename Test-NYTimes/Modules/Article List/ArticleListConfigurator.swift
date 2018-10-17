//
//  ArticleListCordinator.swift
//  Test-NYTimes
//
//  Created by Dhawal ideavate on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation

protocol ArticleListConfigurator : class{
    func configure(view : ArticleListViewController)
}

// This class is responsible to configure all the dependencies like View, ModelView and API
class ArticleListConfiguratorImplementation : ArticleListConfigurator{
    
    
    func configure(view : ArticleListViewController){
        
        let apiClient = APIClientImplementation(urlSession: URLSession.shared)
        let api = ArticleFetchAPIImplementation(apiClient: apiClient)
        let imageDownloadManager = ImageDownloadManagerImplementation()
        
        let modelView = AirticleListViewModelImplementation.init(view: view, fetchAPI: api, imageDownloadManager: imageDownloadManager)
        view.viewModel = modelView
    }
}

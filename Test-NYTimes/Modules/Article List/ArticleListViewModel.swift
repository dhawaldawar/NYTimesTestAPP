//
//  ArticleListViewModel.swift
//  Test-NYTimes
//
//  Created by Dhawal ideavate on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleListViewModel : class{
    func numberOfRows() -> Int
    func displayInformationOnCell(cellView : ArticleListCellView, indexPath : IndexPath)
    func didTapOnTryAgain()
    func didSelectIndexpath(_ indexPath : IndexPath) -> ArticleDetailConfigurator
}

class AirticleListViewModelImplementation: ArticleListViewModel {
    private var arrArticles = [Article]()
    private weak var view : ArticleListView!
    private var fetchAPI : ArticleFetchAPI!
    private var imageDownloadManager : ImageDownloadManager!
    
    init(view: ArticleListView, fetchAPI: ArticleFetchAPI, imageDownloadManager : ImageDownloadManager) {
        self.view = view
        self.fetchAPI = fetchAPI
        self.imageDownloadManager = imageDownloadManager
        self.imageDownloadManager.delegate = self
        
        fetchArticles()
    }
    
    func numberOfRows() -> Int {
        return arrArticles.count
    }
    
    func displayInformationOnCell(cellView : ArticleListCellView, indexPath : IndexPath){
        cellView.indexPath = indexPath
        
        let article = arrArticles[indexPath.row]
        cellView.displayTitle(article.title)
        cellView.displayDate(article.date)
        cellView.displayPublishedBy(article.publishedBy)
        
        if(article.thumbnailURL != nil){
            if(article.thumbnail != nil){
                cellView.displayImage(article.thumbnail!)
            }else{
                imageDownloadManager.downloadImageWithURL(article.thumbnailURL!)
            }
        }
    }
    
    func didTapOnTryAgain(){
        fetchArticles()
    }
    
    func didSelectIndexpath(_ indexPath : IndexPath) -> ArticleDetailConfigurator{
        let article = arrArticles[indexPath.row]
        return ArticleDetailConfiguratorImplementation(article: article)
    }
    
    //MARK: API calling
    private func fetchArticles(){
        if(!ReachabilityManager.shared.isInternetAvailable){
            view.showError(error: "Internet is not available, please connect and try again.")
            return;
        }
        
        view.showLoading()
        let param = ArticleFetchParameters(section: "all-sections")
        fetchAPI.fetchArticles(param) {[weak self] (apiResponse : APIResponse<[Article]>) in
            switch apiResponse{
            case .success(let arrArticles):
                self!.handleSuccess(arrArticles: arrArticles)
                
            case .failure(let error):
                self!.handleFailure(error: error.localizedDescription)
            }
        }
    }
    
    private func handleSuccess(arrArticles : [Article]){
        DispatchQueue.main.async {[weak self] in
            self?.arrArticles = arrArticles
            self?.view.refreshList()
        }
    }
    
    private func handleFailure(error : String){
        DispatchQueue.main.async {[weak self] in
            self?.view.showError(error: error)
        }
    }
}

extension AirticleListViewModelImplementation : ImageDownloadDelegate{
    func didDownloadImage(image : UIImage, url : URL){
        DispatchQueue.main.async {[weak self] in
            let arr = self?.arrArticles.filter { (article) -> Bool in
                return article.thumbnailURL == url
            }
            
            if(arr!.count != 0){
                let article = arr![0]
                article.thumbnail = image
                self?.view.refreshList()
            }
        }
    }
}

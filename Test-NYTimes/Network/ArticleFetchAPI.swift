//
//  TaxiFetchAPI.swift
//  TestCases
//
//  Created by Dhawal Dawar on 23/09/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation
import CoreLocation

//MARK:-
struct ArticleFetchParameters{
    let section : String
}

//MARK:-

protocol ArticleFetchAPI : class{
    init(apiClient : APIClient)
    func fetchArticles(_ parameters : ArticleFetchParameters, completionHandler: @escaping ((_ arrArticles : APIResponse<[Article]>) -> Void))
}

//MARK:-
struct ArticleFetchAPIRequest : APIRequest{
    
    private var url : URL!
    
    init(_ parameters : ArticleFetchParameters) {
        let urlString = "\(APIUrl.fetchAPI)\(parameters.section)/7.json?api-key=9485de6d5bff4ddc99250a681596ba52"
        url = URL(string: urlString)
    }
    
    var urlRequest: URLRequest{
        return URLRequest(url: url)
    }
}

//MARK:-
struct ArticleFetchAPIParser : APIParser {
    func parseData(_ data : Data) throws -> [Article]{
        guard let responseDict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any] else{
            throw APIResponseError.parsingError
        }
        guard let status = responseDict["status"] as? String, let arrResults = responseDict["results"] as? [[String : Any]] else{
            throw APIResponseError.parsingError
        }
        if status == "OK"{
            let arrArticles = arrResults.compactMap(Article.init)
            return arrArticles
        }else{
            throw APIResponseError.parsingError
        }
    }
}

//MARK:-
class ArticleFetchAPIImplementation : NSObject , ArticleFetchAPI{
    
    private var apiClient : APIClient!
    private var completionHandler : ((_ arrArticles : APIResponse<[Article]>) -> Void)!
    
    required init(apiClient : APIClient){
        self.apiClient = apiClient
    }
    
    // This is only for Objective-C as APIClient class is not supported in it because of using generics.
    override init() {
        self.apiClient = APIClientImplementation(urlSession: URLSession.shared)
    }
    
    func fetchArticles(_ parameters : ArticleFetchParameters, completionHandler: @escaping ((_ arrArticles : APIResponse<[Article]>) -> Void)) {
        
        self.completionHandler = completionHandler
        
        let apiRequest = ArticleFetchAPIRequest(parameters)
        let apiParser = ArticleFetchAPIParser()
        
        apiClient.executeRequest(apiRequest: apiRequest, parser: apiParser) { [weak self](apiResponse : APIResponse<[Article]>) in
            self?.completionHandler(apiResponse)
        }
    }
}

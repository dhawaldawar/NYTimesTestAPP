//
//  VehicleFetchAPIMock.swift
//  MyTaxiTestCases
//
//  Created by Dhawal Dawar on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation

@testable import Test_NYTimes

class ArticleFetchAPIMock : ArticleFetchAPI{
    
    var showSuccessResponse = true
    
    required init(apiClient: APIClient) {
        
    }
    
    func fetchArticles(_ parameters : ArticleFetchParameters, completionHandler: @escaping ((_ arrArticles : APIResponse<[Article]>) -> Void)){
        if(showSuccessResponse){
            completionHandler(APIResponse.success([Article]()))
        }else{
            completionHandler(APIResponse.failure(APIResponseError.networkError))
        }
    }
    
}

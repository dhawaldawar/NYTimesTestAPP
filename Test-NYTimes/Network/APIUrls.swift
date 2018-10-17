//
//  APIUrls.swift
//  MyTaxiTest
//
//  Created by Dhawal Dawar on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation

enum APIDomain : String{
    case stagingServer = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/"
    case liveServer = "http://liveapi.nytimes.com/svc/mostpopular/v2/mostviewed/"
}

struct APIUrl {
    static let domain = APIDomain.stagingServer
    static let fetchAPI = "\(APIUrl.domain.rawValue)"
}

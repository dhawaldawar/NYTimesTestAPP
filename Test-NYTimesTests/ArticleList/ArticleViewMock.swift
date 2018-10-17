//
//  ArticleViewMock.swift
//  Test-NYTimesTests
//
//  Created by Dhawal ideavate on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation
@testable import Test_NYTimes

class ArticleListViewMock: ArticleListView {
    var refreshListCalled : Bool = false
    var showErrorCalled : Bool = false
    
    func refreshList() {
        refreshListCalled = true
    }
    
    func showError(error: String) {
        showErrorCalled = true
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    
}

//
//  ArticleListTestCase.swift
//  Test-NYTimesTests
//
//  Created by Dhawal ideavate on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import XCTest
@testable import Test_NYTimes


class ArticleListTestCase: XCTestCase {
    
    var api : ArticleFetchAPIMock!
    var view = ArticleListViewMock()
    var viewModel : ArticleListViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let apiClient = APIClientImplementation(urlSession: URLSessionStub())
        api = ArticleFetchAPIMock(apiClient: apiClient)
       
    }
    
    func test_articles_load_success(){
        api.showSuccessResponse = true
        viewModel = AirticleListViewModelImplementation(view: view, fetchAPI: api, imageDownloadManager: ImageDownloadManagerImplementation())
        
        let expect = expectation(description: "Expectation")
        DispatchQueue.main.async {[weak self] in
            XCTAssert(self!.view.refreshListCalled, "Refresh list method did not call")
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_articles_load_failure(){
        api.showSuccessResponse = false
        viewModel = AirticleListViewModelImplementation(view: view, fetchAPI: api, imageDownloadManager: ImageDownloadManagerImplementation())
        
        let expect = expectation(description: "Expectation")
        DispatchQueue.main.async {[weak self] in
            XCTAssert(self!.view.showErrorCalled, "Show error method did not call")
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

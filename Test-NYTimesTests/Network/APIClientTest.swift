//
//  APIClientTest.swift
//  MyTaxiTestCases
//
//  Created by Dhawal Dawar on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import XCTest

@testable import Test_NYTimes

class APIClientTest: XCTestCase {
    
    let urlSession = URLSessionStub()
    var apiClient : APIClient!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiClient = APIClientImplementation(urlSession: urlSession)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_successful_response() {
        let dicResponse = ["Key" : "Value"]
        let data = try! JSONSerialization.data(withJSONObject: dicResponse, options: .prettyPrinted)
        let httpResponse = HTTPURLResponse.init(url: URL.googleUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let response = URLDataTaskResponse(data: data, urlResponse: httpResponse, error: nil)
        
        urlSession.response = response
        
        let expectationSuccessfull = expectation(description: "expectation")
        
        apiClient.executeRequest(apiRequest: TestRequest(), parser: TestParser()) {(apiResponse : APIResponse<[String: String]>) in
            switch apiResponse{
            case .success(let dic):
                XCTAssertEqual(dic["Key"], "Value", "Expected value did not come.")
                
            case.failure(let error):
                XCTFail("Failure response recieved - Error: \(error)")
                
            }
            expectationSuccessfull.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_error_response() {
        let dicResponse = ["Key" : "Value"]
        let data = try! JSONSerialization.data(withJSONObject: dicResponse, options: .prettyPrinted)
        let httpResponse = HTTPURLResponse.init(url: URL.googleUrl, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let response = URLDataTaskResponse(data: data, urlResponse: httpResponse, error: nil)
        
        urlSession.response = response
        
        let expectationFailure = expectation(description: "expectation")
        
        apiClient.executeRequest(apiRequest: TestRequest(), parser: TestParser()) {(apiResponse : APIResponse<[String: String]>) in
            switch apiResponse{
            case .success(_):
                XCTFail("Successfull response should have not been returned.)")
            case.failure(_):
                expectationFailure.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_parsing_error_response() {
        let dicResponse = ["Value"]
        let data = try! JSONSerialization.data(withJSONObject: dicResponse, options: .prettyPrinted)
        let httpResponse = HTTPURLResponse.init(url: URL.googleUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let response = URLDataTaskResponse(data: data, urlResponse: httpResponse, error: nil)
        
        urlSession.response = response
        
        let expectationFailure = expectation(description: "expectation")
        
        apiClient.executeRequest(apiRequest: TestRequest(), parser: TestParser()) {(apiResponse : APIResponse<[String: String]>) in
            switch apiResponse{
            case .success(_):
                XCTFail("Successfull response should have not been returned.)")
            case.failure(let error):
                switch error{
                case APIResponseError.parsingError:
                    expectationFailure.fulfill()
                default:
                    XCTFail("Only parsing error response should have been returned.)")
                }
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}

extension URL {
    static var googleUrl: URL {
        return URL(string: "https://www.google.com")!
    }
}

private struct TestRequest : APIRequest {
    var urlRequest: URLRequest{
        return URLRequest(url: URL.googleUrl)
    }
}

private struct TestParser : APIParser{
    func parseData(_ data : Data) throws -> [String: Any]{
        guard let responseDict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any] else{
            throw APIResponseError.parsingError
        }
        return responseDict
    }
}

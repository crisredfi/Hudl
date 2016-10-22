//
//  MockURLSession.swift
//  Hudl
//
//  Created by Aleix Guri on 22/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import XCTest
@testable import Hudl

class MockURLSession: URLSessionProtocol {

    private (set) var lastURL: NSURL?
    var nextDataTask = URLSessionDataTaskMock()
    var nextURLResponse: URLResponse?
    var nextDataResponse: Data?

    func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult)
        -> URLSessionDataTask {
        lastURL = url
        return URLSessionDataTask()
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        completionHandler(nextDataResponse, nextURLResponse, nextDataTask.error)
        return nextDataTask
    }

    func dataTask(with request: URLRequest) -> URLSessionDataTask {
        return nextDataTask
    }

}

//
//  URLSessionDataTaskMock.swift
//  Hudl
//
//  Created by Aleix Guri on 22/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//
import XCTest
@testable import Hudl

protocol URLSessionDataTaskProtocol {
    func resume()
}
extension URLSessionDataTask: URLSessionDataTaskProtocol { }

enum TestError: Error {
    case defaultError

}

class URLSessionDataTaskMock: URLSessionDataTask {

    override var taskIdentifier: Int {
        get {
            return _taskIdentifier
        }
        set {
            _taskIdentifier = newValue
        }
    }
    var _taskIdentifier = 0

    override init() {
        super.init()

        taskIdentifier = Int(arc4random())
    }

    private (set) var resumeWasCalled = false

    override func resume() {
        resumeWasCalled = true
    }

    override var error: Error? {
        get {
            return _error
        }
        set {
            _error = newValue
        }
    }

    var _error: Error? = nil
}

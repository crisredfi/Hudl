//
//  HTTPService.swift
//  Hudl
//
//  Created by Aleix Guri on 18/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//
import UIKit

private let kLoginBaseURL = "https://www.googleapis.com/youtube/v3/"
private let apiKey = "AIzaSyC5OHZkDYt6A9igTuVBadYigPw8VFnkqLg"

// I will use NSURLSession/shared session since its already a singleton
// and here I dont need to create a specific session configuration. 

// this is for Unit testing purposes. Protocol oriented
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
    func dataTask(with request: URLRequest) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

enum httpserviceError: Error {
    case urlFormatError
}


class HTTPService {

    let session: URLSessionProtocol
    let baseURL: URL

    init(session: URLSessionProtocol = URLSession.shared ) {
        self.session = session
        self.baseURL = URL(string: kLoginBaseURL)!

    }

    func getChannelId(forCategory category: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let urlString = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&forUsername=\(category)&key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            // return an error
            completionHandler(nil, nil, httpserviceError.urlFormatError)
            return
        }
        let request = NSMutableURLRequest(url: url)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            completionHandler(data, response, error)
        }

        task.resume()
    }

    func getVideos(fromChannelId channelId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(channelId)&key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            // return an error
            completionHandler(nil, nil, httpserviceError.urlFormatError)
            return
        }
        let request = NSMutableURLRequest(url: url)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            completionHandler(data, response, error)
        }

        task.resume()
    }
}

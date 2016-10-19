//
//  VideoModel.swift
//  Hudl
//
//  Created by Aleix Guri on 19/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import Foundation

enum videoModelError: Error {
    case jsonMalformed
}

struct VideoModel {

    var kind: String
    var etag: String
    var id: String
    var publishedAt: String // convert to Date
    var channelId: String
    var title: String
    var description: String



    init?(data: [String: AnyObject]?) throws {

        guard let json = data else {
            throw videoModelError.jsonMalformed
        }

        if let

    }
}

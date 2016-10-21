//
//  ThumbmailModel.swift
//  Hudl
//
//  Created by Aleix Guri on 19/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

enum thumbmailError: Error {
    case missingData
}

struct ThumbmailModel {
    var url: String
    var width: Int
    var height: Int

    init(url: String, width: Int, height:Int) {
        self.url = url
        self.width = width
        self.height = height
    }

    init?(data: [String: AnyObject]?) throws {
        guard let url = data?["url"] as? String,
            let width = data?["width"] as? Int, // cast just in case
            let height = data?["height"] as? Int else {
                throw thumbmailError.missingData
        }
        self.url = url
        self.width = width
        self.height = height
    }
}

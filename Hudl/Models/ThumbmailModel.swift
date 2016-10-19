//
//  ThumbmailModel.swift
//  Hudl
//
//  Created by Aleix Guri on 19/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import Foundation

struct ThumbmailModel {
    var url: String
    var width: Int
    var heigh: Int

    init?(data: [String: AnyObject]!) {
        guard let url = data["url"] as? String,
            let width = data["width"] as? Int, // cast just in case
            let heigh = data["heigh"] as? Int else {
                return
        }
        self.url = url
        self.width = width
        self.heigh = heigh
    }
}

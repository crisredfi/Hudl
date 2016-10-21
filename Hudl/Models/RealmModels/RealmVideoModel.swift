//
//  RealmVideoModel.swift
//  Hudl
//
//  Created by Aleix Guri on 21/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import RealmSwift

class RealmVideoModel: Object {

    dynamic var title: String = ""
    dynamic var videoDescription: String = ""
    dynamic var publishedAt: String = ""
    dynamic var videoId: String = ""
    var thumbnails = List<RealmThumbnailModel>()

    override class func primaryKey() -> String {
        return "videoId"
    }
}

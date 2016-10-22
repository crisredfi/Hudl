//
//  RealmThumbnailModel.swift
//  Hudl
//
//  Created by Aleix Guri on 21/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import RealmSwift

class RealmThumbnailModel: Object {

    dynamic var url: String = ""
    dynamic var width: Int = 0
    dynamic var height: Int = 0

    override class func primaryKey() -> String {
        return "url"
    }

}

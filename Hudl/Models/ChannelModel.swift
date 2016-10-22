//
//  ChannelModel.swift
//  Hudl
//
//  Created by Aleix Guri on 19/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import Foundation

private let kItemsKey = "items"
private let kContentDetailsKey = "contentDetails"
private let kRelatedPlaylistsKey = "relatedPlaylists"
private let kUploadsKeyKey = "uploads"

enum ChannelError: Error {
    case channelParsingError
    case defaultError
}


struct ChannelModel {

    var uploads: String

    init?(data: [String: AnyObject]?) throws {

        guard let json = data,
            // check for content details
            let items = json[kItemsKey] as? [AnyObject],
            // get the first object.
            let item = items[0] as? [String: AnyObject],
            // obtain Content details dictionary
            let contentDetails = item[kContentDetailsKey] as? [String: AnyObject],
            // check for related playlists
            let relatedPlaylist = contentDetails[kRelatedPlaylistsKey] as? [String: AnyObject],
            // get uploads value for playlist ID
            let uploads = relatedPlaylist[kUploadsKeyKey] as? String else {
                throw ChannelError.channelParsingError
        }

        self.uploads = uploads
    }

}

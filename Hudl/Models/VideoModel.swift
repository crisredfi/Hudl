//
//  VideoModel.swift
//  Hudl
//
//  Created by Aleix Guri on 19/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import Foundation

enum VideoModelError: Error {
    case jsonMalformed
}

struct VideoModel {

    var kind: String?
    var etag: String?
    var id: String?
    var publishedAt: String? // convert to Date
    var channelId: String?
    var title: String?
    var description: String?
    var thumnbnails: [ThumbmailModel] = [ThumbmailModel]()
    var videoId: String?

    init(title:String, description:String, thumbnails:[ThumbmailModel], publishedAt: String, videoId: String, kind: String = "", etag: String = "", id: String = "", channelId: String = "") {
        self.title = title
        self.description = description
        self.thumnbnails = thumbnails
        self.publishedAt = publishedAt
        self.videoId = videoId
    }

    init?(data: [String: AnyObject]?) throws {

        guard let json = data else {
            throw VideoModelError.jsonMalformed
        }
        // now we want to check if values are in the JSON.
        // since I believe that Youtube might not return some values sometimes.
        // I wont use guard for early exit. will use if let instead.

        // youtube main values
        self.kind = json["kind"] as? String
        self.etag = json["etag"] as? String
        self.id = json["id"] as? String
        // video infromation
        if let snippet = json["snippet"] as? [String: AnyObject] {
            self.publishedAt = snippet["publishedAt"] as? String
            self.channelId = snippet["channelId"] as? String
            self.title = snippet["title"] as? String
            self.description = snippet["description"] as? String
            // parse all possible pictures
            if let thumbnailList = snippet["thumbnails"] as? [String: AnyObject] {
                for (_, thumbnail) in thumbnailList {
                    if let newThumbnail = try ThumbmailModel(data: thumbnail as? [String: AnyObject]) {
                        self.thumnbnails.append(newThumbnail)
                    }
                }
            }
            // get the video id. this is probably the hash we need to play videos.
            if let resourceId = snippet["resourceId"] as? [String: AnyObject] {
                self.videoId = resourceId["videoId"] as? String
            }
        }
    }

}

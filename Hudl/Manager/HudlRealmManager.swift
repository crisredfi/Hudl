//
//  HudlRealmManager.swift
//  Hudl
//
//  Created by Aleix Guri on 21/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import RealmSwift

class HudlRealmManager {

    // Realm has to be declared with try!. if something fails,
    // they say you can not recover from that failure.
    static let realm = try! Realm()

    class func saveViewModelToRealm(_ videoModel: VideoModel) {
        let newHudlRealmViewModel = RealmVideoModel()
        guard let videoTitle = videoModel.title,
            let videoDescription  = videoModel.description,
            let videoPublicationDate = videoModel.publishedAt,
            let videoId = videoModel.videoId else {
                return
        }
        newHudlRealmViewModel.title = videoTitle
        newHudlRealmViewModel.videoDescription = videoDescription
        newHudlRealmViewModel.publishedAt = videoPublicationDate
        newHudlRealmViewModel.videoId = videoId

        for thumbnail in videoModel.thumnbnails {
            let newThumbnail = RealmThumbnailModel()
            newThumbnail.url = thumbnail.url
            newThumbnail.height = thumbnail.height
            newThumbnail.width = thumbnail.width
            newHudlRealmViewModel.thumbnails.append(newThumbnail)
        }

        try? realm.write {
            realm.add(newHudlRealmViewModel, update: true)
        }

    }

    class func getViewModelFromRealm() -> [VideoModel] {

        let realmYoutubeVideoList = realm.objects(RealmVideoModel.self)
        var modeledVideos = [VideoModel]()
        // Map them back to ViewModel
        for realmVideo in realmYoutubeVideoList {
            var thumbnails = [ThumbmailModel]()
            for (_, thumbnail) in realmVideo.thumbnails.enumerated() {
                let newThumbnail = ThumbmailModel.init(url: thumbnail.url, width: thumbnail.width, height: thumbnail.height)
                thumbnails.append(newThumbnail)
            }
            let newVideoModel = VideoModel.init(title: realmVideo.title, description: realmVideo.videoDescription, thumbnails: thumbnails, publishedAt: realmVideo.publishedAt,videoId: realmVideo.videoId)
            modeledVideos.append(newVideoModel)
        }

        return modeledVideos
    }

}

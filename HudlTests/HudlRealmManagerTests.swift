//
//  HudlRealmManagerTests.swift
//  Hudl
//
//  Created by Aleix Guri on 22/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import XCTest
@testable import Hudl

class HudlRealmManagerTests: XCTestCase {
    var videoModel: VideoModel!
    var thumbnail: ThumbmailModel!

    override func setUp() {
        super.setUp()
        thumbnail  = ThumbmailModel.init(url: "url", width: 12, height: 12)
        videoModel = VideoModel.init(title: "my video",
                                     description: "some description",
                                     thumbnails: [thumbnail],
                                     publishedAt: "today",
                                     videoId: "12345")

    }

    func test_savRetrieveAndDeleteFromDatabase() {
        HudlRealmManager.saveViewModelToRealm(videoModel)
        // we can now know if this has been stored.
        XCTAssertTrue(HudlRealmManager.isIdAlreadyHighlighted(videoId: videoModel.videoId!))

        let savedItems = HudlRealmManager.getViewModelFromRealm()
        let filteredArray = savedItems.filter { $0.videoId == videoModel.videoId }
        XCTAssertTrue(filteredArray.count == 1)
        HudlRealmManager.removeModelFromRealm(videoModel)

        let newSavedItems = HudlRealmManager.getViewModelFromRealm()
        let newFilteredArray =  newSavedItems.filter { $0.videoId == videoModel.videoId }
        XCTAssertTrue(newFilteredArray.count == 0)
        XCTAssertFalse(HudlRealmManager.isIdAlreadyHighlighted(videoId: videoModel.videoId!))

    }

}

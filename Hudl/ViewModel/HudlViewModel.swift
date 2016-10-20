//
//  HudlViewModel.swift
//  Hudl
//
//  Created by Aleix Guri on 19/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import Foundation

protocol HudlViewModelProtocol {
    func didReceiveNewContentData() // this will trigger a UI update
}

enum HudlViewError: Error {
    case indexOutOfBounds
}

class HudlViewModel {

    let networkConnection = HTTPService()
    var youtubeVideos: Array<VideoModel>

    var delegate: HudlViewModelProtocol?

    init() {
        youtubeVideos = [VideoModel]()
        getYoutubeChannelVideos()
    }

    func getItemAtIndex(index: Int) throws -> VideoModel {
        if youtubeVideos.indices.contains(index) {
            return youtubeVideos[index]
        }
        throw HudlViewError.indexOutOfBounds
    }

    func getNumberOfItems() -> Int {
        return youtubeVideos.count
    }

    //MARK: data fetcher methods

    fileprivate func getYoutubeChannelVideos() {
        networkConnection.getChannelId(forCategory: "HudlStudios", completionHandler: {[unowned self] (data, response, error) in
            if let _ = error {
                // error. early exit. should crete a throw for error cases or call for an alert view.
                return
            }

            if let channelData = data {
                do {
                    guard let jsonWithObjectRoot = try? JSONSerialization.jsonObject(with: channelData, options: []),
                        let channelModel = try ChannelModel.init(data: jsonWithObjectRoot as? [String: AnyObject]) else {
                            return
                    }
                    self.getVideosForChannelUploadsIdentifier(channelModel.uploads)
                } catch (ChannelError.channelParsingError) {

                } catch (ChannelError.defaultError) {

                } catch {

                }

            }

            })
    }

    fileprivate func getVideosForChannelUploadsIdentifier(_ uploads: String) {
        self.networkConnection.getVideos(fromChannelId: uploads, completionHandler: { [unowned self] (data, response, error) in
            if let _ = error {
                // error. early exit. should crete a throw for error cases or call for an alert view.
                return
            }
            if let videoData = data {
                do {
                    guard let jsonWithObjectRoot = try JSONSerialization.jsonObject(with: videoData, options: []) as? [String: AnyObject],
                        let items = jsonWithObjectRoot["items"] as? [AnyObject] else {
                            return
                    }

                    for item in items {
                        if let videoModel = try VideoModel.init(data: item as? [String : AnyObject]) {
                            self.youtubeVideos.append(videoModel)
                        }
                    }
                    // NSURLSession runs in background threads. Hence we need to update the UI in Main thread.
                    // View controller only handles the view, so is the viewModel the one handling the thread update
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveNewContentData()
                    }
                } catch {
                }
            }
            })
    }

    
}

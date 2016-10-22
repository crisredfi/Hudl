//
//  HudlViewModel.swift
//  Hudl
//
//  Created by Aleix Guri on 19/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import Foundation

fileprivate let kYoutubChannelCategorySearch = "HudlStudios"

protocol HudlViewModelProtocol {
    func didReceiveNewContentData() // this will trigger a UI update
}

enum HudlViewError: Error {
    case indexOutOfBounds
    case wrongChannelParsing
    case wrongVideoParsing
}

enum ModelViewStatus {
    case youtubeFiles
    case favouritesFiles
}

class HudlViewModel {

    let networkConnection = HTTPService()
    var youtubeVideos: Array<VideoModel>
    var currentModelState: ModelViewStatus = .youtubeFiles

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

    func getFavouritesVideos() {
        youtubeVideos.removeAll()
        switch currentModelState {
        case .youtubeFiles:
            currentModelState = .favouritesFiles
            youtubeVideos.append(contentsOf: HudlRealmManager.getViewModelFromRealm())
            self.delegate?.didReceiveNewContentData()
        case .favouritesFiles:
            currentModelState = .youtubeFiles
            getYoutubeChannelVideos()
        }
    }

    //MARK: data fetcher private methods

    fileprivate func getYoutubeChannelVideos() {
        networkConnection.getChannelId(forCategory: kYoutubChannelCategorySearch, completionHandler: {[unowned self] (data, response, error) in
            if let _ = error {
                // error. early exit. should crete a throw for error cases or call for an alert view.
                return
            }
            if let channelData = data {
                do {
                    try self.parseChannelsData(channelData: channelData)
                } catch {
                    // catch the parsing error.
                }
            }

            })
    }

    internal func parseChannelsData(channelData: Data) throws {
        do {
            guard let jsonWithObjectRoot = try? JSONSerialization.jsonObject(with: channelData, options: []),
                let channelModel = try ChannelModel.init(data: jsonWithObjectRoot as? [String: AnyObject]) else {
                    throw HudlViewError.wrongChannelParsing
            }
            self.getVideosForChannelUploadsIdentifier(channelModel.uploads)
        } catch (ChannelError.channelParsingError) {
            // error parsing. should create an alert view or some UI feedback

        } catch (ChannelError.defaultError) {
            // error with Channel. should create an alert view or some UI feedback
            throw HudlViewError.wrongChannelParsing
        } catch {
            // error. should create an alert view or some UI feedback
            throw HudlViewError.wrongChannelParsing
        }
    }

    internal func parseVideosForChannel(videoData: Data) throws {
        guard let jsonWithObjectRoot = try JSONSerialization.jsonObject(with: videoData, options: []) as? [String: AnyObject],
            let items = jsonWithObjectRoot["items"] as? [AnyObject] else {
                throw HudlViewError.wrongVideoParsing
        }
        do {
            for item in items {
                if let videoModel = try VideoModel.init(data: item as? [String : AnyObject]) {
                    self.youtubeVideos.append(videoModel)
                } else {
                    throw HudlViewError.wrongVideoParsing
                }
            }
            // NSURLSession runs in background threads. Hence we need to update the UI in Main thread.
            // View controller only handles the view, so is the viewModel the one handling the thread update
            DispatchQueue.main.async {
                self.delegate?.didReceiveNewContentData()
            }
        } catch {
            throw HudlViewError.wrongVideoParsing
        }
    }

    fileprivate func getVideosForChannelUploadsIdentifier(_ uploads: String) {
        self.networkConnection.getVideos(fromChannelId: uploads, completionHandler: { [unowned self] (data, response, error) in
            if let _ = error {
                // error. early exit. should crete a throw for error cases or call for an alert view.
                return
            }
            if let videoData = data {
                do {
                    try self.parseVideosForChannel(videoData: videoData)
                } catch {
                    // error. early exit. should crete a throw for error cases or call for an alert view.
                }
            }
            })
    }
    
}

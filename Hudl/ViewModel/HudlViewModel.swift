//
//  HudlViewModel.swift
//  Hudl
//
//  Created by Aleix Guri on 19/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import Foundation


class HudlViewModel {

    let networkConnection = HTTPService()
    var youtubeVideos: Array<VideoModel>

    init() {
        youtubeVideos = [VideoModel]()
        getYoutubeChannelVideos()
    }

    fileprivate func getYoutubeChannelVideos() {
        networkConnection.getChannelId(forCategory: "FCBarcelona", completionHandler: {[unowned self] (data, response, error) in
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
                } catch {
                }
            }
            })
    }
    
}

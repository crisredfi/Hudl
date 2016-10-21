//
//  HudlCell.swift
//  Hudl
//
//  Created by Aleix Guri on 18/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import UIKit
import SDWebImage


class HudlCell: UICollectionViewCell {

    @IBOutlet weak var youtubeImage: UIImageView!

    @IBOutlet weak var youtubeTitle: UILabel!

    @IBOutlet weak var youtubeSubtitle: UILabel!

    @IBOutlet weak var youtubeFavourite: UIButton!

    var videoModel: VideoModel?

    func setupCell(videoModel: VideoModel?) {
        self.videoModel = videoModel
        youtubeTitle?.text = videoModel?.title ?? ""
        youtubeSubtitle?.text = videoModel?.publishedAt
        let imageManager = SDWebImageManager.shared()
        // reset the possible image from recicled cell.
        youtubeImage?.image = nil
        if let imageURLString = videoModel?.thumnbnails.last?.url {

            let imageURL = URL(string: imageURLString)
            _ = imageManager?.downloadImage(with: imageURL , options: SDWebImageOptions.refreshCached, progress: nil) {
                (image, ErrorType, cacheType, bool, imageURL) -> Void in
                self.youtubeImage?.image = image
            }
        }
    }

    @IBAction func didPressFavouriteButton() {

        // video model exist, if not, the cell would have crashed before.
        // hence we are fully secure to call "!" instead to guard the videoModel.
        HudlRealmManager.saveViewModelToRealm(videoModel!)
    }

}

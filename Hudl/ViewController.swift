//
//  ViewController.swift
//  Hudl
//
//  Created by Aleix Guri on 18/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let kCellMargins: CGFloat = 30

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HudlViewModelProtocol {
    @IBOutlet weak var hudlCollectionView: UICollectionView!

    fileprivate let reuseIdentifier = "hudlCell"
    fileprivate var hudlViewModel: HudlViewModel?

    override func awakeFromNib() {
        hudlViewModel = HudlViewModel()
        hudlViewModel?.delegate = self
    } 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 98, height: 34) )
        imageView.image = UIImage.init(named: "hudl-logo-light")
        imageView.contentMode = .scaleAspectFit

        navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: collection view data source
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hudlViewModel?.getNumberOfItems() ?? 0
    }


    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! HudlCell
        cell.backgroundColor = UIColor.black
        // Configure the cell

        if let videoModel = try? hudlViewModel?.getItemAtIndex(index: indexPath.row) {
            cell.youtubeTitle?.text = videoModel?.title ?? ""
            cell.youtubeSubtitle?.text = videoModel?.publishedAt
            let imageManager = SDWebImageManager.shared()
            // reset the possible image from recicled cell.
            cell.youtubeImage?.image = nil
            if let imageURLString = videoModel?.thumnbnails.last?.url {

                let imageURL = URL(string: imageURLString)
                _ = imageManager?.downloadImage(with: imageURL , options: SDWebImageOptions.refreshCached, progress: nil) {
                    (image, ErrorType, cacheType, bool, imageURL) -> Void in
                    cell.youtubeImage?.image = image
                }
            }
        }

        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    // lets modify the width of the collection view for iphones to fit full screen
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            width = width / 2
            break
        default:
            break
        }

        return CGSize(width: width - kCellMargins, height: CGFloat(185))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let flowLayout = hudlCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        flowLayout.invalidateLayout()
    }

    // MARK: HudlViewModelDelegate
    func didReceiveNewContentData() {
        hudlCollectionView.reloadData()
    }
}


//
//  ViewController.swift
//  Hudl
//
//  Created by Aleix Guri on 18/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

fileprivate let kCellMargins: CGFloat = 30

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HudlViewModelProtocol {
    @IBOutlet weak var hudlCollectionView: UICollectionView!
    @IBOutlet weak var favouritesBarItem: UIBarButtonItem!

    fileprivate let reuseIdentifier = "hudlCell"
    fileprivate var hudlViewModel: HudlViewModel!

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

    // MARK: collection data state

    @IBAction func didPressBarButtonItem(_ sender: AnyObject) {
        hudlViewModel.getFavouritesVideos()
    }


    // MARK: collection view data source
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hudlViewModel.getNumberOfItems()
    }


    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! HudlCell
        cell.backgroundColor = UIColor.black
        // Configure the cell

        if let videoModel = try? hudlViewModel.getItemAtIndex(index: indexPath.row) {
            cell.setupCell(videoModel: videoModel)
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HudlCell
        guard let videoId = cell.videoModel?.videoId,
            let videoURL = URL(string: "http://www.youtube.com/watch?v=\(videoId)") else {
            return
        }
        // use 3rd party library to obtain real youtube URL
        Youtube.h264videosWithYoutubeURL(videoURL) { (videoInfo, error) -> Void in
            if let videoURLString = videoInfo?["url"] as? String {
                let videoURL = NSURL(string: videoURLString)
                DispatchQueue.main.async {
                    let playerViewController = PlayerViewController()
                    playerViewController.videoURL = videoURL as URL!
                    self.navigationController?.present(playerViewController, animated: true, completion: nil)
                }
            }
        }
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

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        guard let flowLayout = hudlCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        flowLayout.invalidateLayout()
    }

    // MARK: HudlViewModelDelegate
    func didReceiveNewContentData() {
        // at this point. hudlViewModel is known that exist.
        switch hudlViewModel.currentModelState {
        case ModelViewStatus.youtubeFiles:
            favouritesBarItem.title = "Favourite"
        case ModelViewStatus.favouritesFiles:
            favouritesBarItem.title = "List"
        }
        hudlCollectionView.reloadData()
    }
}


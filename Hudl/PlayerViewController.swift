//
//  PlayerViewController.swift
//  Hudl
//
//  Created by Aleix Guri on 21/10/2016.
//  Copyright © 2016 Aleix Guri. All rights reserved.
//

import AVKit
import AVFoundation

class PlayerViewController: UIViewController {

    var avPlayerViewController: AVPlayerViewController!
    var avPlayer: AVPlayer!
    var videoURL: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        let player = AVPlayer(url: videoURL as URL)

        // set up a really basic VC to handle the AVPlayer
        avPlayerViewController = AVPlayerViewController()
        avPlayerViewController.player = player
        addChildViewController(avPlayerViewController)
        view.addSubview(avPlayerViewController.view)
        avPlayerViewController.view.frame = self.view.frame
        player.play()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

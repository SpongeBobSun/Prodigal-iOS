//
//  InfoCenterHelper.swift
//  Prodigal
//
//  Created by bob.sun on 27/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import MediaPlayer

import Holophonor

class InfoCenterHelper: NSObject {
    static let helper: InfoCenterHelper = {
        let ret = InfoCenterHelper()
        return ret
    }()
    
    static fileprivate var iTunesDict: [String: Any] = [
        MPMediaItemPropertyTitle: "",
        MPMediaItemPropertyArtist: "",
        MPMediaItemPropertyAlbumTitle: "",
        MPNowPlayingInfoPropertyPlaybackRate: 1.0,
        MPMediaItemPropertyPlaybackDuration: 0,
        MPNowPlayingInfoPropertyElapsedPlaybackTime: 0,
    ]
    
    func update(withItem item: MediaItem, elapsed: TimeInterval = 0) {
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyTitle] = item.title ?? ""
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyArtist] = item.artist ?? ""
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyAlbumTitle] = item.albumTitle ?? ""
        InfoCenterHelper.iTunesDict[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyPlaybackDuration] = item.duration
        InfoCenterHelper.iTunesDict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsed

        guard let img = item.getArtworkWithSize(size: CGSize(width: 800, height: 800)) else {
            InfoCenterHelper.iTunesDict.removeValue(forKey: MPMediaItemPropertyArtwork)
            MPNowPlayingInfoCenter.default().nowPlayingInfo = InfoCenterHelper.iTunesDict
            return
        }
        let artwork = MPMediaItemArtwork.init(boundsSize: CGSize(width: 800, height: 800)) { (size) -> UIImage in
            return img
        }
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyArtwork] = artwork
        MPNowPlayingInfoCenter.default().nowPlayingInfo = InfoCenterHelper.iTunesDict
    }
}

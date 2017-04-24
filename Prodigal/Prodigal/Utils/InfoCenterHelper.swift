//
//  InfoCenterHelper.swift
//  Prodigal
//
//  Created by bob.sun on 27/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import MediaPlayer

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
    
    func update(withItem item: MPMediaItem, elapsed: TimeInterval = 0) {
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyTitle] = item.title ?? ""
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyArtist] = item.artist ?? ""
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyAlbumTitle] = item.albumTitle ?? ""
        InfoCenterHelper.iTunesDict[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyPlaybackDuration] = item.playbackDuration
        InfoCenterHelper.iTunesDict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsed

        guard let img = item.artwork else {
            InfoCenterHelper.iTunesDict.removeValue(forKey: MPMediaItemPropertyArtwork)
            MPNowPlayingInfoCenter.default().nowPlayingInfo = InfoCenterHelper.iTunesDict
            return
        }
        InfoCenterHelper.iTunesDict[MPMediaItemPropertyArtwork] = img
        MPNowPlayingInfoCenter.default().nowPlayingInfo = InfoCenterHelper.iTunesDict
    }
    
    func update(withFile file: MediaItem, elapsed: TimeInterval = 0) {
        let dict: [String: Any] = [
            MPMediaItemPropertyTitle: file.name,
            MPMediaItemPropertyArtist: "",
            MPMediaItemPropertyAlbumTitle: "",
            MPNowPlayingInfoPropertyPlaybackRate: 1.0,
//            MPMediaItemPropertyPlaybackDuration: item.playbackDuration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: elapsed,
            ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = dict

    }
}

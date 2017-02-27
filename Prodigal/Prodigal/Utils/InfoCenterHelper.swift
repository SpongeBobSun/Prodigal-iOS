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
    
    func update(withItem item: MPMediaItem) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: item.title ?? "",
            MPMediaItemPropertyArtist: item.artist ?? "",
            MPMediaItemPropertyAlbumTitle: item.albumTitle ?? "",
            MPNowPlayingInfoPropertyPlaybackRate: 1.0
            
        ]
    }
}

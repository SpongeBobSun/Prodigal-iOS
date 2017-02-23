//
//  MenuMeta.swift
//  Prodigal
//
//  Created by bob.sun on 23/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit

class MenuMeta: NSObject {
    enum MenuType {
        case Artists
        case Albums
        case Coverflow
        case Songs
        case Playlist
        case Genres
        case ShuffleSongs
        case Settings
        case NowPlaying
        case About
        case ShuffleSettings
        case RepeatSettings
        case GetSourceCode
        case ContactUs
    }
    
    var itemName: String!
    var highLight: Bool = false
    var type: MenuType!
    
    convenience init(name: String, type: MenuType) {
        self.init()
        self.itemName = name
        self.type = type
    }
}

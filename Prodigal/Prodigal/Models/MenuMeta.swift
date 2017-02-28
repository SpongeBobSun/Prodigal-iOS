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
        case Songs
        case Song
        case Album
        case Artist
        case CoverGallery
        case Playlist
        case Genres
        case Genre
        case ShuffleSongs
        case Settings
        case NowPlaying
        case About
        case ShuffleSettings
        case RepeatSettings
        case GetSourceCode
        case ContactUs
        case Undefined
    }
    
    var itemName: String!
    var highLight: Bool = false
    var type: MenuMeta.MenuType = .Undefined
    var object: Any?
    
    convenience init(name: String, type: MenuType) {
        self.init()
        self.itemName = name
        self.type = type
        object = nil
    }
    
    func setObject(obj: Any) -> MenuMeta {
        object = obj
        return self
    }
}

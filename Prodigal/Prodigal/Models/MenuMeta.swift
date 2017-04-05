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
        case LocalSongs
        case LocalSong
        case ShuffleSongs
        case ShuffleCurrent
        case Settings
        case NowPlaying
        case NowPlayingPopSeek
        case NowPlayingDoSeek
        case About
        case ShuffleSettings
        case RepeatSettings
        case ThemeSettings
        case GetSourceCode
        case Themes
        case Theme
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
    
    static func settingsMenu() -> Array<MenuMeta> {
        var ret:Array<MenuMeta> = []
        ret.append(MenuMeta(name: NSLocalizedString("Shuffle", comment: ""), type: .ShuffleSettings))
        ret.append(MenuMeta(name: NSLocalizedString("Repeat", comment: ""), type: .RepeatSettings))
        ret.append(MenuMeta(name: NSLocalizedString("Theme", comment: ""), type: .ThemeSettings))
        ret.append(MenuMeta(name: NSLocalizedString("About", comment: ""), type: .About))
        
        return ret
    }
}

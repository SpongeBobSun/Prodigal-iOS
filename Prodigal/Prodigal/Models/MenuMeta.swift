//
//  MenuMeta.swift
//  Prodigal
//
//  Created by bob.sun on 23/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

/**   Copyright 2017 Bob Sun
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *  Created by bob.sun on 23/02/2017.
 *
 *          _
 *         ( )
 *          H
 *          H
 *         _H_
 *      .-'-.-'-.
 *     /         \
 *    |           |
 *    |   .-------'._
 *    |  / /  '.' '. \
 *    |  \ \ @   @ / /
 *    |   '---------'
 *    |    _______|
 *    |  .'-+-+-+|              I'm going to build my own APP with blackjack and hookers!
 *    |  '.-+-+-+|
 *    |    """""" |
 *    '-.__   __.-'
 *         """
 **/


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
        case MoreTheme
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

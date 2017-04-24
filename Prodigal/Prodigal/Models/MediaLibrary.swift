//
//  MediaLibrary.swift
//  Prodigal
//
//   Copyright 2017 Bob Sun
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//  Created by bob.sun on 28/03/2017.
//
//          _
//         ( )
//          H
//          H
//         _H_
//      .-'-.-'-.
//     /         \
//    |           |
//    |   .-------'._
//    |  / /  '.' '. \
//    |  \ \ @   @ / /
//    |   '---------'
//    |    _______|
//    |  .'-+-+-+|              I'm going to build my own APP with blackjack and hookers!
//    |  '.-+-+-+|
//    |    """""" |
//    '-.__   __.-'
//         """
//


import UIKit
import MediaPlayer

class MediaLibrary: NSObject {
    
    var authorized: Bool
    
    static let sharedInstance : MediaLibrary = {
        let ret = MediaLibrary()
        return ret
    }()
    
    override init() {
        authorized = MPMediaLibrary.authorizationStatus() == .authorized ||
            MPMediaLibrary.authorizationStatus() == .restricted
        super.init()
        if !authorized {
            MPMediaLibrary.requestAuthorization({ (result) in
                self.authorized = result == .authorized || result == .restricted
            })
        }
    }
    
    func fetchAllSongs() -> Array<MPMediaItem> {
        if !authorized {
            return []
        }
        return MPMediaQuery.songs().items ?? []
    }
    
    func fetchAllAlbums() -> Array<MPMediaItemCollection> {
        if !authorized {
            return []
        }
        let query = MPMediaQuery.albums()
        query.groupingType = .album
        return query.collections ?? []
    }
    
    func fetchAllArtists() -> Array<MPMediaItemCollection> {
        if !authorized {
            return []
        }
        let ret = MPMediaQuery.artists().collections ?? []
        return ret
    }
    
    func fetchAllGenres() -> Array<MPMediaItemCollection> {
        if !authorized {
            return []
        }
        return MPMediaQuery.genres().collections ?? []
    }
    
    func fetchSong(byId identifier: MPMediaEntityPersistentID) -> MPMediaItem? {
        if !authorized {
            return nil
        }
        var ret:MPMediaItem? = nil
        let filter = MPMediaPropertyPredicate(value: identifier, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(filter)
        ret = query.items?.first
        return ret
    }
    
    func fetchAlbums(byArtist artist: MPMediaEntityPersistentID) -> Array<MPMediaItemCollection> {
        if !authorized {
            return []
        }
        let filter = MPMediaPropertyPredicate.init(value: artist, forProperty: MPMediaItemPropertyArtistPersistentID, comparisonType: .contains)
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(filter)
        let albums = query.collections ?? []
        return albums
    }
    
    func fetchSongs(byAlbum album: MPMediaEntityPersistentID) -> Array<MPMediaItem> {
        if !authorized {
            return []
        }
        let filter = MPMediaPropertyPredicate.init(value: album, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(filter)
        return query.items ?? []
    }
    
    func fetchSongs(byArtist artist:MPMediaEntityPersistentID) -> Array<MPMediaItem> {
        if !authorized {
            return []
        }
        let filter = MPMediaPropertyPredicate.init(value: artist, forProperty: MPMediaItemPropertyArtistPersistentID, comparisonType: .equalTo)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(filter)
        return query.items ?? []
    }
    
    func fetchSongs(byGenre genre:MPMediaEntityPersistentID) -> Array<MPMediaItem> {
        if !authorized {
            return []
        }
        let filter = MPMediaPropertyPredicate.init(value: genre, forProperty: MPMediaItemPropertyGenrePersistentID, comparisonType: .equalTo)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(filter)
        return query.items ?? []
    }
    
    func fetchAlbums(byGenre genre: MPMediaEntityPersistentID) -> Array<MPMediaItemCollection> {
        if !authorized {
            return []
        }
        let filter = MPMediaPropertyPredicate.init(value: genre, forProperty: MPMediaItemPropertyGenrePersistentID, comparisonType: .equalTo)
        
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(filter)
        let albums = query.collections ?? []
        return albums
    }
    
    func fetchArtists(byGenre genre:MPMediaEntityPersistentID) -> Array<MPMediaItemCollection> {
        if !authorized {
            return []
        }
        let filter = MPMediaPropertyPredicate.init(value: genre, forProperty: MPMediaItemPropertyGenrePersistentID, comparisonType: .equalTo)
        
        let query = MPMediaQuery.artists()
        query.addFilterPredicate(filter)
        let artists = query.collections ?? []
        return artists
    }
    
    func fetchLocalFiles() -> Array<MediaItem> {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fm = FileManager.default
        var ret: Array<MediaItem> = []
        var files: Array<String> = []
        do {
            files = try fm.contentsOfDirectory(atPath: docPath)
        } catch let err {
            print(err)
        }
        
        for each in files {
            if each.hasSuffix(".mp3") || each.hasSuffix(".m4a") || each.hasSuffix("wav") {
                ret.append(MediaItem(name: each, fileName: docPath + "/" + each))
            }
        }
        
        return ret
    }
    
    func validateList(list: Array<UInt64>) -> Array<MPMediaItem> {
        var ret: Array<MPMediaItem> = []
        for each in list {
            let toAdd = fetchSong(byId: each)
            if toAdd != nil {
                ret.append(toAdd!)
            }
        }
        return ret
    }
    
    static func shuffle(array: [Any]) -> [Any] {
        if array.count == 0 {
            return array
        }
        var copy: Array<Any> = []
        copy.append(contentsOf: array)
        var ret: Array<Any> = []
        while (copy.count > 0) {
            ret.append(copy.remove(at: Int(arc4random_uniform(UInt32(copy.count)))))
        }
        return ret
    }
    
    static func shuffle(array: [Any], highlight:Any) -> [Any] {
        var ret = shuffle(array: array)
        var idx = 0
        if highlight is MPMediaItem {
            idx = ret.index(where: {($0 as! MPMediaItem).persistentID == (highlight as! MPMediaItem).persistentID}) ?? -1
        } else if highlight is MediaItem {
            idx = ret.index(where: {($0 as! MediaItem).fileName == (highlight as! MediaItem).fileName}) ?? -1
        }
        if idx >= 0 {
            ret.remove(at: idx)
            ret.insert(highlight, at: 0)
        } else {
            ret.insert(highlight, at: 0)
        }
        return ret
    }
    
}

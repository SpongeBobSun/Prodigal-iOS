//
//  MediaLibrary.swift
//  Prodigal
//
//  Created by bob.sun on 22/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
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
    
    func fetchAllGenres() -> Array<MPMediaItem> {
        if !authorized {
            return []
        }
        return MPMediaQuery.genres().items ?? []
    }
    //TODO: By Id
    func fetchAlbums(byArtist artist:String) -> Array<MPMediaItemCollection> {
        if !authorized {
            return []
        }
        let filter = MPMediaPropertyPredicate.init(value: artist, forProperty: MPMediaItemPropertyArtist, comparisonType: .contains)
        
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(filter)
        let albums = query.collections ?? []
        return albums
    }
    
    func fetchSongs(byAlbum album:String) -> Array<MPMediaItem> {
        if !authorized {
            return []
        }
        let filter = MPMediaPropertyPredicate.init(value: album, forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: .equalTo)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(filter)
        return query.items ?? []
    }
    
    func fetchAlbums(byGenre genre:String) -> Array<MPMediaItemCollection> {
        if !authorized {
            return []
        }
        let filter = MPMediaPropertyPredicate.init(value: genre, forProperty: MPMediaItemPropertyGenre, comparisonType: .equalTo)
        
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(filter)
        let albums = query.collections ?? []
        return albums
    }
}

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
import Holophonor

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
                Holophonor.instance.rescan(true, complition: {
                })
            })
        }
    }
    
    func validateList(list: Array<String>) -> Array<MediaItem> {
        var ret: Array<MediaItem> = []
        for each in list {
            let toAdd = Holophonor.instance.getSongBy(id: each)
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
        idx = ret.index(where: {($0 as! MediaItem).persistentID == (highlight as! MediaItem).persistentID}) ?? -1
        if idx >= 0 {
            ret.remove(at: idx)
            ret.insert(highlight, at: 0)
        } else {
            ret.insert(highlight, at: 0)
        }
        return ret
    }
    
}

//
//  MediaItem.swift
//  Prodigal
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
 *  Created by bob.sun on 21/04/2017.
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

import Foundation
import AVFoundation

class MediaItem {
    
    enum MediaSource: Int {
        case iTunes = 1
        case Local
    }
    
    var name = "", artist = "", album = "", fileName = ""
    
    init() {
        
    }
    
    init(name:String, fileName: String) {
        self.name = name
        self.fileName = fileName
    }
    
    func getFile() -> URL {
        return URL(fileURLWithPath: fileName)
    }
}

extension MediaItem: Equatable {
    static func == (first: MediaItem, second: MediaItem) -> Bool {
        return first.fileName == second.fileName
    }
}

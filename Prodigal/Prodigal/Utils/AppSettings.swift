//
//  AppSettings.swift
//  Prodigal
//
//  Created by bob.sun on 21/02/2017.
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

class AppSettings: NSObject {
    var ud: UserDefaults = UserDefaults.standard
    
    static let kNewInstallWithVer       =   "kNewInstallWithVer%@"
    static let kUserTheme               =   "kUserTheme"
    static let kRepeat                  =   "kRepeat"
    static let kShuffle                 =   "kShuffle"
    
    static let EventSettingsChanged     =   "EventRepeatChanged"
    
    static let sharedInstance : AppSettings = {
        let ret = AppSettings()
        return ret
    }()
    
    fileprivate func writeDefaultValue() {
        ud.set(RepeatMode.None.rawValue, forKey: AppSettings.kRepeat)
        ud.set(ShuffleMode.No.rawValue, forKey: AppSettings.kShuffle)
    }
    
    func newInstall() -> Bool {
        let key = String.init(format: AppSettings.kNewInstallWithVer, (Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!)
        let value = ud.object(forKey: key)
        if (value == nil) {
            return true
        }
        return ud.bool(forKey: key)
    }
    
    func installed() {
        let key = String.init(format: AppSettings.kNewInstallWithVer, (Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!)
        ud.set(false, forKey: key)
        writeDefaultValue()
        ud.synchronize()
    }
    
    func userTheme() -> String? {
        return ud.string(forKey: AppSettings.kUserTheme)
    }
    
    func setTheme(theme: String) {
        ud.set(theme, forKey: AppSettings.kUserTheme)
        ud.synchronize()
    }
    
    func getRepeat() -> RepeatMode {
        return RepeatMode(rawValue: ud.integer(forKey: AppSettings.kRepeat)) ?? .None
    }
    
    func getShuffle() -> ShuffleMode {
        return ShuffleMode(rawValue: ud.integer(forKey: AppSettings.kShuffle)) ?? .No
    }
    
    func rollRepeat() -> RepeatMode {
        var current = ud.integer(forKey: AppSettings.kRepeat)
        if (current == 3) {
            current = 1
        } else {
            current += 1
        }
        ud.set(current, forKey: AppSettings.kRepeat)
        ud.synchronize()
        PubSub.publish(name: AppSettings.EventSettingsChanged, sender: self)
        return RepeatMode(rawValue: current) ?? .None
    }
    
    func rollShuffle() -> ShuffleMode {
        var current = ud.integer(forKey: AppSettings.kShuffle)
        if (current == 2) {
            current = 1
        } else {
            current += 1
        }
        ud.set(current, forKey: AppSettings.kShuffle)
        ud.synchronize()
        PubSub.publish(name: AppSettings.EventSettingsChanged, sender: self)
        return ShuffleMode(rawValue: current) ?? .No
    }
}

enum RepeatMode: Int {
    case One = 1
    case All
    case None
}

enum ShuffleMode: Int {
    case Yes = 1
    case No
}

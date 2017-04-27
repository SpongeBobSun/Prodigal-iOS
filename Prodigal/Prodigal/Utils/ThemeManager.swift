//
//  ThemeManager.swift
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

class ThemeManager: NSObject {
    
    static var currentTheme: Theme = Theme.defaultTheme()
    
    var docPath = ""
    let fm = FileManager.default
    
    override init() {
        super.init()
        docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        docPath.append("/Themes")
    }
    
    func copyToDocuments() {
        
        if fm.fileExists(atPath: docPath) {
            return
        }
        
        let resPath = Bundle.init(for: type(of: self)).path(forResource: "Configs", ofType: nil)
        let resUrl = NSURL.fileURL(withPath: resPath!, isDirectory: true)
        let docUrl = NSURL.fileURL(withPath: docPath, isDirectory: true)
        do {
            try fm.copyItem(at: resUrl, to: docUrl)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func fetchAllThemes() -> Array<String> {
        var ret = [String]()
        do {
            try ret = fm.contentsOfDirectory(atPath: docPath)
        } catch let error as NSError {
            print(error)
        }
        ret = ret.filter { (folder) -> Bool in
                let folderPath = docPath.appending("/").appending(folder)
                var files = [String]()
                do {
                    try files = fm.contentsOfDirectory(atPath: folderPath)
                } catch _ as NSError {
                    return false
                }
                return files.contains("config.json")
            }
        return ret
    }
    
    func loadThemeNamed(name: String) -> Theme? {
        var ret: Theme? = nil
        let themeFolder = docPath.appending("/").appending(name).appending("/")
        let jsonPath = themeFolder.appending("config.json")
        let jsonData = fm.contents(atPath: jsonPath)
        if jsonData == nil {
            return ret
        }
        
        var dict: Dictionary<String, Any>? = nil
        do {
            try dict = JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as? Dictionary
            dict!["path"] = themeFolder
            if Theme.validate(dict: dict!) {
                ret = Theme(fromDict: dict!, andName: name)
            }
        } catch let error as NSError {
            print(error)
        }
        if ret == nil {
            ret = Theme.defaultTheme()
        } else {
            AppSettings.sharedInstance.setTheme(theme: name)
        }
        ThemeManager.currentTheme = ret!
        return ret
    }
    
    func loadLastTheme() -> Theme {
        let name = AppSettings.sharedInstance.userTheme()
        if name == nil {
            ThemeManager.currentTheme = Theme.defaultTheme()
            return ThemeManager.currentTheme
        }
        let ret = loadThemeNamed(name: name!)
        if ret != nil {
            ThemeManager.currentTheme = ret!
            return ret!
        }
        ThemeManager.currentTheme = Theme.defaultTheme()
        return ThemeManager.currentTheme
    }
}

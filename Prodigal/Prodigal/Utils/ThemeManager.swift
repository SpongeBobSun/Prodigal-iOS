//
//  ConfigManager.swift
//  Prodigal
//
//  Created by bob.sun on 21/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit

class ThemeManager: NSObject {
    
    var docPath = ""
    let fm = FileManager.default
    
    override init() {
        super.init()
        docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        docPath.append("/Configs")
    }
    
    func copyToDocuments() {
        
        if fm.fileExists(atPath: docPath) {
            //Debug
            #if DEBUG
            print(self.fetchAllConfigs())
            print(self.loadLastTheme())
            #endif
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
    
    func fetchAllConfigs() -> Array<String> {
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
    
    func loadConfigNamed(name: String) -> Theme? {
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
            ret = Theme(fromDict: dict!)
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    func loadLastTheme() -> Theme {
        let name = AppSettings.sharedInstance.userTheme()
        if name == nil {
            return Theme.defaultTheme()
        }
        let ret = loadConfigNamed(name: name!)
        if ret != nil {
            return ret!
        }
        return Theme.defaultTheme()
    }
}

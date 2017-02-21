//
//  AppSettings.swift
//  Prodigal
//
//  Created by bob.sun on 21/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit

class AppSettings: NSObject {
    var ud: UserDefaults = UserDefaults.standard
    
    static let kNewInstallWithVer       =   "kNewInstallWithVer%@"
    static let kUserTheme               =   "kUserTheme"
    
    static let sharedInstance : AppSettings = {
        let ret = AppSettings()
        return ret
    }()
    
    func newInstall() -> Bool {
        let key = String.init(format: AppSettings.kNewInstallWithVer, Bundle.main.infoDictionary?["CFBundleVersion"] as! String!)
        return ud.bool(forKey: key)
    }
    
    func installed() {
        let key = String.init(format: AppSettings.kNewInstallWithVer, Bundle.main.infoDictionary?["CFBundleVersion"] as! String!)
        ud.set(true, forKey: key)
        ud.synchronize()
    }
    
    func userTheme() -> String? {
        return ud.string(forKey: AppSettings.kUserTheme)
    }
    
    func setTheme(theme: String) {
        ud.set(theme, forKey: AppSettings.kUserTheme)
        ud.synchronize()
    }
}

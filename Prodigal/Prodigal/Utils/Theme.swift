//
//  AppConfig.swift
//  Prodigal
//
//  Created by bob.sun on 21/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit

@IBDesignable
class Theme: NSObject {
    private var icNext:String, icPrev:String, icPlay:String, icMenu:String;
    var weight:Double
    var wheelColor:UIColor
    
    private static var defaultDict :Dictionary<String, Any> = [
        "icons": [
            "next":"next.png",
            "prev":"prev.png",
            "play":"play.png",
            "menu":"menu.png",
        ],
        "wheel_weight":"0.6",
        "wheel_color":"#EEEEEE",
        ]
    
    override convenience init() {
        self.init(fromDict: Dictionary<String, Any>())
    }
    
    init(fromDict dict: Dictionary<String, Any>) {
        let icons:Dictionary<String, String> = dict["icons"] as! Dictionary<String, String>
        let path = dict["path"] as! String
        icNext = path.appending(icons["next"]!)
        icPrev = path.appending(icons["prev"]!)
        icPlay = path.appending(icons["play"]!)
        icMenu = path.appending(icons["menu"]!)
        weight = Double(dict["wheel_weight"] as! String!)!
        if weight > 1 {
            weight = 1
        }
        wheelColor = UIColor.init(hexString: dict["wheel_color"] as! String)!
        super.init()
    }
    
    static func defaultTheme() -> Theme {
        if let _ = defaultDict["path"] as! String? {
            
        } else {
            var themePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            themePath.append("/Configs/default/")
            defaultDict["path"] = themePath
        }
        return Theme(fromDict:defaultDict)
    }
    
    func nextIcon() -> UIImage {
        #if TARGET_INTERFACE_BUILDER
            return #imageLiteral(resourceName: "ic_next")
        #endif
        return UIImage(contentsOfFile: icNext) ?? UIImage(named: "ic_next")!
    }
    
    func prevIcon() -> UIImage {
        #if TARGET_INTERFACE_BUILDER
            return #imageLiteral(resourceName: "ic_prev")
        #endif
        return UIImage(contentsOfFile: icPrev) ?? UIImage(named: "ic_prev")!
    }
    
    func menuIcon() -> UIImage {
        #if TARGET_INTERFACE_BUILDER
            return #imageLiteral(resourceName: "ic_menu")
        #endif
        return UIImage(contentsOfFile: icMenu) ?? UIImage(named: "ic_menu")!
    }
    
    func playIcon() -> UIImage {
        #if TARGET_INTERFACE_BUILDER
            return #imageLiteral(resourceName: "ic_play")
        #endif
        return UIImage(contentsOfFile: icPlay) ?? UIImage(named: "ic_play")!
    }
}

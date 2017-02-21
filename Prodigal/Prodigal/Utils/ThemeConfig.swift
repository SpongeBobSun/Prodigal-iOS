//
//  AppConfig.swift
//  Prodigal
//
//  Created by bob.sun on 21/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit

class Theme: NSObject {
    var icNext:String, icPrev:String, icPlay:String, icMenu:String;
    var weight:Double
    var wheelColor:UIColor
    
    override convenience init() {
        self.init(fromDict: Dictionary<String, Any>())
    }
    
    init(fromDict dict: Dictionary<String, Any>) {
        let icons:Dictionary<String, String> = dict["icons"] as! Dictionary<String, String>!
        icNext = icons["next"]!
        icPrev = icons["prev"]!
        icPlay = icons["play"]!
        icMenu = icons["menu"]!
        weight = Double(dict["wheel_weight"] as! String!)!
        wheelColor = UIColor.init(hexString: dict["wheel_color"] as! String)!
        super.init()
    }
    
    static func defaultTheme() -> Theme {
        return Theme(fromDict:[
            "icons": [
                "next":"next.png",
                "prev":"prev.png",
                "play":"play.png",
                "menu":"menu.png",
            ],
            "wheel_weight":"1.0",
            "wheel_color":"#CCCCCC",
            ])
    }
}

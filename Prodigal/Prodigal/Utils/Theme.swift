//
//  Theme.swift
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

@IBDesignable
class Theme: NSObject {
    private var icNext:String, icPrev:String, icPlay:String, icMenu:String;
    var outer:Double, inner: Double, buttonSize: Double
    var wheelColor:UIColor, buttonColor:UIColor, backgroundColor: UIColor, cardColor: UIColor, itemColor: UIColor, textColor: UIColor
    var name: String!
    var shape: WheelViewShape
    var sides: Int = 6
    var backgroundCover: Bool = true
    
    private static var defaultDict :Dictionary<String, Any> = [
        "icons": [
            "next":"next.png",
            "prev":"prev.png",
            "play":"play.png",
            "menu":"menu.png",
            ],
        "wheel_outer":"0.95",
        "wheel_inner":"0.3",
        "wheel_color":"#CCCCCCAA",
        "button_size":"0.2",
        "button_background": "#000000FF",
        "background_color": "#59A5C6",
        "wheel_shape": "rect",
        "card_color": "#CCCCCCAA",
        "item_color": "#4D93C6",
        "background_cover" : true,
        ]
    
    override convenience init() {
        self.init(fromDict: Dictionary<String, Any>(), andName: "")
    }
    
    init(fromDict dict: Dictionary<String, Any>, andName name: String) {
        let icons:Dictionary<String, String> = dict["icons"] as! Dictionary<String, String>
        let path = dict["path"] as! String
        icNext = path.appending(icons["next"]!)
        icPrev = path.appending(icons["prev"]!)
        icPlay = path.appending(icons["play"]!)
        icMenu = path.appending(icons["menu"]!)
        outer = Double(dict["wheel_outer"] as! String)!
        if outer > 1 {
            outer = 1
        }
        inner = Double(dict["wheel_inner"] as! String)!
        if inner < 0.3 {
            inner = 0.3
        }
        buttonSize = Double(dict["button_size"] as! String)!
        
        wheelColor = UIColor(hexString: dict["wheel_color"] as! String)!
        buttonColor = UIColor(hexString: dict["button_background"] as! String)!
        backgroundColor = UIColor(hexString: dict["background_color"] as! String)!
        
        if (dict["card_color"] as! String?) != nil {
            cardColor = UIColor(hexString: dict["card_color"] as! String)!
        } else {
            cardColor = UIColor.white
        }
        
        if (dict["item_color"] as! String?) != nil {
            itemColor = UIColor(hexString: dict["item_color"] as! String) ?? UIColor.lightGray
        } else {
            itemColor = UIColor.lightGray
        }
        
        switch dict["wheel_shape"] as? String {
        case "rect":
            shape = .Rect
            break
        case "oval":
            shape = .Oval
            break
        case "polygon":
            shape = .Polygon
            sides = Int(dict["polygon_sides"] as! String)!
            break
        default:
            shape = .Rect
            break
        }
        
        if dict["text_color"] as? String != nil {
            textColor = UIColor(hexString: dict["text_color"] as! String) ?? UIColor.black
        } else {
            textColor = UIColor.black
        }
        
        self.name = name
        self.backgroundCover = dict["background_cover"] as? Bool ?? true
        super.init()
    }
    
    static func defaultTheme() -> Theme {
        if let _ = defaultDict["path"] as! String? {
            
        } else {
            var themePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            themePath.append("/Themes/default/")
            defaultDict["path"] = themePath
        }
        return Theme(fromDict:defaultDict, andName: "Default")
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
    
    //TL;DR
    static func validate(dict: Dictionary<String, Any>) -> Bool {
        if let icons = dict["icons"] as? Dictionary<String, String> {
            if icons["next"] == nil {
                return false
            }
            
            if icons["prev"] == nil {
                return false
            }
            
            if icons["menu"] == nil {
                return false
            }
            
            if icons["play"] == nil {
                return false
            }
            guard (dict["wheel_outer"] as? String) != nil else {
                return false
            }
            guard (dict["wheel_inner"] as? String) != nil else {
                return false
            }
            guard (dict["button_size"] as? String) != nil else {
                return false
            }
            
            guard (UIColor.init(hexString: dict["wheel_color"] as! String)) != nil else {
                return false
            }
            
            guard (UIColor.init(hexString: dict["button_background"] as! String)) != nil else {
                return false
            }
            guard (UIColor.init(hexString: dict["background_color"] as! String)) != nil else {
                return false
            }
            guard let shape = dict["wheel_shape"] as? String else {
                return false
            }
            
            if shape != "rect" && shape != "oval" && shape != "polygon" {
                return false
            }
            if (shape == "polygon") {
                guard (dict["polygon_sides"] as? String) != nil else {
                    return false
                }
            }
            return true
        }
        return false
    }
}

enum WheelViewShape {
    case Oval
    case Rect
    case Polygon
}

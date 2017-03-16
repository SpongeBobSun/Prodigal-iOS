//
//  PubSub.swift
//  Prodigal
//
//  Created by bob.sun on 13/03/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import Foundation

fileprivate class PubSubObserver {
    var name: String! = nil
    var observer: Any! = nil
    
    convenience init(name: String, obs: Any) {
        self.init()
        self.name = name
        self.observer = obs
    }
}

class PubSub {
    static let queue = DispatchQueue(label: "sun.bob.bender.pubsubQ")
    static let instance = PubSub()
    private var map:[UInt: [PubSubObserver]] = [:]
    
    class func publish(name:String, sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    class func publish(name:String, sender: Any, userInfo:[AnyHashable: Any]) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: nil, userInfo: userInfo)
    }
    
    class func pubMainThread(name: String, sender: Any) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(name), object: nil)
        }
    }
    
    class func pubMainThread(name: String, sender: Any, userInfo:[AnyHashable: Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(name), object: nil, userInfo: userInfo)
        }
    }
    
    class func subscribe(target: AnyObject, name: String, handler: @escaping((Notification) -> Void)) {
        let key = UInt(bitPattern: ObjectIdentifier(target))
        
        if instance.map[key] != nil {
            for obs in instance.map[key]! {
                if obs.name == name {
                    return
                }
            }
        }
        let observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(name), object: nil, queue: OperationQueue(), using: handler)
        queue.sync {
            if let observers = instance.map[key]  {
                instance.map[key] = observers + [PubSubObserver(name: name, obs: observer)]
            } else {
                instance.map[key] = [PubSubObserver(name: name, obs: observer)]
            }
        }
    }
    
    class func subOnMainThread(target: AnyObject, name: String, handler: @escaping((Notification) -> Void)) {
        let key = UInt(bitPattern: ObjectIdentifier(target))
        if instance.map[key] != nil {
            for obs in instance.map[key]! {
                if obs.name == name {
                    return
                }
            }
        }
        let observer = NotificationCenter.default.addObserver(forName: Notification.Name(name), object: nil, queue: OperationQueue.main, using: handler)
        queue.sync {
            if let observers = instance.map[key]  {
                instance.map[key] = observers + [PubSubObserver(name: name, obs: observer)]
            } else {
                instance.map[key] = [PubSubObserver(name: name, obs: observer)]
            }
        }
    }
    
    class func unsubscribe(target: AnyObject, name: String) {
        let key = UInt(bitPattern: ObjectIdentifier(target))
        if let psbObs = instance.map[key] {
            for obs in psbObs {
                if obs.name == name {
                    NotificationCenter.default.removeObserver(obs)
                }
            }
        }
    }
}

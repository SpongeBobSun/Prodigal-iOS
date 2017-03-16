//
//  PlayerTick.swift
//  Prodigal
//
//  Created by bob.sun on 14/03/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerTickerProtocol:class {
    func getPlayer() -> AVAudioPlayer?
}

class PlayerTicker {
    static let kTickEvent             = "kTickEvent"
    static let kCurrent               = "kCurrent"
    static let kDuration              = "kDuration"
    var timer: Timer!
    weak var delegate: PlayerTickerProtocol?
    
    init() {
    }
    
    func start() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTick), userInfo: nil, repeats: true)
    }
    
    func stop() {
        if timer == nil {
            return
        }
        timer.invalidate()
    }
    
    
    @objc
    func onTick() {
        guard let player = delegate?.getPlayer() else {
            return
        }
        if !player.isPlaying {
            return
        }
        PubSub.publish(name: PlayerTicker.kTickEvent, sender: self, userInfo: [PlayerTicker.kCurrent: player.currentTime, PlayerTicker.kDuration: player.duration])
    }
}

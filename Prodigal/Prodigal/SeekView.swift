//
//  SeekView.swift
//  Prodigal
//
//  Created by Bob on 2018/12/19.
//  Copyright © 2018 bob.sun. All rights reserved.
//

import UIKit
import MediaPlayer

class SeekView: UIView {
    enum SeekViewShowMode {
        case Volume
        case Seek
        case Progress
    }
    let seekBar = UIProgressView()
    let label = UILabel()
    let volumeView = MPVolumeView()
    var volumeSlider: UISlider!
    var showMode: SeekViewShowMode = .Volume
    var timer: Timer!
    var lastTicked: TimeInterval = 0
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
        self.addSubview(seekBar)
        self.addSubview(label)
        self.addSubview(volumeView)
        
        label.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.bottom.equalTo(self.snp.centerY).offset(-20)
        }
        label.textAlignment = .center
        
        seekBar.snp.makeConstraints { (maker) in
            maker.height.equalTo(10)
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.top.equalTo(self.snp.centerY).offset(20)
        }
        volumeView.frame = CGRect.zero
        volumeSlider = volumeView.volumeSlider
        self.isHidden = true
    }
    
    func toggle() {
        if (self.showMode == .Volume) {
            self.alpha = 0
        } else {
            self.alpha = 1
        }
        self.isHidden = !self.isHidden
        if self.isHidden && self.showMode != .Progress {
            timer.invalidate()
            timer = nil
            return
        }
        if self.showMode == .Progress {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
                if (Date().timeIntervalSince1970 - self.lastTicked < 3 || self.lastTicked == 0) {
                    return
                }
                DispatchQueue.main.async {
                    self.showMode = .Volume
                    self.isHidden = true
                }
            })
        }
        if showMode == .Volume {
            self.label.text = "Volume"
        } else if showMode == .Seek {
            self.label.text = "Seek"
        } else {
            self.label.text = "Rescanning"
        }
        
    }
    
    func onIncrease() {
        if (self.isHidden) {
            toggle()
        }
        self.lastTicked = Date().timeIntervalSince1970
        if (showMode == .Volume) {
            increaseVolume()
        } else {
            if seekBar.progress < 1.0 {
                seekBar.setProgress(seekBar.progress + 0.1, animated: true)
            }
        }
    }
    
    func onDecrease() {
        if (self.isHidden) {
            toggle()
        }
        self.lastTicked = Date().timeIntervalSince1970
        if (showMode == .Volume) {
            decreaseVolume()
        } else {
            if seekBar.progress > 0 {
                seekBar.setProgress(seekBar.progress - 0.1, animated: true)
            }
        }
    }
    
    func updateProgress(_ progress: Int64) {
        seekBar.progress = Float(progress) / 100.0
    }
    
    private func increaseVolume() {
        let current = volumeSlider.value
        if current < 1.0 {
            volumeSlider.setValue(current + 0.1, animated: false)
            volumeSlider.sendActions(for: .touchUpInside)
        }
    }
    
    private func decreaseVolume() {
        let current = volumeSlider.value
        if current > 0 {
            volumeSlider.setValue(current - 0.1, animated: false)
            volumeSlider.sendActions(for: .touchUpInside)
        }
    }
    
}

extension MPVolumeView {
    var volumeSlider: UISlider? {
        self.showsRouteButton = false
        self.showsVolumeSlider = false
        self.isHidden = true
        for subview in subviews {
            guard let slider = subview as? UISlider else {
                continue
            }
            slider.isContinuous = false
            slider.value = AVAudioSession.sharedInstance().outputVolume
            return slider
        }
        return nil
    }
}


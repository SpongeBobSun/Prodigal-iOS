//
//  NowPlayingViewController.swift
//  Prodigal
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
 *  Created by ___FULLUSERNAME___ on ___DATE___.
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
import MediaPlayer
import SnapKit
import MarqueeLabel

class NowPlayingViewController: TickableViewController {
    
    
    var playingView: NowPlayingView = NowPlayingView()
    let seekView: SeekView = SeekView()
    private var _song: MPMediaItem!
    private var currentSelectionType: MenuMeta.MenuType! = .NowPlayingPopSeek
    var song: MPMediaItem {
        set {
            _song = newValue
            playingView.image.image = _song.artwork?.image(at: CGSize(width: 200, height: 200)) ?? #imageLiteral(resourceName: "ic_album")
            playingView.title.text = _song.title
            playingView.artist.text = _song.artist
            playingView.album.text = _song.albumTitle
        }
        get {
            return _song
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playingView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attachTo(viewController vc: UIViewController, inView view:UIView) {
        vc.addChildViewController(self)
        view.addSubview(self.view)
        self.view.isHidden = true
        self.view.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(view)
            maker.center.equalTo(view)
        }
        
        self.view.addSubview(playingView)
        playingView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.top.equalTo(self.view)
        }
        playingView.layoutIfNeeded()
        
        self.view.addSubview(seekView)
        seekView.snp.makeConstraints({ (maker) in
            maker.leading.trailing.bottom.top.equalToSuperview()
        })
    }
    
    override func hide(type: AnimType = .push, completion: @escaping () -> Void) {
        self.view.isHidden = true
        completion()
        PubSub.unsubscribe(target: self, name: PlayerTicker.kTickEvent)
    }
    
    override func show(type: AnimType) {
        self.view.isHidden = false
        PubSub.subscribe(target: self, name: PlayerTicker.kTickEvent, handler: {(notification:Notification) -> Void in
            let (current, duration) = (notification.userInfo?[PlayerTicker.kCurrent] as! Double , notification.userInfo?[PlayerTicker.kDuration] as! Double)
            let progress = Float(current) / Float(duration)
            DispatchQueue.main.async {
                self.playingView.progress.setProgress(progress, animated:true)
                self.playingView.updateLabels(now: current, all: duration)
            }
        })
    }
    
    override func getSelection() -> MenuMeta {
        if seekView.showMode != .Seek {
            return MenuMeta(name: "", type: .NowPlayingPopSeek)
        }
        if seekView.isHidden {
            return MenuMeta(name: "", type: .NowPlayingPopSeek)
        } else {
            seekView.showMode = .Volume
            seekView.toggle()
            return MenuMeta(name: "", type: .NowPlayingDoSeek).setObject(obj: Double(seekView.seekBar.progress))
        }
    }

    override func onNextTick() {
        seekView.onIncrease()
    }
    override func onPreviousTick() {
        seekView.onDecrease()
    }
    
    func show(withSong song: MPMediaItem?, type: AnimType = .push) {
        self.view.isHidden = false
        if song == nil {
            //Mark - TODO: Empty view
            return
        }
        self.song = song!
        PubSub.subscribe(target: self, name: PlayerTicker.kTickEvent, handler: {(notification:Notification) -> Void in
            let (current, duration) = (notification.userInfo?[PlayerTicker.kCurrent] as! Double , notification.userInfo?[PlayerTicker.kDuration] as! Double)
            let progress = Float(current) / Float(duration)
            DispatchQueue.main.async {
                self.playingView.progress.setProgress(progress, animated:true)
                self.playingView.updateLabels(now: current, all: duration)
            }
        })
    }
    
    private func initViews() {
    }
    
    func popSeek() {
        seekView.showMode = .Seek
        seekView.toggle()
    }
}

class NowPlayingView: UIView {
    
    let image = UIImageView()
    let title = MarqueeLabel(), artist = MarqueeLabel(), album = MarqueeLabel(), total = UILabel(), current = UILabel()
    let progressContainer = UIView()
    let progress = UIProgressView()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        addSubview(image)
        addSubview(title)
        addSubview(artist)
        addSubview(album)
        addSubview(progressContainer)
        
        progressContainer.snp.makeConstraints { (maker) in
            maker.leading.bottom.equalTo(self).offset(8)
            maker.trailing.equalTo(self).offset(-8)
            maker.height.equalTo(64)
        }
        progressContainer.addSubview(progress)
        
        progress.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalTo(progressContainer)
            maker.height.equalTo(10)
        }
        progress.trackTintColor = UIColor.lightGray
        progressContainer.backgroundColor = UIColor.clear
        progressContainer.addSubview(current)
        progressContainer.addSubview(total)
        
        current.snp.makeConstraints { (maker) in
            maker.leading.bottom.equalToSuperview()
            maker.top.equalTo(progress.snp.bottomMargin).offset(5)
            maker.width.equalTo(100)
        }
        
        total.snp.makeConstraints { (maker) in
            maker.trailing.bottom.equalToSuperview()
            maker.top.equalTo(progress.snp.bottomMargin).offset(5)
            maker.width.equalTo(100)
        }
        current.textAlignment = .left
        total.textAlignment = .right
        
        image.snp.makeConstraints { (maker) in
            maker.leading.top.equalTo(self).offset(8)
            maker.trailing.equalTo(self.snp.centerX).offset(-8)
            maker.bottom.equalTo(progressContainer.snp.top)
        }
        image.image = #imageLiteral(resourceName: "ic_album")
        image.contentMode = .scaleAspectFit
        
        title.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.snp.centerX).offset(8)
            maker.trailing.equalTo(self).offset(-8)
            maker.height.equalTo(30)
            maker.centerY.equalTo(self).offset(-60)
        }
        title.speed = .duration(8)
        title.fadeLength = 10
        
        album.snp.makeConstraints { (maker) in
            maker.leading.trailing.height.equalTo(title)
            maker.centerY.equalTo(self).offset(-15)
        }
        album.speed = .duration(8)
        album.fadeLength = 10
        
        artist.snp.makeConstraints { (maker) in
            maker.leading.trailing.height.equalTo(album)
            maker.centerY.equalTo(self).offset(30)
        }
        artist.speed = .duration(8)
        artist.fadeLength = 10
        
    }
    
    func updateLabels(now: TimeInterval, all: TimeInterval) {
        let (minNow, secNow) = (Int(now / 60), Int(now.truncatingRemainder(dividingBy:60)))
        let (minAll, secAll) = (Int(all / 60), Int(all.truncatingRemainder(dividingBy:60)))
        
        current.text = "\(String(format:"%02d", minNow)):\(String(format:"%02d", secNow))"
        total.text = "\(String(format:"%02d", minAll)):\(String(format:"%02d", secAll))"
    }
}

class SeekView: UIView {
    enum SeekViewShowMode {
        case Volume
        case Seek
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
        if self.isHidden {
            timer.invalidate()
            timer = nil
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            if (Date().timeIntervalSince1970 - self.lastTicked < 3 || self.lastTicked == 0) {
                return
            }
            DispatchQueue.main.async {
                self.showMode = .Volume
                self.isHidden = true
            }
        })
        if showMode == .Volume {
            self.label.text = "Volume"
        } else {
            self.label.text = "Seek"
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

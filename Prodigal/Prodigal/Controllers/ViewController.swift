//
//  ViewController.swift
//  Prodigal
//
//  Created by bob.sun on 17/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import Haneke

class ViewController: UIViewController {

    @IBOutlet weak var wheelView: WheelView!
    @IBOutlet weak var cardView: UIView!
    
    
    var current: TickableViewController!
    var mainMenu: TwoPanelListViewController!
    var artistsList: ListViewController!, albumsList: ListViewController!, songsList: ListViewController!, genresList: ListViewController!, playListView: ListViewController!, nowPlaying: NowPlayingViewController!, settings: ListViewController!, themeListView: ListViewController!, localListView: ListViewController!
    var gallery: AlbumGalleryViewController!
    var stack: Array<TickableViewController> = Array<TickableViewController>()
    
    @IBOutlet weak var coverBackground: UIImageView!
    @IBOutlet weak var backgroundMask: UIView!
    
    var player: AVAudioPlayer?
    var session: AVAudioSession!
    var playingIndex: Int = -1
    var resumeTime: Double = -1
    var playlist: Array<MPMediaItem> = []
    var fileList: Array<MediaItem> = []
    var ticker: PlayerTicker!
    var theme = ThemeManager().loadLastTheme()
    
    var source: MediaItem.MediaSource = .iTunes
    
    
    // ? ? ?
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wheelView.delegate = self
        initChildren()
        initPlayer()
        initTicker()
        
        self.view.backgroundColor = theme.backgroundColor
        self.backgroundMask.backgroundColor = theme.backgroundColor
        self.view.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        (UIApplication.shared.delegate as! AppDelegate).saveState()
        // Dispose of any resources that can be recreated.
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type != UIEventType.remoteControl {
            return
        }
        switch event!.subtype {
        case .remoteControlPlay:
            self.onPlay()
            break
        case .remoteControlStop :
            stop()
            break
        case .remoteControlPause:
            if player != nil && (player?.isPlaying)! {
                player?.pause()
            }
            break
        case .remoteControlTogglePlayPause:
            play()
            break
        case .remoteControlNextTrack:
            self.onNext()
            break
        case .remoteControlPreviousTrack:
            self.onPrev()
            break
        default: break
            
        }
    }
    
    private func initChildren() {
        mainMenu = TwoPanelListViewController()
        mainMenu.nowPlayingFetcherDelegate = self
        wheelView.tickDelegate = mainMenu
        current = mainMenu
        mainMenu.attachTo(viewController: self, inView: cardView)
        stack.append(mainMenu)
        artistsList = ListViewController()
        artistsList.attachTo(viewController: self, inView: cardView)
        
        albumsList = ListViewController()
        albumsList.attachTo(viewController: self, inView: cardView)
        
        songsList = ListViewController()
        songsList.attachTo(viewController: self, inView: cardView)
        
        genresList = ListViewController()
        genresList.attachTo(viewController: self, inView: cardView)
        
        playListView = ListViewController()
        playListView.attachTo(viewController: self, inView: cardView)
        
        nowPlaying = NowPlayingViewController()
        nowPlaying.attachTo(viewController: self, inView: cardView)
        
        gallery = AlbumGalleryViewController()
        gallery.attachTo(viewController: self, inView: cardView)
        
        settings = ListViewController()
        settings.attachTo(viewController: self, inView: cardView)
        
        themeListView = ListViewController()
        themeListView.attachTo(viewController: self, inView: cardView)
        
        localListView = ListViewController()
        localListView.attachTo(viewController: self, inView: cardView)
    }
    
    func initPlayer() {
        session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
            NotificationCenter.default.addObserver(self, selector: #selector(onAudioRouteChange), name:NSNotification.Name.AVAudioSessionRouteChange, object: nil)
        } catch let e as NSError {
            print(e)
        }
    }
    
    func initTicker() {
        ticker = PlayerTicker()
        ticker.delegate = self
    }
    func play(item: MPMediaItem) {
        if player != nil && (player?.isPlaying)! {
            player?.stop()
            ticker.stop()
        }

        if player != nil {
            player?.delegate = nil
            player = nil
        }
        playingIndex = playlist.index(of: item)!
        do {
            try player = AVAudioPlayer.init(contentsOf: item.assetURL!)
            player?.delegate = self
            player?.volume = 1.0
            let result: Bool = (player?.prepareToPlay())!
            if result {
                if resumeTime > 0 {
                    player?.currentTime = resumeTime
                    resumeTime = -1
                }
                player?.play()
                nowPlaying.song = item
                InfoCenterHelper.helper.update(withItem: item)
                ticker.start()
                renderCoverBackground(image: item.artwork?.image(at: CGSize(width: coverBackground.bounds.height, height: coverBackground.bounds.height)) ?? #imageLiteral(resourceName: "ic_album"))
                mainMenu.updateRightPanel(index: mainMenu.current)
            }
        } catch let e as Error {
            print(e)
        }
    }
    
    func play(item: MediaItem) {
        if player != nil && (player?.isPlaying)! {
            player?.stop()
            ticker.stop()
        }
        
        if player != nil {
            player?.delegate = nil
            player = nil
        }
        
        playingIndex = fileList.index(of: item) ?? -1
        do {
            try player = AVAudioPlayer.init(contentsOf: item.getFile())
            player?.delegate = self
            player?.volume = 1.0
            let result: Bool = (player?.prepareToPlay())!
            if result {
                if resumeTime > 0 {
                    player?.currentTime = resumeTime
                    resumeTime = -1
                }
                player?.play()
                nowPlaying.file = item
                InfoCenterHelper.helper.update(withFile: item)
                ticker.start()
                renderCoverBackground(image: #imageLiteral(resourceName: "ic_album"))
                mainMenu.updateRightPanel(index: mainMenu.current)
            }
        } catch let e as Error {
            print(e)
        }
    }
    
    func renderCoverBackground(image: UIImage) {
        coverBackground.image = UIImage.getBlured(image: image)
    }
    
    func play() {
        if source == .iTunes {
            if playlist.count == 0 {
                return
            }
            if playingIndex == -1 || playingIndex >= playlist.count {
                playingIndex = 0
            }
            play(item: playlist[playingIndex])
        } else {
            if fileList.count == 0 {
                return
            }
            if playingIndex == -1 || playingIndex >= fileList.count {
                playingIndex = 0
            }
        
        }
    }
    
    func stop() {
        if player != nil && (player?.isPlaying)! {
            player?.stop()
            ticker.stop()
        }
    }
    
    @objc
    func onAudioRouteChange(notification: Notification) {
        if self.player != nil && self.player!.isPlaying {
            self.player?.pause()
        }
    }
    
    func loadTheme(named name: String?) {
        var theme: Theme!
        if name == nil {
            theme = Theme.defaultTheme()
        } else {
            theme = ThemeManager().loadThemeNamed(name: name!) ?? Theme.defaultTheme()
        }
        self.theme = theme
        self.view.backgroundColor = theme.backgroundColor
        self.backgroundMask.backgroundColor = theme.backgroundColor
        self.view.setNeedsDisplay()
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if source == .iTunes {
            if playingIndex < 0{
                return
            }
            player.stop()
            
            var item: MPMediaItem? = nil
            if (AppSettings.sharedInstance.getRepeat() == .One) {
                item = playlist[playingIndex]
            } else if playingIndex == playlist.count - 1 {
                if AppSettings.sharedInstance.getRepeat() == .All && playlist.count > 1 {
                    item = playlist[0]
                } else {
                    return
                }
            } else {
                item = playlist[playingIndex + 1]
            }
            play(item: item!)
        } else {
            if playingIndex == fileList.count - 1 || playingIndex < 0 {
                return
            }
            player.stop()
            
            var item: MediaItem? = nil
            if (AppSettings.sharedInstance.getRepeat() == .One) {
                item = fileList[playingIndex]
            } else if playingIndex == playlist.count - 1 {
                if AppSettings.sharedInstance.getRepeat() == .All && fileList.count > 1 {
                    item = fileList[0]
                } else {
                    return
                }
            } else {
                item = fileList[playingIndex + 1]
            }

            play(item: item!)
        }
    }
}

extension ViewController: PlayerTickerProtocol {
    func getPlayer() -> AVAudioPlayer? {
        return self.player
    }
}

extension ViewController: NowPlayingFetcherDelegate {
    func getNowPlaying() -> Any? {
        if source == .iTunes {
            if self.playingIndex >= self.playlist.count || self.playlist.count == 0 || self.playingIndex == -1 {
                return nil
            }
            return self.playlist[self.playingIndex]
        } else {
            if self.playingIndex >= self.fileList.count || self.fileList.count == 0 || self.playingIndex == -1 {
                return nil
            }
            return self.fileList[self.playingIndex]
        }
    }
}


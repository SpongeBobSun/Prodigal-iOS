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
    var artistsList: ListViewController!, albumsList: ListViewController!, songsList: ListViewController!, genresList: ListViewController!, playListView: ListViewController!, nowPlaying: NowPlayingViewController!
    var gallery: AlbumGalleryViewController!
    var stack: Array<TickableViewController> = Array<TickableViewController>()
    
    var player: AVAudioPlayer?
    var session: AVAudioSession!
    var playingIndex: Int = -1
    var playlist: Array<MPMediaItem> = []
    
    // ? ? ?
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wheelView.delegate = self
        initChildren()
        initPlayer()
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
        // Dispose of any resources that can be recreated.
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type != UIEventType.remoteControl {
            return
        }
        switch event!.subtype {
        case .remoteControlPlay:
            play()
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
    }
    
    func initPlayer() {
        session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch let e as NSError {
            print(e)
        }
    }
    
    func play(item: MPMediaItem) {
        if player != nil && (player?.isPlaying)! {
            player?.stop()
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
                player?.play()
                nowPlaying.song = item
                InfoCenterHelper.helper.update(withItem: item)
            }
        } catch let e as Error {
            print(e)
        }
    }
    
    func play() {
        if playlist.count == 0 {
           return
        }
        if playingIndex == -1 || playingIndex >= playlist.count {
            playingIndex = 0
        }
        play(item: playlist[playingIndex])
    }
    
    func stop() {
        if player != nil && (player?.isPlaying)! {
            player?.stop()
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if playingIndex == playlist.count - 1 || playingIndex < 0{
            return
        }
        player.stop()
        play(item: playlist[playingIndex + 1])
    }
}

extension ViewController: WheelViewDelegate {
    
    func onNext() {
        if playingIndex == playlist.count - 1 || playingIndex < 0{
            return
        }
        player?.stop()
        play(item: playlist[playingIndex + 1])
    }
    func onMenu() {
        if stack.count == 1 {
            return
        }
        let type = stack.count <= 2 ? AnimType.none : AnimType.pop
        stack.popLast()?.hide(type: type, completion: {
        })
        self.current = self.stack.last
        self.wheelView.tickDelegate = self.current
        self.current.show(type: .pop)
    }
    func onPrev() {
        if playingIndex == 0 || playingIndex < 0 {
            if playingIndex == 0 && (player?.isPlaying)! {
                player?.currentTime = 0
            }
            return
        }
        player?.stop()
        play(item: playlist[playingIndex - 1])
    }
    func onPlay() {
        if player != nil {
            if (player?.isPlaying)! {
                player?.pause()
            } else {
                player?.play()
            }
        }
    }
    func onSelect() {
        let select = current.getSelection()
        switch select.type {
        case .Artists:
            current.hide {
                self.artistsList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllArtists(), animate: false)
            }
            self.current = self.artistsList
            self.wheelView.tickDelegate = self.artistsList
            break
        case .Albums:
            current.hide {
                self.albumsList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllAlbums(), animate: false)
            }
            current = self.albumsList
            self.wheelView.tickDelegate = self.albumsList
            break
        case .Songs:
            current.hide {
                self.songsList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllSongs() , animate: false)
            }
            current = self.songsList
            self.wheelView.tickDelegate = self.songsList
            break
        case .Artist:
            current.hide(completion: { 
                
            })
            let artist = select.object as! MPMediaItemCollection!
            self.albumsList.show(withType: .Albums, andData: MediaLibrary.sharedInstance.fetchAlbums(byArtist: (artist?.representativeItem?.artistPersistentID)!))
            current = albumsList
            self.wheelView.tickDelegate = self.albumsList
            break
        case .Album:
            current.hide(completion: { 
                
            })
            let album = select.object as! MPMediaItemCollection!
            self.songsList.show(withType: .Songs, andData: MediaLibrary.sharedInstance.fetchSongs(byAlbum: (album?.representativeItem?.albumPersistentID)!))
            current = songsList
            self.wheelView.tickDelegate = self.songsList
            break
        case .Song:
            current.hide {
                self.nowPlaying.show(withSong: select.object as! MPMediaItem!)
            }
            self.playlist = (current as! ListViewController).playList ?? []
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            self.play(item: select.object as! MPMediaItem!)
            break
        case .ShuffleCurrent:
            current.hide {
                self.nowPlaying.show(withSong: select.object as! MPMediaItem!)
            }
            self.playlist = (current as! ListViewController).playList ?? []
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            self.play(item: select.object as! MPMediaItem!)
            break
        case .Genres:
            current.hide {
                self.genresList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllGenres() , animate: false)
            }
            current = genresList
            self.wheelView.tickDelegate = self.genresList
            break
        case .Genre:
            current.hide(completion: { 
                
            })
            let genre = select.object as! MPMediaItemCollection!
            self.artistsList.show(withType: .Artists, andData: MediaLibrary.sharedInstance.fetchArtists(byGenre: (genre?.representativeItem?.genrePersistentID)!))
            current = self.artistsList
            self.wheelView.tickDelegate = artistsList
            break
        case .Playlist:
            playListView.show(withType: .Songs, andData: self.playlist)
            current = playListView
            wheelView.tickDelegate = playListView
            break
        case .ShuffleSongs:
            current.hide(completion: { 
                self.nowPlaying.show(type: .push)
            })
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            break
        case .NowPlaying:
            current.hide {
            }
            if self.playingIndex <= self.playlist.count && self.playlist.count > 0 {
                self.nowPlaying.show(withSong: self.playlist[self.playingIndex])
            } else {
                self.nowPlaying.show(withSong: nil)
            }
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            break
        case .CoverGallery:
            current.hide {
                self.gallery.show(type: .none)
            }
            current = gallery
            wheelView.tickDelegate = gallery
            break
        default:
            break
        }
        stack.append(current)
    }
}


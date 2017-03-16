//
//  NowPlayingViewController.swift
//  Prodigal
//
//  Created by bob.sun on 27/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import MediaPlayer
import SnapKit

class NowPlayingViewController: TickableViewController {
    
    
    var playingView: NowPlayingView = NowPlayingView()
    private var _song: MPMediaItem!
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
    }
    
    override func hide(type: AnimType = .push, completion: @escaping () -> Void) {
        self.view.isHidden = true
        completion()
    }
    
    override func show(type: AnimType) {
        self.view.isHidden = false
        PubSub.subscribe(target: self, name: PlayerTicker.kTickEvent, handler: {(notification:Notification) -> Void in
            let (current, duration) = (notification.userInfo?[PlayerTicker.kCurrent] as! Double , notification.userInfo?[PlayerTicker.kDuration] as! Double)
            let progress = Float(current) / Float(duration)
            DispatchQueue.main.async {
                self.playingView.progress.setProgress(progress, animated:true)
            }
        })
    }
    
    override func getSelection() -> MenuMeta {
        return MenuMeta()
    }

    override func onNextTick() {
        print("next tick")
    }
    override func onPreviousTick() {
        print("prev tick")
    }
    
    func show(withSong song: MPMediaItem?, type: AnimType = .push) {
        self.view.isHidden = false
        if song == nil {
            //Mark - TODO: Empty view
            return
        }
        self.song = song!
    }
    
    private func initViews() {
    }
}

class NowPlayingView: UIView {
    
    let image = UIImageView()
    let title = UILabel(), artist = UILabel(), album = UILabel(), total = UILabel(), current = UILabel()
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
        progressContainer.backgroundColor = UIColor.clear
        
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
        
        album.snp.makeConstraints { (maker) in
            maker.leading.trailing.height.equalTo(title)
            maker.centerY.equalTo(self).offset(-15)
        }
        
        artist.snp.makeConstraints { (maker) in
            maker.leading.trailing.height.equalTo(album)
            maker.centerY.equalTo(self).offset(30)
        }
    }
}

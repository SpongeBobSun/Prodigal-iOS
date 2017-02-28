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
import KYCircularProgress

class NowPlayingViewController: TickableViewController {
    
    var progressView: KYCircularProgress!
    var playingView: NowPlayingView = NowPlayingView()

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
        self.view.backgroundColor = UIColor.lightGray
    }
    
    override func hide(type: AnimType = .push, completion: @escaping () -> Void) {
        self.view.isHidden = true
        completion()
    }
    
    override func show(type: AnimType) {
        self.view.isHidden = false
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
    
    func show(withSong song: MPMediaItem?) {
        if song == nil {
            //Mark - TODO: Empty view
        }
        
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
            maker.height.equalTo(32)
        }
        
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
        title.backgroundColor = UIColor.white
        
        album.snp.makeConstraints { (maker) in
            maker.leading.trailing.height.equalTo(title)
            maker.centerY.equalTo(self).offset(-15)
        }
        album.backgroundColor = UIColor.white
        
        artist.snp.makeConstraints { (maker) in
            maker.leading.trailing.height.equalTo(album)
            maker.centerY.equalTo(self).offset(30)
        }
        
        artist.backgroundColor = UIColor.white
    }
}

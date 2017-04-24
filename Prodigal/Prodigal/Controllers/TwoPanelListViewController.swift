//
//  TwoPanelListViewController.swift
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
import Koloda
import MediaPlayer
import Haneke
import MarqueeLabel

protocol NowPlayingFetcherDelegate: class {
    func getNowPlaying() -> Any?
}

class TwoPanelListViewController: TickableViewController {
    
    weak var nowPlayingFetcherDelegate: NowPlayingFetcherDelegate?
    
    var tableView: UITableView!
    var panelView: PanelView!
    
    var items: Array<MenuMeta>!
    var albums: Array<MPMediaItemCollection>!
    var images: Dictionary<MenuMeta.MenuType, UIImage>!
    var stackCacheFormat: HNKCacheFormat!
    var timer: Timer!
    var swipeDir = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMenu()
        albums = MediaLibrary.sharedInstance.fetchAllAlbums()
        stackCacheFormat = HNKCache.shared().formats["stack"] as! HNKCacheFormat!
        
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.isUserInteractionEnabled = false
        tableView.register(TwoPanelListCell.self, forCellReuseIdentifier: TwoPanelListCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (maker) in
            maker.leading.top.bottom.equalToSuperview()
            maker.trailing.equalTo(self.view.snp.centerXWithinMargins)
        }
        

        panelView = PanelView()
        self.view.addSubview(panelView)
        panelView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(self.view.snp.centerXWithinMargins)
            maker.top.bottom.trailing.equalToSuperview()
        }
        panelView.fetcherDelegate = self.nowPlayingFetcherDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        panelView.layoutIfNeeded()
        panelView.initViews()
        panelView.stackView.delegate = self
        panelView.stackView.dataSource = self
        panelView.stackView.reloadData()
        updateRightPanel(index: current)
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(swipe), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attachTo(viewController vc: UIViewController, inView view:UIView) {
        self.tickableDelegate = self
        vc.addChildViewController(self)
        view.addSubview(self.view)
        self.view.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(view)
            maker.center.equalTo(view)
        }
        
        tableView.reloadData()
    }
    
    
    private func initMenu() {
        items = Array<MenuMeta>()
        items.append(MenuMeta(name: NSLocalizedString("Artists", comment: ""), type: .Artists))
        items.append(MenuMeta(name: NSLocalizedString("Albums", comment: ""), type: .Albums))
        items.append(MenuMeta(name: NSLocalizedString("Cover Flow", comment: ""), type: MenuMeta.MenuType.CoverGallery))
        items.append(MenuMeta(name: NSLocalizedString("Songs", comment: ""), type: .Songs))
        items.append(MenuMeta(name: NSLocalizedString("Playlists", comment: ""), type: MenuMeta.MenuType.Playlist))
        items.append(MenuMeta(name: NSLocalizedString("Genres", comment: ""), type: MenuMeta.MenuType.Genres))
        items.append(MenuMeta(name: NSLocalizedString("Local Files", comment: ""), type: MenuMeta.MenuType.LocalSongs))
        items.append(MenuMeta(name: NSLocalizedString("Shuffle Songs", comment: ""), type: MenuMeta.MenuType.ShuffleSongs))
        items.append(MenuMeta(name: NSLocalizedString("Settings", comment: ""), type: MenuMeta.MenuType.Settings))
        items.append(MenuMeta(name: NSLocalizedString("Now Playing", comment: ""), type: MenuMeta.MenuType.NowPlaying))
        items.first?.highLight = true
        
        images = [MenuMeta.MenuType.Artists: #imageLiteral(resourceName: "ic_artists"),
                  MenuMeta.MenuType.CoverGallery: #imageLiteral(resourceName: "ic_album_shelf"),
                  MenuMeta.MenuType.Songs: #imageLiteral(resourceName: "ic_songs"),
                  MenuMeta.MenuType.Settings: #imageLiteral(resourceName: "ic_settings"),
                  MenuMeta.MenuType.Genres: #imageLiteral(resourceName: "ic_genre"),
                  MenuMeta.MenuType.LocalSongs: #imageLiteral(resourceName: "ic_local"),
                  MenuMeta.MenuType.ShuffleSongs: #imageLiteral(resourceName: "ic_shuffle"),
                  MenuMeta.MenuType.Playlist: #imageLiteral(resourceName: "ic_playlist"),]
        
    }
    
    @objc public func swipe() {
        if panelView.stackView.isHidden {
            return
        }
        let direction = swipeDir ? SwipeResultDirection.left : SwipeResultDirection.right
        swipeDir = !swipeDir
        self.panelView.stackView.swipe(direction)
    }
    
    override func hide(type:AnimType = .push, completion: @escaping () -> Void) {
        
        let leftCenter = tableView.center
        let rightCenter = panelView.center
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut , animations: {
            self.tableView.center = CGPoint(x: 0 - self.tableView.bounds.width / 2, y: leftCenter.y)
            self.panelView.center = CGPoint(x: self.panelView.bounds.width * 2.5, y: rightCenter.y)
        }) { (done) in
            if done {
                self.view.isHidden = true
                self.tableView.center = leftCenter
                self.panelView.center = rightCenter
                completion()
            }
        }
    }
    
    override func show(type: AnimType) {
        let leftCenter = tableView.center
        let rightCenter = panelView.center
        
        self.tableView.center = CGPoint(x: 0 - leftCenter.x, y: leftCenter.y)
        self.panelView.center = CGPoint(x: rightCenter.x * 3, y: rightCenter.y)
        
        self.view.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut , animations: {
            self.tableView.center = leftCenter
            self.panelView.center = rightCenter
        }) { (done) in
            self.updateRightPanel(index: self.current)
        }
    }

    func updateRightPanel(index: Int) {
        let meta = items[index]
        if meta.type == .Albums {
            panelView.showStack()
            return
        } else if meta.type == .NowPlaying {
            panelView.showNowPlaying()
        } else {
            panelView.show(image: images[meta.type]!)
        }
    }
    
    override func onNextTick() {
        super.onNextTick()
        updateRightPanel(index: current)
    }
    
    override func onPreviousTick() {
        super.onPreviousTick()
        updateRightPanel(index: current)
    }
}

extension TwoPanelListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ret = tableView.dequeueReusableCell(withIdentifier: TwoPanelListCell.reuseId) as! TwoPanelListCell!
        let menu = items[indexPath.row]
        ret?.configure(meta: menu)
        return ret!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension TwoPanelListViewController: TickableViewControllerDelegate {
    func getTickable() -> UITableView {
        return tableView
    }
    func getData() -> Array<MenuMeta> {
        return items
    }
}

extension TwoPanelListViewController: KolodaViewDelegate, KolodaViewDataSource {
    
    
    func kolodaNumberOfCards(_ kolodaView: KolodaView) -> Int {
        return albums.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let size = koloda.frame.width - 32
        let ret = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        let item = albums[index].representativeItem
        ret.contentMode = .scaleAspectFill
        ret.hnk_cacheFormat = stackCacheFormat
        ret.hnk_setImage(item?.artwork?.image(at: CGSize(width: size, height: size)), withKey: String(format:"%llu", (item?.albumArtistPersistentID)!), placeholder: #imageLiteral(resourceName: "ic_album"))
        return ret
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return true
    }
}

class TwoPanelListCell: UITableViewCell {
    
    static let reuseId = "TwoPanelListCellReuseId"
    
    let title: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    private func initViews() {
        self.contentView.addSubview(title)
        title.backgroundColor = UIColor.clear
        title.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.contentView)
            maker.center.equalTo(self.contentView)
        }
        title.contentMode = .left
    }

    func configure(meta: MenuMeta) {
        title.text = meta.itemName
        if meta.highLight {
            contentView.backgroundColor = UIColor.lightGray
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
}

class PanelView: UIView {
    var imageView: UIImageView!
    var stackView: KolodaView!
    var nowPlaying: NowPlayingWidget!
    
    var fetcherDelegate: NowPlayingFetcherDelegate?
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func initViews() {
        if imageView != nil {
            return
        }
        self.clipsToBounds = true
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        let size = self.bounds.width - 32
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        stackView = KolodaView(frame: frame)
        stackView.isUserInteractionEnabled = false
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(size)
            maker.center.equalTo(self)
        }
        stackView.countOfVisibleCards = 10

        addSubview(imageView)
        
        imageView.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalTo(self)
        }
        
        nowPlaying = NowPlayingWidget()
        addSubview(nowPlaying)
        nowPlaying.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalTo(self)
        }
    }
    
    func showStack() {
        stackView.isHidden = false
        imageView.isHidden = true
        nowPlaying.isHidden = true
    }
    
    func show(image: UIImage) {
        stackView.isHidden = true
        imageView.isHidden = false
        imageView.image = image
        nowPlaying.isHidden = true
    }
    
    func showNowPlaying() {
        imageView.isHidden = true
        stackView.isHidden = true
        nowPlaying.isHidden = false
        if (fetcherDelegate == nil) {
            nowPlaying.config(media: nil)
        } else {
            var item = fetcherDelegate?.getNowPlaying()
            if item is MPMediaItem {
                nowPlaying.config(media:item as! MPMediaItem?)
            }
            if item is MediaItem {
                
            }
        }
    }
    
}

class NowPlayingWidget: UIView {
    let imageView = UIImageView()
    let title = MarqueeLabel(), album = MarqueeLabel(), artist = MarqueeLabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        addSubview(imageView)
        addSubview(title)
        addSubview(album)
        addSubview(artist)
        
        imageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.top.equalToSuperview().offset(20)
            maker.bottom.equalTo(self.snp.centerYWithinMargins).offset(16)
        }
        
        title.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottomMargin).offset(16)
            maker.leading.trailing.equalToSuperview().offset(10)
            maker.height.equalTo(20)
        }
        
        album.snp.makeConstraints { (maker) in
            maker.top.equalTo(title.snp.bottomMargin).offset(16)
            maker.leading.trailing.height.equalTo(title)
        }
        
        artist.snp.makeConstraints { (maker) in
            maker.top.equalTo(album.snp.bottomMargin).offset(16)
            maker.leading.trailing.height.equalTo(album)
        }
        
    }
    
    func config(media: MPMediaItem?) {
        if media == nil {
            imageView.image = #imageLiteral(resourceName: "ic_album")
            title.text = NSLocalizedString("Nothing", comment: "")
            artist.text = NSLocalizedString("Nobody", comment: "")
            return
        }
        imageView.image = media!.artwork?.image(at: CGSize(width: 200, height: 200)) ?? #imageLiteral(resourceName: "ic_album")
        title.text = media!.title
        artist.text = media!.artist
        album.text = media!.albumTitle
    }
    
    func config(file: MediaItem?) {
        imageView.image = #imageLiteral(resourceName: "ic_album")
        if file == nil {
            title.text = NSLocalizedString("Nothing", comment: "")
            artist.text = NSLocalizedString("Nobody", comment: "")
            return
        }
        artist.text = ""
        album.text = ""
        title.text = file?.name
    }
    
}

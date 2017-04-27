//
//  AlbumGalleryViewController.swift
//  Prodigal
//
//  Created by bob.sun on 28/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import SnapKit
import MediaPlayer
import Haneke

class AlbumGalleryViewController: TickableViewController {

    var stackLayout: AlbumGalleryLayout!
    var collection: UICollectionView!
    var albums: Array<MenuMeta>! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackLayout = AlbumGalleryLayout()
        stackLayout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: stackLayout)
        collection.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseId)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attachTo(viewController vc: UIViewController, inView view:UIView) {
        self.tickableDelegate = self
        vc.addChildViewController(self)
        view.addSubview(self.view)
        self.view.isHidden = true
        self.view.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(view)
            maker.center.equalTo(view)
        }
        self.view.addSubview(collection)
        collection.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        if albums.count == 0 {
            let data = MediaLibrary.sharedInstance.fetchAllAlbums()
            data.forEach({ (item) in
                albums.append(MenuMeta(name: item.representativeItem?.albumTitle ?? "Unkown Album", type: .Album).setObject(obj: item))
            })
        }
        let size = view.bounds.height / 2
        stackLayout.itemSize = CGSize(width: size, height: size)
        collection.reloadData()
        self.view.backgroundColor = UIColor.clear
        current = albums.count / 2
    }


    override func hide(type: AnimType, completion: @escaping AnimationCompletion) {
        self.view.isHidden = true
    }
    
    override func show(type: AnimType) {
        self.view.isHidden = false
        if current > 0 {
            collection.scrollToItem(at: IndexPath.init(row: current, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    override func onNextTick() {
        if current >= albums.count - 1{
            return
        }
        current += 1
        collection.scrollToItem(at: IndexPath(row: current, section:0), at: .centeredHorizontally, animated: true)
    }
    override func onPreviousTick() {
        if current <= 0 {
            return
        }
        current -= 1
        collection.scrollToItem(at: IndexPath(row: current, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension AlbumGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseId, for: indexPath) as! AlbumCell
        let album = albums[indexPath.row]
        cell.configure(withMenu: album)
        return cell
    }
}

extension AlbumGalleryViewController: TickableViewControllerDelegate {
    func getTickable() -> UITableView {
        fatalError("Should not call this function in gallery view controller")
    }
    func getData() -> Array<MenuMeta> {
        return self.albums
    }
}

class AlbumCell: UICollectionViewCell {
    
    static let reuseId =            "ReuseIdAlbumCollectionCell"
    
    let image = UIImageView(frame:CGRect.zero)
    let name = UILabel(frame: CGRect.zero)
    
    convenience init() {
        self.init()
        initViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        self.contentView.addSubview(image)
        self.image.snp.makeConstraints { (maker) in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-25)
        }
        self.image.hnk_cacheFormat = HNKCache.shared().formats["stack"] as! HNKCacheFormat!
        self.image.contentMode = .scaleAspectFit
        
        self.name.textAlignment = .center
        self.contentView.addSubview(self.name)
        self.name.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.image.snp.bottom).offset(5)
            maker.left.right.bottom.equalToSuperview()
        }
    }
    
    func configure(withMenu menu: MenuMeta) {
        let album = menu.object as! MPMediaItemCollection!
        image.hnk_setImage(album?.representativeItem?.artwork?.image(at: CGSize(width: 200, height: 200)), withKey: String.init(format: "%llu", album?.representativeItem?.albumPersistentID ?? -1))
        name.text = album?.representativeItem?.albumTitle
        name.textColor = ThemeManager.currentTheme.textColor
    }
}


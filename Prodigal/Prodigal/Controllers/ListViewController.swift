//
//  ListViewController.swift
//  Prodigal
//
//  Created by bob.sun on 23/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import MediaPlayer
import Haneke

class ListViewController: TickableViewController {
    
    var tableView: UITableView!
    var items: Array<MenuMeta> = []
    var playList: Array<MPMediaItem>? = nil
    var type: MenuMeta.MenuType = .Undefined
    let emptyView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.isUserInteractionEnabled = false
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (maker) in
            maker.leading.top.bottom.trailing.equalToSuperview()
        }
        self.view.addSubview(emptyView)
        emptyView.isHidden = true
        emptyView.image = #imageLiteral(resourceName: "ic_empty")
        emptyView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(150)
            maker.center.equalToSuperview()
        }
    }
    
    func show(withType type: MenuMeta.MenuType, andData data:Array<Any>, animate:Bool = true) {
        self.current = 0
        self.playList = nil
        self.type = type
        if data.count == 0 {
            //Mark - show empty view
            self.view.isHidden = false
            self.emptyView.isHidden = false
            return
        }
        self.emptyView.isHidden = true
        var hasShuffle = false
        
        switch type {
        case .Artists:
            items.removeAll()
            data.forEach({ (each) in
                items.append(MenuMeta(name: ((each as! MPMediaItemCollection).representativeItem?.artist)!, type: .Artist).setObject(obj: each))
            })
            items.first?.highLight = true
            insertShuffleAll()
            hasShuffle = true
            break
        case .Albums:
            items.removeAll()
            data.forEach({ (each) in
                items.append(MenuMeta(name: ((each as! MPMediaItemCollection).representativeItem?.albumTitle)!, type: .Album).setObject(obj: each))
            })
            items.first?.highLight = true
            insertShuffleAll()
            hasShuffle = true
            break
        case .Songs:
            items.removeAll()
            data.forEach({ (each) in
                items.append(MenuMeta(name: ((each as! MPMediaItem).title)!, type: .Song).setObject(obj: each).setObject(obj: each))
            })
            playList = data as? Array<MPMediaItem>
            items.first?.highLight = true
            insertShuffleAll()
            hasShuffle = true
            break
        case .Genres:
            items.removeAll()
            data.forEach({ (each) in
                items.append(MenuMeta(name: ((each as! MPMediaItemCollection).representativeItem?.genre)!, type: .Genre).setObject(obj: each))
            })
            items.first?.highLight = true
            break
        case .LocalSongs:
            items.removeAll()
            data.forEach({ (each) in
                items.append(MenuMeta(name: (each as! MediaItem).name, type: .LocalSong).setObject(obj: each))
            })
            items.first?.highLight = true
            break
        case .Settings:
            items.removeAll()
            let `data` = data as! Array<MenuMeta>
            items.append(contentsOf: data)
            items.first!.highLight = true
            break
        case .Themes :
            items.removeAll()
            let `data` = data as! Array<String>
            data.forEach({ (each) in
                items.append(MenuMeta(name: each, type: .Theme).setObject(obj: each))
            })
            items.first?.highLight = true
            break
        default:
            self.type = .Undefined
            break
        }
        if animate {
            let center = self.view.center
            self.view.center = CGPoint(x: center.x * 3, y: center.y)
            self.view.isHidden = false
            tableView.reloadData()
            if hasShuffle {
                tableView.scrollToRow(at: IndexPath(row: 1, section:0), at: .top, animated: false)
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.view.center = center
            }) { (done) in
            }
        } else {
            self.view.isHidden = false
            tableView.reloadData()
            if hasShuffle {
                tableView.scrollToRow(at: IndexPath(row: 1, section:0), at: .top, animated: false)
            }
        }
    }
    
    private func insertShuffleAll() {
        if items.count <= 0 {
            return
        }
        let menu: MenuMeta? = MenuMeta(name: "Shuffle All", type: .ShuffleCurrent)
        if type != .Songs && type != .Albums && type != .Artists && type != .Genres && type != .LocalSongs {
            return
        }
        items.insert(menu!, at: 0)
        current += 1
    }
    
    override func hide(type: AnimType = .push, completion: @escaping AnimationCompletion) {
        if type == .push {
            let center = self.view.center
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.view.center = CGPoint(x: 0 - center.x, y: center.y)
            }) { (done) in
                if done {
                    self.view.isHidden = true
                    self.view.center = center
                    completion()
                }
            }
        } else if type == .pop {
            let center = self.view.center
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.view.center = CGPoint(x: center.x * 3, y: center.y)
            }) { (done) in
                if done {
                    self.view.isHidden = true
                    self.view.center = center
                    completion()
                }
            }
        } else {
            self.view.isHidden = true
            completion()
        }
    }
    
    override func show(type: AnimType) {
        if type == .push {
            let center = self.view.center
            self.view.center = CGPoint(x: center.x * 3, y: center.y)
            self.view.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.view.center = center
            }) { (done) in
                if self.getData().count == 0 {
                    self.emptyView.isHidden = false
                } else {
                    self.emptyView.isHidden = true
                }
            }
        } else if type == .pop {
            let center = self.view.center
            self.view.center = CGPoint(x: 0 - center.x, y: center.y)
            self.view.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.view.center = center
            }) { (done) in
                if self.getData().count == 0 {
                    self.emptyView.isHidden = false
                } else {
                    self.emptyView.isHidden = true
                }
            }
        } else {
            self.view.isHidden = false
            tableView.reloadData()
        }
        
    }
    
    override func getSelection() -> MenuMeta {
        let ret = super.getSelection()
        if ret.type != .ShuffleCurrent {
            return ret
        }
        var list: [MPMediaItem] = []
        
        if type == .Songs {
            _ = ret.setObject(obj: (playList?.first!))
            //TODO Shuffle playlist.
            //playList.shuffle()
            current += 1
            return ret
        }
        
        switch type {
        case .Albums:
            items.forEach({ (each) in
                if each.type == .ShuffleCurrent {
                    return
                }
                guard let collection = each.object as? MPMediaItemCollection! else {
                    return
                }
                list.append(contentsOf: MediaLibrary.sharedInstance.fetchSongs(byAlbum: (collection.representativeItem?.albumPersistentID)!))
            })
            if list.count > 0 {
                self.playList = MediaLibrary.shuffle(array: list) as? Array<MPMediaItem>
                _ = ret.setObject(obj: (playList?.first!)!)
            }
            break
        case .Artists:
            items.forEach({ (each) in
                if each.type == .ShuffleCurrent {
                    return
                }
                guard let collection = each.object as? MPMediaItemCollection! else {
                    return
                }
                list.append(contentsOf: MediaLibrary.sharedInstance.fetchSongs(byArtist: (collection.representativeItem?.artistPersistentID)!))
            })
            if list.count > 0 {
                self.playList = MediaLibrary.shuffle(array: list) as? Array<MPMediaItem>
                _ = ret.setObject(obj: (playList?.first!)!)
            }
            break
        case .Genres:
            items.forEach({ (each) in
                if each.type == .ShuffleCurrent {
                    return
                }
                guard let collection = each.object as? MPMediaItemCollection! else {
                    return
                }
                list.append(contentsOf: MediaLibrary.sharedInstance.fetchSongs(byGenre: (collection.representativeItem?.genrePersistentID)!))
            })
            if list.count > 0 {
                self.playList = MediaLibrary.shuffle(array: list) as? Array<MPMediaItem>
                _ = ret.setObject(obj: (playList?.first!)!)
            }
            break
        default:
            break
        }
        return ret
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ret = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseId) as! ListCell!
        let menu = items[indexPath.row]
        ret?.configure(meta: menu, type: self.type)
        return ret!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

class ListCell: UITableViewCell {
    
    static let reuseId = "ListCellReuseId"
    
    let title: UILabel = UILabel(), value: UILabel = UILabel()
    let icon: UIImageView = UIImageView()
    
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
        self.contentView.addSubview(icon)
        self.contentView.addSubview(value)
        title.backgroundColor = UIColor.clear
        
        icon.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(0)
            maker.leading.centerY.equalToSuperview()
        }
        icon.isHidden = true
        title.snp.makeConstraints { (maker) in
            maker.leading.equalTo(icon.snp.trailing).offset(5)
            maker.top.bottom.trailing.equalToSuperview()
        }
        title.contentMode = .left
        
        value.snp.makeConstraints { (maker) in
            maker.trailing.top.bottom.equalToSuperview()
            maker.width.equalTo(100)
        }
        value.contentMode = .right
        value.text = "SettingsValue"
    }
    
    func configure(meta: MenuMeta, type: MenuMeta.MenuType) {
        title.text = meta.itemName
        switch type {
        case .Albums:
            if meta.type != .ShuffleCurrent {
                if icon.isHidden {
                    icon.snp.updateConstraints({ (maker) in
                        maker.width.height.equalTo(40)
                        maker.leading.centerY.equalToSuperview()
                    })
                    icon.isHidden = false
                }
                loadImage(meta: meta)
                value.isHidden = true
            } else {
                if !icon.isHidden {
                    icon.snp.updateConstraints({ (maker) in
                        maker.width.equalTo(0)
                    })
                    icon.isHidden = true
                }
                value.isHidden = true

            }
            break
        case .Settings:
            if !icon.isHidden {
                icon.snp.updateConstraints({ (maker) in
                    maker.width.equalTo(0)
                })
                icon.isHidden = true
            }
            value.isHidden = !(meta.type == .RepeatSettings || meta.type == .ShuffleSettings)
            break
        default:
            if !icon.isHidden {
                icon.snp.updateConstraints({ (maker) in
                    maker.width.equalTo(0)
                })
                icon.isHidden = true
            }
            value.isHidden = true
            break
        }
        
        
        if meta.highLight {
            contentView.backgroundColor = UIColor.lightGray
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    private func loadImage(meta: MenuMeta) {
        let album = (meta.object as! MPMediaItemCollection!).representativeItem
        icon.hnk_cacheFormat = HNKCache.shared().formats["list_cover"] as! HNKCacheFormat!
        icon.hnk_setImage(album?.artwork?.image(at: CGSize(width: 40, height: 40)), withKey: String(format:"%llu", (album?.albumPersistentID)!), placeholder: #imageLiteral(resourceName: "ic_album"));
    }
}


extension ListViewController: TickableViewControllerDelegate {
    func getTickable() -> UITableView {
        return tableView
    }
    func getData() -> Array<MenuMeta> {
        return items
    }
}

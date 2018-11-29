//
//  ListViewController.swift
//  Prodigal
//
//  Created by bob.sun on 23/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
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
 *  Created by bob.sun on 23/02/2017.
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
import Haneke

class ListViewController: TickableViewController {
    
    var tableView: UITableView!
    var items: Array<MenuMeta> = []
    var playList: Array<MPMediaItem>? = nil
    var type: MenuMeta.MenuType = .Undefined
    let emptyView = UIImageView()
    
    let aboutView = AboutView.viewFromNib()

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
        vc.addChild(self)
        view.addSubview(self.view)
        self.view.isHidden = true
        self.view.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(view)
            maker.center.equalTo(view)
        }
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
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
        
        self.view.addSubview(aboutView)
        aboutView.snp.makeConstraints{ (maker) in
            maker.leading.top.bottom.trailing.equalToSuperview()
        }
        aboutView.isHidden = true
    }
    
    func show(withType type: MenuMeta.MenuType, andData data:Array<Any>, animate:Bool = true) {
        self.current = 0
        self.playList = nil
        self.type = type
        if data.count == 0 && type != .About {
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
            PubSub.subOnMainThread(target: self, name: AppSettings.EventSettingsChanged, handler: { (notification) in
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)], with: .none)
            })
            break
        case .Themes :
            items.removeAll()
            let `data` = data as! Array<String>
            data.forEach({ (each) in
                items.append(MenuMeta(name: each, type: .Theme).setObject(obj: each))
            })
            items.append(MenuMeta(name: "Get More Themes!", type: .MoreTheme))
            items.first?.highLight = true
            break
        case .About:
            items.removeAll()
            aboutView.isHidden = false
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
        if self.type == .Settings {
            PubSub.unsubscribe(target: self, name: AppSettings.EventSettingsChanged)
        }
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
            _ = ret.setObject(obj: (playList?.first!)!)
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
                if let collection = each.object as? MPMediaItemCollection {
                    list.append(contentsOf: MediaLibrary.sharedInstance.fetchSongs(byAlbum: (collection.representativeItem?.albumPersistentID)!))
                }
                
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
                if let collection = each.object as? MPMediaItemCollection {
                    list.append(contentsOf: MediaLibrary.sharedInstance.fetchSongs(byArtist: (collection.representativeItem?.artistPersistentID)!))
                }
                
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
                if let collection = each.object as? MPMediaItemCollection {
                    list.append(contentsOf: MediaLibrary.sharedInstance.fetchSongs(byGenre: (collection.representativeItem?.genrePersistentID)!))
                }
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
        let ret = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseId) as! ListCell
        let menu = items[indexPath.row]
        ret.configure(meta: menu, type: self.type)
        return ret
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LIST_ITEM_VIEW_HEIGHT
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

class ListCell: UITableViewCell {
    
    static let reuseId = "ListCellReuseId"
    
    let title: UILabel = UILabel(), value: UILabel = UILabel()
    let icon: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        
        self.backgroundColor = UIColor.clear
        icon.backgroundColor = UIColor.clear
        value.backgroundColor = UIColor.clear
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
        value.textAlignment = .right
        value.text = "SettingsValue"
    }
    
    func configure(meta: MenuMeta, type: MenuMeta.MenuType) {
        title.text = meta.itemName
        
        title.textColor = ThemeManager.currentTheme.textColor
        value.textColor = ThemeManager.currentTheme.textColor
        
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
            contentView.backgroundColor = ThemeManager.currentTheme.itemColor
        } else {
            contentView.backgroundColor = UIColor.clear
        }
        
        if meta.type == .RepeatSettings {
            switch AppSettings.sharedInstance.getRepeat() {
            case .All:
                value.text = NSLocalizedString("ALL", comment: "")
                break
            case .None:
                value.text = NSLocalizedString("NONE", comment: "")
                break
            case .One:
                value.text = NSLocalizedString("ONE", comment: "")
                break
            }
        }
        if (meta.type == .ShuffleSettings) {
            switch AppSettings.sharedInstance.getShuffle() {
            case .Yes:
                value.text = NSLocalizedString("YES", comment: "")
                break
            case .No:
                value.text = NSLocalizedString("NO", comment: "")
                break
            }
        }
    }
    
    private func loadImage(meta: MenuMeta) {
        let album = (meta.object as! MPMediaItemCollection).representativeItem
        icon.hnk_cacheFormat = HNKCache.shared().formats["list_cover"] as? HNKCacheFormat
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

//
//  TwoPanelListViewController.swift
//  Prodigal
//
//  Created by bob.sun on 23/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import Koloda

class TwoPanelListViewController: TickableViewController {
    
    var tableView: UITableView!
    var panelView: PanelView!
    
    var items: Array<MenuMeta>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.view.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(view)
            maker.center.equalTo(view)
        }
        initMenu()
        
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
        tableView.reloadData()
    }
    
    
    private func initMenu() {
        items = Array<MenuMeta>()
        items.append(MenuMeta(name: NSLocalizedString("Artists", comment: ""), type: .Artists))
        items.append(MenuMeta(name: NSLocalizedString("Albums", comment: ""), type: .Albums))
        items.append(MenuMeta(name: NSLocalizedString("Cover Flow", comment: ""), type: MenuMeta.MenuType.Coverflow))
        items.append(MenuMeta(name: NSLocalizedString("Songs", comment: ""), type: .Songs))
        items.append(MenuMeta(name: NSLocalizedString("Playlists", comment: ""), type: MenuMeta.MenuType.Playlist))
        items.append(MenuMeta(name: NSLocalizedString("Genres", comment: ""), type: MenuMeta.MenuType.Genres))
        items.append(MenuMeta(name: NSLocalizedString("Shuffle Songs", comment: ""), type: MenuMeta.MenuType.ShuffleSongs))
        items.append(MenuMeta(name: NSLocalizedString("Settings", comment: ""), type: MenuMeta.MenuType.Settings))
        items.append(MenuMeta(name: NSLocalizedString("Now Playing", comment: ""), type: MenuMeta.MenuType.NowPlaying))
        items.first?.highLight = true
    }
    
    override func hide(completion: () -> Void) {
        self.view.isHidden = true
    }
    
    override func show() {
        self.view.isHidden = false
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

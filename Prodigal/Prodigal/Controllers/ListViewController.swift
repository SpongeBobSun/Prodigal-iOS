//
//  ListViewController.swift
//  Prodigal
//
//  Created by bob.sun on 23/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import MediaPlayer

class ListViewController: TickableViewController {
    
    var tableView: UITableView!
    var items: Array<MenuMeta> = []
    var playList: Array<MPMediaItem>? = nil
    var type: MenuMeta.MenuType = .Undefined

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
    }
    
    func show(withType type: MenuMeta.MenuType, andData data:Array<Any>) {
        self.current = 0
        self.playList = nil
        self.type = type
        switch type {
        case .Artists:
            items.removeAll()
            data.forEach({ (each) in
                items.append(MenuMeta(name: ((each as! MPMediaItemCollection).representativeItem?.artist)!, type: .Artist).setObject(obj: each))
            })
            items.first?.highLight = true
            break
        case .Albums:
            items.removeAll()
            data.forEach({ (each) in
                items.append(MenuMeta(name: ((each as! MPMediaItemCollection).representativeItem?.albumTitle)!, type: .Album).setObject(obj: each))
            })
            items.first?.highLight = true
            break
        case .Songs:
            items.removeAll()
            data.forEach({ (each) in
                items.append(MenuMeta(name: ((each as! MPMediaItem).title)!, type: .Song).setObject(obj: each))
            })
            playList = data as? Array<MPMediaItem>
            items.first?.highLight = true
            break
        default:
            self.type = .Undefined
            break
        }
        self.view.isHidden = false
        tableView.reloadData()
    }
    
    override func hide(completion: () -> Void) {
        self.view.isHidden = true
    }
    
    override func show() {
        self.view.isHidden = false
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ret = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseId) as! ListCell!
        let menu = items[indexPath.row]
        var image: UIImage? = nil
        if self.type == .Albums {
            image = (menu.object as! MPMediaItemCollection).representativeItem?.artwork?.image(at: CGSize(width:40, height:40))
        }
        ret?.configure(meta: menu, image: image)
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
    
    let title: UILabel = UILabel()
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
        title.backgroundColor = UIColor.clear
        
        icon.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(0)
            maker.leading.centerY.equalToSuperview()
        }
        icon.isHidden = true
        title.snp.makeConstraints { (maker) in
            maker.leading.equalTo(icon.snp.trailing)
            maker.top.bottom.trailing.equalToSuperview()
        }
        title.contentMode = .left
    }
    
    func configure(meta: MenuMeta, image: UIImage?) {
        title.text = meta.itemName
        if image == nil {
            if !icon.isHidden {
                icon.snp.updateConstraints({ (maker) in
                    maker.width.equalTo(0)
                })
                icon.isHidden = true
            }
        } else {
            if icon.isHidden {
                icon.snp.updateConstraints({ (maker) in
                    maker.width.height.equalTo(40)
                    maker.leading.centerY.equalToSuperview()
                })
                icon.isHidden = false
            }
            icon.image = image
        }
        if meta.highLight {
            contentView.backgroundColor = UIColor.lightGray
        } else {
            contentView.backgroundColor = UIColor.clear
        }
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

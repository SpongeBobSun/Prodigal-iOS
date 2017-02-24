//
//  ViewController.swift
//  Prodigal
//
//  Created by bob.sun on 17/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet weak var wheelView: WheelView!
    @IBOutlet weak var cardView: CardView!
    
    var current: TickableViewController!
    var mainMenu: TwoPanelListViewController!
    var artistsList: ListViewController!, albumsList: ListViewController!, songsList: ListViewController!, genresList: ListViewController!
    var stack: Array<TickableViewController> = Array<TickableViewController>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wheelView.delegate = self
        initChildren()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
}

extension ViewController: WheelViewDelegate {
    
    func onNext() {
        NSLog("onNext")
    }
    func onMenu() {
        if stack.count == 1 {
            return
        }
        stack.popLast()?.hide(completion: { 
            
        })
        current = stack.last
        wheelView.tickDelegate = current
        current.show()
    }
    func onPrev() {
        NSLog("onPrev")
    }
    func onPlay() {
        NSLog("onPlay")
    }
    func onSelect() {
        let select = current.getSelection()
        switch select.type! {
        case .Artists:
            self.artistsList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllArtists())
            current = self.artistsList
            self.wheelView.tickDelegate = self.artistsList
            break
        case .Albums:
            self.albumsList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllAlbums())
            current = self.albumsList
            self.wheelView.tickDelegate = self.albumsList
            break
        case .Songs:
            self.songsList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllSongs())
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
            //TODO Play
            break
        default:
            break
        }
        stack.append(current)
    }
}


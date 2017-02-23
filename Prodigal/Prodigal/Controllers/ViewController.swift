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
    var artistsList: ListViewController!
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
            self.artistsList?.show(withType: .Artists, andData: MediaLibrary.sharedInstance.fetchAllArtists())
            current = self.artistsList
            self.wheelView.tickDelegate = self.artistsList
            break
        default:
            break
        }
        stack.append(current)
    }
}


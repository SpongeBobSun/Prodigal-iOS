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
    
    var mainMenu: TwoPanelListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wheelView.delegate = self
        mainMenu = TwoPanelListViewController()
        wheelView.tickDelegate = mainMenu
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainMenu.attachTo(viewController: self, inView: cardView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: WheelViewDelegate {
    
    func onNext() {
        NSLog("onNext")
    }
    func onMenu() {
        NSLog("onMenu")
    }
    func onPrev() {
        NSLog("onPrev")
    }
    func onPlay() {
        NSLog("onPlay")
    }
    func onSelect() {
        NSLog("onSelect")
    }
}


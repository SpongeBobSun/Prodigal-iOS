//
//  ViewController.swift
//  Prodigal
//
//  Created by bob.sun on 17/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wheelView: WheelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wheelView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: WheelViewDelegate {
    func onPreviousTick() {
        NSLog("onPrevTick")
    }
    
    func onNextTick() {
        NSLog("onNextTick")
    }
    
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
}


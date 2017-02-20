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
    
    var wheelGestureRec: WheelRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wheelGestureRec = WheelRecognizer(target: self, action: nil)
        wheelGestureRec?.wheelDelegate = self
        wheelView.addGestureRecognizer(wheelGestureRec!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: WheelRecognizerDelegate {
    func onPrevious() {
        NSLog("onPrev")
    }
    
    func onNext() {
        NSLog("onNext")
    }
}


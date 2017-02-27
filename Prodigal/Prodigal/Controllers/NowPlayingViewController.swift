//
//  NowPlayingViewController.swift
//  Prodigal
//
//  Created by bob.sun on 27/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit

class NowPlayingViewController: TickableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attachTo(viewController vc: UIViewController, inView view:UIView) {
        vc.addChildViewController(self)
        view.addSubview(self.view)
        self.view.isHidden = true
        self.view.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(view)
            maker.center.equalTo(view)
        }
        self.view.backgroundColor = UIColor.lightGray
    }
    
    override func hide(completion: () -> Void) {
        self.view.isHidden = true
    }
    
    override func show() {
        self.view.isHidden = false
    }

    override func onNextTick() {
        print("next tick")
    }
    override func onPreviousTick() {
        print("prev tick")
    }
}

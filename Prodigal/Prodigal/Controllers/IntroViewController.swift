//
//  IntroViewController.swift
//  Prodigal
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
 *  Created by bob.sun on 28/04/2017.
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

import Foundation
import SnapKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var vcsWrapper: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonPrev: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    var pageViewController: UIPageViewController!
    var sb: UIStoryboard!
    var vcs: [UIViewController]!
    var current = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        sb = UIStoryboard(name: "Intro", bundle: Bundle.main)
        vcs = []
        
        for i in 0...2 {
            vcs.append(sb.instantiateViewController(withIdentifier: String(format: "IntroVC%d", i)))
        }
        
        pageViewController.delegate = self;
        pageViewController.dataSource = self;
        
        pageViewController.setViewControllers([vcs[0]], direction: .forward, animated: true, completion: nil)
        self.addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
        self.vcsWrapper.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        buttonNext.layer.cornerRadius = 25
        buttonPrev.layer.cornerRadius = 25
        buttonClose.layer.cornerRadius = 25
        current = 0
    }
    
    @IBAction func onPrev(_ sender: Any) {
        if current == 0 {
            return
        }
        current -= 1
        pageViewController.setViewControllers([vcs[current]], direction: .reverse, animated: true, completion: nil)
    }
    
    @IBAction func onNext(_ sender: Any) {
        if current == vcs.count - 1 {
            self.onClose(sender)
            return
        }
        current += 1
        pageViewController.setViewControllers([vcs[current]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func onClose(_ sender: Any) {
        AppSettings.sharedInstance.installed()
        self.dismiss(animated: true, completion: nil)
    }
}

extension IntroViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = vcs.index(of: viewController)
        if index == 0 {
            return nil
        }
        current = current - 1
        return vcs[index! - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = vcs.index(of: viewController)
        if index == vcs.count - 1 {
            return nil
        }
        current = current + 1
        return vcs[index! + 1]
    }
}

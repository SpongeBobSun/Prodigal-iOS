//
//  TickableViewController.swift
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

protocol TickableViewControllerDelegate: class {
    func getTickable() -> UITableView
    func getData() -> Array<MenuMeta>
}

typealias AnimationCompletion = () -> Void

enum AnimType {
    case pop
    case push
    case none
}

class TickableViewController: UIViewController {
    
    weak var tickableDelegate: TickableViewControllerDelegate!
    var current: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSelection() -> MenuMeta {
        let list = tickableDelegate.getData()
        if list.count == 0 {
            return MenuMeta(name: "", type: .Undefined)
        }
        return tickableDelegate.getData()[current]
    }
    
    func hide(type: AnimType = .push, completion: @escaping AnimationCompletion) {
        completion()
    }
    
    func show(type: AnimType) {
        
    }
}

extension TickableViewController: WheelViewTickDelegate {
    func onNextTick() {
        let items = tickableDelegate.getData()
        if current >= items.count - 1 {
            return
        }
        let tableView = tickableDelegate.getTickable()
        
        items[current].highLight = false
        items[current + 1].highLight = true
        tableView.reloadRows(at: [IndexPath(row: current, section: 0), IndexPath(row: current + 1, section: 0)], with: .none)
        current += 1
        tableView.scrollToRow(at: IndexPath(row: current, section: 0), at: .none, animated: true)
    }
    
    func onPreviousTick() {
        let items = tickableDelegate.getData()
        if current <= 0 {
            return
        }
        let tableView = tickableDelegate.getTickable()
        items[current].highLight = false
        items[current - 1].highLight = true
        tableView.reloadRows(at: [IndexPath(row: current, section: 0), IndexPath(row: current - 1, section: 0)], with: .none)
        current -= 1
        tableView.scrollToRow(at: IndexPath(row: current, section: 0), at: .none, animated: true)
    }

}

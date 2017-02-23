//
//  TickableViewController.swift
//  Prodigal
//
//  Created by bob.sun on 23/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit

protocol TickableViewControllerDelegate: class {
    func getTickable() -> UITableView
    func getData() -> Array<MenuMeta>
}

typealias AnimationCompletion = () -> Void

class TickableViewController: UIViewController {
    
    weak var tickableDelegate: TickableViewControllerDelegate!
    var current: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSelection() -> MenuMeta {
        return tickableDelegate.getData()[current]
    }
    
    func hide(completion: AnimationCompletion) {
        completion()
    }
    
    func show() {
        
    }
}

extension TickableViewController: WheelViewTickDelegate {
    func onNextTick() {
        let items = tickableDelegate.getData()
        if current >= items.count - 1{
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


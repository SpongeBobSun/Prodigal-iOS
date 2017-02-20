//
//  WheelView.swift
//  Prodigal
//
//  Created by bob.sun on 17/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
class WheelView: UIView {
    
    var menu: UIButton = UIButton(), prev: UIButton = UIButton(), back: UIButton = UIButton(), play : UIButton = UIButton()
    let buttons: Array<UIButton>
    
    override init(frame: CGRect) {
        buttons = [menu, prev, back, play]
        super.init(frame: frame)
        addButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        buttons = [menu, prev, back, play]
        super.init(coder: aDecoder)
        addButtons()
    }
    
    override func layoutSubviews() {
        layoutButtons()
        super.layoutSubviews()
    }
    

    override func draw(_ rect: CGRect) {
        let square = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.height, height: rect.size.height)
        let path = UIBezierPath(ovalIn: square)
        UIColor.lightGray.setFill()
        path.fill()
    }
    
    private func addButtons() {
        for b:UIButton in buttons {
            b.snp.makeConstraints({ (maker) in
                maker.width.height.equalTo(50)
            })
            addSubview(b)
        }
    }
    
    private func layoutButtons() {
        menu.snp.makeConstraints { (maker) in
            maker.centerX.top.equalTo(self)
        }
        menu.setTitle("menu", for: .normal)
        prev.snp.makeConstraints { (maker) in
            maker.centerY.left.equalTo(self)
        }
        prev.setTitle("<", for: .normal)
        back.snp.makeConstraints { (maker) in
            maker.right.centerY.equalTo(self)
        }
        back.setTitle(">", for: .normal)
        play.snp.makeConstraints { (maker) in
            maker.bottom.centerX.equalTo(self)
        }
        play.setTitle(">|", for: .normal)

    }
}

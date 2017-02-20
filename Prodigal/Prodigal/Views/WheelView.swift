//
//  WheelView.swift
//  Prodigal
//
//  Created by bob.sun on 17/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit
import SnapKit

protocol WheelViewDelegate: class {
    func onNextTick()
    func onPreviousTick()
    func onNext()
    func onMenu()
    func onPrev()
    func onPlay()
}

@IBDesignable
class WheelView: UIView {
    
    var menu: UIButton = UIButton(), prev: UIButton = UIButton(), nextButton: UIButton = UIButton(), play : UIButton = UIButton()
    let buttons: Array<UIButton>
    weak var delegate: WheelViewDelegate?
    var wheelGesture: WheelRecognizer?
    
    override init(frame: CGRect) {
        buttons = [menu, prev, nextButton, play]
        super.init(frame: frame)
        addButtons()
        makeRoll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        buttons = [menu, prev, nextButton, play]
        super.init(coder: aDecoder)
        addButtons()
        makeRoll()
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
    
    private func makeRoll() {
        wheelGesture = WheelRecognizer(target: self, action: nil)
        wheelGesture?.wheelDelegate = self;
        self.addGestureRecognizer(wheelGesture!)
    }
    
    private func layoutButtons() {
        menu.snp.makeConstraints { (maker) in
            maker.centerX.top.equalTo(self)
        }
        menu.setTitle("menu", for: .normal)
        menu.addTarget(self, action: #selector(onMenu(_:)), for: .touchUpInside)
        
        prev.snp.makeConstraints { (maker) in
            maker.centerY.left.equalTo(self)
        }
        prev.setTitle("<", for: .normal)
        prev.addTarget(self, action: #selector(onPrev(_:)), for: .touchUpInside)
        
        nextButton.snp.makeConstraints { (maker) in
            maker.right.centerY.equalTo(self)
        }
        nextButton.setTitle(">", for: .normal)
        nextButton.addTarget(self, action: #selector(onNext(_:)), for: .touchUpInside)
        
        play.snp.makeConstraints { (maker) in
            maker.bottom.centerX.equalTo(self)
        }
        play.setTitle(">|", for: .normal)
        play.addTarget(self, action: #selector(onPrev(_:)), for: .touchUpInside)
        
    }
    
    @objc private func onMenu(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.onMenu()
        }
    }
    
    @objc private func onPlay(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.onPlay()
        }
    }
    
    @objc private func onNext(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.onNext()
        }
    }
    
    @objc private func onPrev(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.onPrev()
        }
    }
}

extension WheelView: WheelRecognizerDelegate {
    func onNextTick() {
        if self.delegate != nil {
            self.delegate?.onNextTick()
        }
    }
    
    func onPreviousTick() {
        if self.delegate != nil {
            self.delegate?.onPreviousTick()
        }
    }
}

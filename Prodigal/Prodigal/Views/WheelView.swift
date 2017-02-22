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
    func onSelect()
}

@IBDesignable
class WheelView: UIView {
    
    var menu: UIButton = UIButton(), prev: UIButton = UIButton(), nextButton: UIButton = UIButton(), play : UIButton = UIButton()
    let buttons: Array<UIButton>
    var select: UIButton = UIButton()
    weak var delegate: WheelViewDelegate?
    var wheelGesture: WheelRecognizer?
    var size: CGFloat = CGFloat(0)
    
    var theme = ThemeManager().loadLastTheme()
    
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
        size = self.bounds.width > self.bounds.height ? self.bounds.height : self.bounds.width
        
        #if TARGET_INTERFACE_BUILDER
        #else
        self.snp.makeConstraints { (maker) in
            maker.width.equalTo(size)
        }
        #endif
        self.layer.cornerRadius = size / 2
        self.layer.masksToBounds = true
        super.layoutSubviews()
    }
    

    override func draw(_ rect: CGRect) {
        let size = self.size * CGFloat(theme.weight)
        let x = (self.size - size) / 2 + rect.origin.x
        let y = (self.size - size) / 2 + rect.origin.y
        let square = CGRect(x: x, y: y, width: size, height: size)
        let path = UIBezierPath(ovalIn: square)
        theme.wheelColor.setFill()
        path.fill()
    }
    
    private func addButtons() {
        for b:UIButton in buttons {
            b.snp.makeConstraints({ (maker) in
                maker.width.height.equalTo(40)
            })
            b.layer.cornerRadius = 20
            b.layer.masksToBounds = true
            addSubview(b)
        }
        addSubview(select)
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
        #if TARGET_INTERFACE_BUILDER
        #else
        menu.setImage(theme.menuIcon(), for: .normal)
        #endif
        menu.addTarget(self, action: #selector(onMenu(_:)), for: .touchUpInside)
        
        prev.snp.makeConstraints { (maker) in
            maker.centerY.left.equalTo(self)
        }
        #if TARGET_INTERFACE_BUILDER
        #else
        prev.setImage(theme.prevIcon(), for: .normal)
        #endif
        prev.addTarget(self, action: #selector(onPrev(_:)), for: .touchUpInside)
        
        nextButton.snp.makeConstraints { (maker) in
            maker.right.centerY.equalTo(self)
        }
        #if TARGET_INTERFACE_BUILDER
        #else
        nextButton.setImage(theme.nextIcon(), for: .normal)
        #endif
        nextButton.addTarget(self, action: #selector(onNext(_:)), for: .touchUpInside)
        
        play.snp.makeConstraints { (maker) in
            maker.bottom.centerX.equalTo(self)
        }
        #if TARGET_INTERFACE_BUILDER
        #else
        play.setImage(theme.playIcon(), for: .normal)
        #endif
        play.addTarget(self, action: #selector(onPrev(_:)), for: .touchUpInside)
        
        let centerSize = self.bounds.size.height * 0.3
        select.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(centerSize)
        }
        select.backgroundColor = UIColor.white
        select.layer.cornerRadius = centerSize / 2
        select.layer.masksToBounds = true
        select.addTarget(self, action: #selector(onSelect(_:)), for: .touchUpInside)
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
    
    @objc private func onSelect(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.onSelect()
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

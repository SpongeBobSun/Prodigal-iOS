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
    func onNext()
    func onMenu()
    func onPrev()
    func onPlay()
    func onSelect()
}

protocol WheelViewTickDelegate: class {
    func onNextTick()
    func onPreviousTick()
}

@IBDesignable
class WheelView: UIView {
    
    var menu: UIButton = UIButton(), prev: UIButton = UIButton(), nextButton: UIButton = UIButton(), play : UIButton = UIButton()
    let buttons: Array<UIButton>
    var select: UIButton = UIButton()
    weak var delegate: WheelViewDelegate?
    weak var tickDelegate: WheelViewTickDelegate?
    var wheelGesture: WheelRecognizer?
    var size: CGFloat = CGFloat(0)
    
    var theme = ThemeManager().loadLastTheme()
    
    override init(frame: CGRect) {
        buttons = [menu, prev, nextButton, play]
        super.init(frame: frame)
        addButtons()
        letsRoll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        buttons = [menu, prev, nextButton, play]
        super.init(coder: aDecoder)
        addButtons()
        letsRoll()
    }
    
    override func layoutSubviews() {
        size = self.bounds.width > self.bounds.height ? self.bounds.height : self.bounds.width
        layoutButtons()
        
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
        let outer = self.size * CGFloat(theme.outer)
        var x = (self.size - outer) / 2 + rect.origin.x
        var y = (self.size - outer) / 2 + rect.origin.y
        let square = CGRect(x: x, y: y, width: outer, height: outer)
        let pathOut = UIBezierPath(ovalIn: square)
        
        let inner = self.size * CGFloat(theme.inner)
        x = (size - inner) / 2 + rect.origin.x
        y = (size - inner) / 2 + rect.origin.y
        let pathIn = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: inner, height: inner))
        
        let innerLayer = CAShapeLayer()
        innerLayer.frame = self.bounds
        let mutePath = pathOut.cgPath.mutableCopy()
        mutePath?.addPath(pathIn.cgPath)
        
        innerLayer.path = mutePath
        innerLayer.fillRule = kCAFillRuleEvenOdd
        innerLayer.fillColor = theme.wheelColor.cgColor
        self.layer.insertSublayer(innerLayer, at: 0)
    }
    
    private func addButtons() {
        for b:UIButton in buttons {
            addSubview(b)
        }
        addSubview(select)
    }
    
    private func letsRoll() {
        wheelGesture = WheelRecognizer(target: self, action: nil)
        wheelGesture?.wheelDelegate = self;
        self.addGestureRecognizer(wheelGesture!)
    }
    
    private func layoutButtons() {
        let btnSize = size * CGFloat(theme.buttonSize)
        let padding = btnSize * 0.2
        for b in buttons {
            b.snp.makeConstraints({ (maker) in
                maker.width.height.equalTo(btnSize)
            })
            b.contentEdgeInsets = UIEdgeInsetsMake(padding, padding, padding, padding)
            b.backgroundColor = theme.buttonColor
            b.layer.cornerRadius = btnSize / 2
            b.layer.masksToBounds = true
        }
        
        menu.snp.makeConstraints { (maker) in
            maker.centerX.top.equalTo(self)
        }
        #if TARGET_INTERFACE_BUILDER
        #else
        menu.setImage(theme.menuIcon(), for: .normal)
        menu.setImage(theme.menuIcon(), for: .highlighted)
        #endif
        menu.addTarget(self, action: #selector(onMenu(_:)), for: .touchUpInside)
        
        prev.snp.makeConstraints { (maker) in
            maker.centerY.left.equalTo(self)
        }
        #if TARGET_INTERFACE_BUILDER
        #else
        prev.setImage(theme.prevIcon(), for: .normal)
        prev.setImage(theme.prevIcon(), for: .highlighted)
        #endif
        prev.addTarget(self, action: #selector(onPrev(_:)), for: .touchUpInside)
        
        nextButton.snp.makeConstraints { (maker) in
            maker.right.centerY.equalTo(self)
        }
        #if TARGET_INTERFACE_BUILDER
        #else
        nextButton.setImage(theme.nextIcon(), for: .normal)
        nextButton.setImage(theme.nextIcon(), for: .highlighted)
        #endif
        nextButton.addTarget(self, action: #selector(onNext(_:)), for: .touchUpInside)
        
        play.snp.makeConstraints { (maker) in
            maker.bottom.centerX.equalTo(self)
        }
        #if TARGET_INTERFACE_BUILDER
        #else
        play.setImage(theme.playIcon(), for: .normal)
        play.setImage(theme.playIcon(), for: .highlighted)
        #endif
        play.addTarget(self, action: #selector(onPlay(_:)), for: .touchUpInside)
        
        let centerSize = size * 0.3
        select.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(centerSize)
        }
        select.backgroundColor = theme.centerColor
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
    
    func loadTheme(named name:String) {
        self.theme = ThemeManager().loadThemeNamed(name:name) ?? Theme.defaultTheme()
        setNeedsDisplay()
    }
}

extension WheelView: WheelRecognizerDelegate {
    func onNextTick() {
        if self.delegate != nil {
            self.tickDelegate?.onNextTick()
        }
    }
    
    func onPreviousTick() {
        if self.delegate != nil {
            self.tickDelegate?.onPreviousTick()
        }
    }
}

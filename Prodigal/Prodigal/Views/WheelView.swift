//
//  WheelView.swift
//  Prodigal
//
//   Copyright 2017 Bob Sun
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//  Created by bob.sun on 28/03/2017.
//
//          _
//         ( )
//          H
//          H
//         _H_
//      .-'-.-'-.
//     /         \
//    |           |
//    |   .-------'._
//    |  / /  '.' '. \
//    |  \ \ @   @ / /
//    |   '---------'
//    |    _______|
//    |  .'-+-+-+|              I'm going to build my own APP with blackjack and hookers!
//    |  '.-+-+-+|
//    |    """""" |
//    '-.__   __.-'
//         """
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
        
        self.layer.masksToBounds = true
        super.layoutSubviews()
    }
    

    override func draw(_ rect: CGRect) {
        switch theme.shape {
        case .Oval:
            drawWheel(forOval: rect)
            break
        case .Rect:
            drawWheel(forRect: rect)
            break
        case .Polygon:
            drawWheel(forPolygon: rect)
            break
        }
        
    }
    
    private func drawWheel(forOval rect:CGRect) {
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
        self.layer.cornerRadius = size / 2
    }
    
    private func drawWheel(forRect rect:CGRect) {
        let outer = self.size * CGFloat(theme.outer)
        var x = (self.size - outer) / 2 + rect.origin.x
        var y = (self.size - outer) / 2 + rect.origin.y
        let pathOut = UIBezierPath(rect: CGRect(x: x, y: y, width: outer, height: outer))
        
        let inner = self.size * CGFloat(theme.inner)
        x = (size - inner) / 2 + rect.origin.x
        y = (size - inner) / 2 + rect.origin.y
        let pathIn = UIBezierPath(rect: CGRect(x: x, y: y, width: inner, height: inner))
        
        let innerLayer = CAShapeLayer()
        innerLayer.frame = self.bounds
        let mutePath = pathOut.cgPath.mutableCopy()
        mutePath?.addPath(pathIn.cgPath)
        
        innerLayer.path = mutePath
        innerLayer.fillRule = kCAFillRuleEvenOdd
        innerLayer.fillColor = theme.wheelColor.cgColor
        self.layer.insertSublayer(innerLayer, at: 0)
        self.layer.cornerRadius = 0
    }
    
    private func drawWheel(forPolygon rect:CGRect) {
        let outer = self.size * CGFloat(theme.outer)
        var x = (self.size - outer) / 2 + rect.origin.x
        var y = (self.size - outer) / 2 + rect.origin.y
        let pathOut = UIBezierPath(polygonIn: CGRect(x: x, y: y, width: outer, height: outer),
                                   sides: theme.sides)
        
        let inner = self.size * CGFloat(theme.inner)
        x = (size - inner) / 2 + rect.origin.x
        y = (size - inner) / 2 + rect.origin.y
        let pathIn = UIBezierPath(polygonIn: CGRect(x: x, y: y, width: inner, height: inner), sides: theme.sides)
        
        let innerLayer = CAShapeLayer()
        innerLayer.frame = self.bounds
        let mutePath = pathOut.cgPath.mutableCopy()
        mutePath?.addPath(pathIn.cgPath)
        
        innerLayer.path = mutePath
        innerLayer.fillRule = kCAFillRuleEvenOdd
        innerLayer.fillColor = theme.wheelColor.cgColor
        
        self.layer.insertSublayer(innerLayer, at: 0)
        self.layer.cornerRadius = 0
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
        self.backgroundColor = UIColor.clear
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
        if (self.layer.sublayers?.count ?? 0 > 0) {
            self.layer.sublayers?.first?.removeFromSuperlayer()
        }
        switch self.theme.shape {
        case .Oval:
            select.layer.cornerRadius = select.bounds.height / 2
            break
        case .Rect:
            select.layer.cornerRadius = 0
            break
        case .Polygon:
            select.layer.cornerRadius = 0
            break
        }
        select.backgroundColor = theme.shape == .Polygon ? UIColor.clear : theme.centerColor
        setNeedsDisplay()
        layoutIfNeeded()
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

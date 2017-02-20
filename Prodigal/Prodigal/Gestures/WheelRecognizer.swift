//
//  WheelRecognizer.swift
//  Prodigal
//
//  Created by bob.sun on 17/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

protocol WheelRecognizerDelegate: class {
    func onNextTick()
    func onPreviousTick()
}

//No target is required in this gesture recognizer
class WheelRecognizer: UIGestureRecognizer {
    
    var startDeg: Double
    let degPerTick: Double = 72
    var ticked: Bool
    weak var wheelDelegate: WheelRecognizerDelegate?
    
    override init(target: Any?, action: Selector?) {
        self.startDeg = Double.nan
        ticked = false
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        let center = CGPoint(x: (self.view?.frame.size.width)! / 2, y: (self.view?.frame.size.height)! / 2)
        let location = touches.first?.location(in: self.view)
        let x = Double((location?.x)! / (center.x * 2))
        let y = Double((location?.y)! / (center.y * 2))
        
        startDeg = xyToDegrees(x: x, y: y)
        state = .began
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        if ticked {
            state = .ended
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first
        let rect = self.view?.frame
        let location = touch?.location(in: self.view)
        let currentDeg = xyToDegrees(x: Double(((location?.x)! - (((rect?.width)! - (rect?.height)!) / 2)) / (rect?.height)!) ,
                                     y: Double((location?.y)! / (rect?.height)!))
        if !currentDeg.isNaN {
            
            let deltaDeg = startDeg - currentDeg
            if abs(deltaDeg) < degPerTick {
                return
            }
            let ticks = copysign(1.0, deltaDeg) * floor(abs(deltaDeg) / degPerTick)
            if ticks == 1 {
                ticked = true
                state = .changed
                if (self.wheelDelegate != nil) {
                    self.wheelDelegate?.onNextTick()
                }
            }
            if ticks == -1 {
                ticked = true
                state = .changed
                if (self.wheelDelegate != nil) {
                    self.wheelDelegate?.onPreviousTick()
                }
            }
        }
        startDeg = currentDeg
    }
    
    func xyToDegrees(x: Double, y:Double) -> Double {
        var ret = Double.nan
        let `x` = x - 0.5
        let `y` = y - 0.5
        let distanceFromCenter = sqrt(x * x + y * y)
        if (distanceFromCenter < 0.15
            || distanceFromCenter > 0.5) { // ignore center and out of bounds events
            return ret
        } else {
            ret = atan2(x, y) * 180 / M_PI
        }
        return ret
    }

}

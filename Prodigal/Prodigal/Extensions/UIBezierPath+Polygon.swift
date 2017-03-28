//
//  UIBezierPath+Polygon.swift
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
//      _
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

extension UIBezierPath {
    convenience init(polygonIn rect:CGRect, sides:Int) {
        self.init()
        if sides < 3 {
            assertionFailure("To build a polygon you need 3 ou more sides")
        }
        
        let xRadius = rect.width/2
        let yRadius = rect.height/2
        
        let centerX = rect.midX
        let centerY = rect.midY
        
        self.move(to: CGPoint(x: centerX + xRadius, y: centerY + 0))
        
        for i in 0..<sides {
            let theta = CGFloat(2 * Double.pi) / CGFloat(sides) * CGFloat(i)
            let xCoordinate = centerX + xRadius * cos(theta)
            let yCoordinate = centerY + yRadius * sin(theta)
            self.addLine(to: CGPoint(x: xCoordinate, y: yCoordinate))
        }
        self.close()
    }
}

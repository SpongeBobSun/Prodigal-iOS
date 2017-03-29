//
//  UIImage+Blur.swift
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
//  Created by bob.sun on 29/03/2017.
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
import CoreImage


extension UIImage {
    static func getBlured(image: UIImage, withRadius radius: Int) -> UIImage {

        guard let blur = CIFilter(name: "CIGaussianBlur") else {
            return image
        }
        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(radius, forKey: kCIInputRadiusKey)
        
        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage!
        
        let boundingRect = CGRect(x:0,
                                  y: 0,
                                  width: image.size.width,
                                  height: image.size.height)
        
        let ciContext  = CIContext(options: nil)
        let cgImage = ciContext.createCGImage(result!, from: boundingRect)
        
        return UIImage(cgImage: cgImage!)
    }
    
    static func getBlured(image: UIImage) -> UIImage {
        return getBlured(image: image, withRadius: 4)
    }
}

//
//  CardView.swift
//  Prodigal
//
//  Created by bob.sun on 21/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable
    var elevation: CGFloat = 0
    var cornerRadius: CGFloat = 0
    
    init() {
        super.init(frame: CGRect.zero)
        initLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayer()
    }
    
    private func initLayer() {
        self.layer.shadowColor = UIColor.gray.cgColor;
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.8;
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.masksToBounds = false;
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  DesignableButtonField.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/6/18.
//  Copyright © 2018 Kevin Cheng. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableButtonField: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }

}

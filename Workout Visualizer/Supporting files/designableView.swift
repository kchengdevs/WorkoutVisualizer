//
//  designableView.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/17/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit

class designableView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0
        {
        didSet
        {
            layer.cornerRadius = cornerRadius
        }
    }
}

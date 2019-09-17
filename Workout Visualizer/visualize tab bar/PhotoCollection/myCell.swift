//
//  myCell.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/16/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit

class myCell: UICollectionViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.myImageView.image = nil
    }
}

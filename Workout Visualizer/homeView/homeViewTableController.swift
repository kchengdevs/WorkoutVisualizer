//
//  homeViewTableController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 8/16/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct homeViewWorkouts {
    let sets: String!
    let reps: String!
    let workout: String!
    let key: String!
    let day: String!
    
    let itemRef: DatabaseReference?

    init(snapshot: DataSnapshot) {
        key = snapshot.key
        
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let workoutsnap = snapshotValue?["workout"] as? String {
            workout = workoutsnap
        } else {
            workout = ""
        }
        if let setssnap = snapshotValue?["sets"] as? String {
            sets = setssnap
        } else {
            sets = ""
        }
        if let repssnap = snapshotValue?["reps"] as? String {
            reps = repssnap
        } else {
            reps = ""
        }
        if let daysnap = snapshotValue?["day"] as? String {
            day = daysnap
        } else {
            day = ""
        }
    }
}


class homeViewTableController: UITableViewCell {
    
    @IBOutlet weak var workoutLabel: UILabel!
    
    @IBOutlet weak var workoutSets: UILabel!
    
    @IBOutlet weak var workoutReps: UILabel!
    
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var setlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        workoutLabel.adjustsFontSizeToFitWidth = true
        workoutLabel.minimumScaleFactor = 0.1
        workoutReps.adjustsFontSizeToFitWidth = true
        workoutReps.minimumScaleFactor = 0.1
        workoutSets.adjustsFontSizeToFitWidth = true
        workoutSets.minimumScaleFactor = 0.1
        setlabel.adjustsFontSizeToFitWidth = true
        setlabel.minimumScaleFactor = 0.1
        repsLabel.adjustsFontSizeToFitWidth = true
        repsLabel.minimumScaleFactor = 0.1
        self.selectionStyle = UITableViewCellSelectionStyle.none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


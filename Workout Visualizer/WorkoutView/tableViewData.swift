//
//  tableViewData.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 8/10/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct workouts {
    let sets: String!
    let reps: String!
    let workout: String!
    let key: String!
    let day: String!
    
    let itemRef: DatabaseReference?
    
    init(workout: String, sets: String, reps: String, day: String, key: String) {
        self.workout = workout
        self.sets = sets
        self.reps = reps
        self.key = key
        self.day = day
        self.itemRef = nil
    }
    
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

class tabelViewCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workoutNumberLabel: UILabel!
    
    @IBOutlet weak var workoutLabel: UILabel!
    
    @IBOutlet weak var sets: UILabel!
    
    @IBOutlet weak var reps: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        workoutLabel.adjustsFontSizeToFitWidth = true
        workoutLabel.minimumScaleFactor = 0.1
        reps.adjustsFontSizeToFitWidth = true
        reps.minimumScaleFactor = 0.1
        sets.adjustsFontSizeToFitWidth = true
        sets.minimumScaleFactor = 0.1
        self.selectionStyle = UITableViewCellSelectionStyle.none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  workoutDays.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 8/9/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class workoutDays: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var dismissButton: hexagonButton!
    
    var dbref: DatabaseReference!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var addWorkoutOptionsView: UIView!
    
    @IBOutlet weak var addWorkoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dismissAdditionAlpha: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var labelText: String!
    
    var circleOriginPoint: CGPoint!
    
    @IBAction func dismissAddition(_ sender: Any) {
        handleDismiss()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        performSegue(withIdentifier: "dismiss", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dismiss" {
            (segue as? OHCircleSegue)?.shouldUnwind = true
            (segue as? OHCircleSegue)?.circleOrigin = circleOriginPoint
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbref = Database.database().reference().child("users").child(userID).child("Workouts")
        loadDatabase()
        
        dayLabel.text = labelText
        if let window = UIApplication.shared.keyWindow {
            addWorkoutConstraint.constant = -window.frame.width
        }
        addWorkoutOptionsView.layer.cornerRadius = 10
        workoutTextView.layer.cornerRadius = 10

    }
    
    @IBAction func addWorkout(_ sender: Any) {
        selection = 1
        display()
    }
    
    func display() {
        self.addWorkoutConstraint.constant = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            self.addWorkoutOptionsView.alpha = 1
            self.dismissAdditionAlpha.alpha = 0.5
        }, completion: nil)
    }
    
    @IBAction func dismissAddWorkout(_ sender: Any) {
        handleDismiss()
    }
    
    
    var selectedCell = tabelViewCellTableViewCell()
    
    var index: String?
    var selection: Int?
    
    @IBAction func doneAddWorkout(_ sender: Any) {
        if selection == 1 {
            if workoutTextView.text != "" && workoutSets.text != "" && workoutReps.text != "" {
                let workout = workoutTextView.text
                let sets = workoutSets.text
                let reps = workoutReps.text
                let day = labelText
                let key = self.dbref.childByAutoId().key
                let image = ["workout": workout!, "sets": sets!, "reps": reps!, "day": day!, "keys": key] as [String : Any]
                
                let childUpdate = ["/\(key)": image]
                dbref.updateChildValues(childUpdate)
                loadDatabase()
                handleDismiss()
            }
            fieldCheck()
            workoutTextView.text = ""
            workoutSets.text = ""
            workoutReps.text = ""
        } else if selection == 2 {
            if workoutTextView.text != "" && workoutSets.text != "" && workoutReps.text != "" {
                let workout = workoutTextView.text
                let sets = workoutSets.text
                let reps = workoutReps.text
                let datareference = Database.database().reference().child("users").child(userID).child("Workouts").child("\(index!)")
                datareference.child("sets").setValue(sets)
                datareference.child("reps").setValue(reps)
                datareference.child("workout").setValue(workout)
                loadDatabase()
                handleDismiss()
            }
            fieldCheck()
            workoutTextView.text = ""
            workoutSets.text = ""
            workoutReps.text = ""
        }
        
    }
    
    func fieldCheck() {
        if workoutTextView.text == "" {
            let alert = UIAlertController(title: "Missing Field", message: "Please enter a workout", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (ACTION) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else if workoutSets.text == "" {
            let alert = UIAlertController(title: "Missing Field", message: "Please enter a number of Sets", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (ACTION) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else if workoutReps.text == "" {
            let alert = UIAlertController(title: "Missing Field", message: "Please enter a number of repetitions", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (ACTION) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var workoutTextView: UITextView!
    
    @IBOutlet weak var workoutSets: DesignableTextField!
    
    @IBOutlet weak var workoutReps: DesignableTextField!
    
    @IBOutlet weak var workoutView: UITableView!
    
    var workoutArray = [workouts]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! tabelViewCellTableViewCell
        
        cell.workoutNumberLabel?.text = "\(indexPath.row + 1)"
        cell.workoutLabel?.text = workoutArray[indexPath.row].workout
        cell.reps?.text = workoutArray[indexPath.row].reps
        cell.sets?.text = workoutArray[indexPath.row].sets
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = (tableView.cellForRow(at: indexPath) as? tabelViewCellTableViewCell)!
        workoutTextView.text = selectedCell.workoutLabel.text
        workoutSets.text = selectedCell.sets.text
        workoutReps.text = selectedCell.reps.text
        selection = 2
        index = workoutArray[indexPath.row].key

        display()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            let workout = workoutArray[indexPath.row]
            let datareference = Database.database().reference().child("users").child(userID).child("Workouts").child("\(workout.key!)")
            datareference.setValue(nil)
            workoutArray.remove(at: indexPath.row)
            workoutView.reloadData()
        }
    }
    
    func loadDatabase() {
        let dbref = Database.database().reference().child("users").child(userID).child("Workouts")
        dbref.observe(DataEventType.value, with: { (snapshot) in
            var newImages = [workouts]()
            
            for stuff in snapshot.children {
                let items = workouts(snapshot: stuff as! DataSnapshot)
                if items.day == self.labelText {
                    newImages.append(items)
                }
            }
            self.workoutArray = newImages
            self.workoutView.reloadData()
        })
    }
    
    func handleDismiss() {
        if let window = UIApplication.shared.keyWindow {
            addWorkoutConstraint.constant = -window.frame.width
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.addWorkoutOptionsView.alpha = 0
            self.dismissAdditionAlpha.alpha = 0
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}



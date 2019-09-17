//
//  HomeViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/7/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var workoutArray = [homeViewWorkouts]()
    
    @IBOutlet weak var workoutView: UITableView!
    
    @IBOutlet weak var workoutScheduleLabel: UILabel!
    
    @IBOutlet weak var settingsView: UIView!

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var workoutButton: UIButton!
    
    @IBOutlet weak var visualizeButton: UIButton!
    
    @IBOutlet weak var contactButton: UIButton!
    
    @IBAction func returnHome(_ sender: Any) {
        handleDismiss()
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (ACTION) in
            try! Auth.auth().signOut()
            self.performSegue(withIdentifier: "backToLogin", sender: self)
            imageArray.removeAll()

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (ACTION) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Settings View and dismissing it
    @IBAction func menuAction(_ sender: Any) {
        showSettings()
    }
    
   
    @IBOutlet weak var settingsViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundButtonAlpha: UIButton!
    
    @IBAction func dismissButton(_ sender: Any) {
        handleDismiss()
    }
    
    func showSettings() {
        self.settingsViewConstraint.constant = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            self.settingsView.alpha = 1
            self.backgroundButtonAlpha.alpha = 1
        }, completion: nil)
    }
    
    func handleDismiss() {
        settingsViewConstraint.constant = -76
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.settingsView.alpha = 0
            self.backgroundButtonAlpha.alpha = 0
        })
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
        
        settingsView.layer.shadowColor = UIColor.gray.cgColor
        settingsView.layer.shadowOffset = .zero
        settingsView.layer.shadowOpacity = 1
        settingsView.layer.shadowPath = UIBezierPath(rect: settingsView.bounds).cgPath
        
        workoutScheduleLabel.adjustsFontSizeToFitWidth = true
        dateLabel.adjustsFontSizeToFitWidth = true
        workoutScheduleLabel.minimumScaleFactor = 0.1
        dateLabel.minimumScaleFactor = 0.1
        
        loadDatabase()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeWorkoutCell", for: indexPath) as! homeViewTableController

        cell.workoutLabel?.text = workoutArray[indexPath.row].workout
        cell.workoutReps?.text = workoutArray[indexPath.row].reps
        cell.workoutSets?.text = workoutArray[indexPath.row].sets
        cell.configureCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return workoutView.frame.height/5
    }
    
    
    
    
    func loadDatabase() {
        let dbref = Database.database().reference().child("users").child(userID).child("Workouts")
        dbref.observe(DataEventType.value, with: { (snapshot) in
            var newImages = [homeViewWorkouts]()
            let weekday = Calendar.current.component(.weekday, from: Date())
            var weekdayString = String()
            if weekday == 1 {
                weekdayString = "Sunday"
            } else if weekday == 2{
                weekdayString = "Monday"
            } else if weekday == 3{
                weekdayString = "Tuesday"
            } else if weekday == 4{
                weekdayString = "Wednesday"
            } else if weekday == 5{
                weekdayString = "Thursday"
            } else if weekday == 6{
                weekdayString = "Friday"
            } else if weekday == 7{
                weekdayString = "Saturday"
            }
            
            
            for stuff in snapshot.children {
                let items = homeViewWorkouts(snapshot: stuff as! DataSnapshot)
                if items.day == weekdayString {
                    newImages.append(items)
                }
            }
            self.workoutArray = newImages
            self.workoutView.reloadData()
        })
    }
}

extension homeViewTableController {
    func configureCell() {
        self.contentView.layer.cornerRadius = self.contentView.layer.frame.height / 6
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.backgroundColor = UIColor.rgb(r: 23, g: 52, b: 84)
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}

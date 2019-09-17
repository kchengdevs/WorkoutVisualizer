//
//  workoutViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/10/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class workoutViewController: UIViewController {
    
    @IBOutlet weak var settingsView: UIView!
    
    @IBAction func workoutButton(_ sender: Any) {
        handleDismiss()
    }

    @IBAction func logoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (ACTION) in
            try! Auth.auth().signOut()
            self.performSegue(withIdentifier: "workoutToLogin", sender: self)
            imageArray.removeAll()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (ACTION) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func openSettings(_ sender: Any) {
        showSettings()
    }
    
    @IBAction func dismissSettings(_ sender: Any) {
        handleDismiss()
    }
    
    @IBOutlet weak var backgroundButtonAlpha: UIButton!
    
    func showSettings() {
        
        self.settingsConstraint.constant = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            self.settingsView.alpha = 1
            self.backgroundButtonAlpha.alpha = 1
        }, completion: nil)
    }
    
    @IBOutlet weak var settingsConstraint: NSLayoutConstraint!
    
    func handleDismiss() {
        settingsConstraint.constant = -76
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.settingsView.alpha = 0
            self.backgroundButtonAlpha.alpha = 0
        })
    }
    
    @IBOutlet weak var sundayHexagon: hexagonButton!
    
    @IBOutlet weak var MondayButton: hexagonButton!
    
    @IBOutlet weak var TuesdayButton: hexagonButton!
    
    @IBOutlet weak var WednesdayButton: hexagonButton!
    
    @IBOutlet weak var ThursdayButton: hexagonButton!
    
    @IBOutlet weak var FridayButton: hexagonButton!
    
    @IBOutlet weak var SaturdayButton: hexagonButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView.layer.shadowColor = UIColor.gray.cgColor
        settingsView.layer.shadowOffset = .zero
        settingsView.layer.shadowOpacity = 1
        settingsView.layer.shadowPath = UIBezierPath(rect: settingsView.bounds).cgPath
        
        sundayHexagon.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 11, 0)
        MondayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 11, 0)
        TuesdayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 11, 0)
        WednesdayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 11, 0)
        ThursdayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 11, 0)
        FridayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 11, 0)
        SaturdayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 11, 0)
        
        sundayHexagon.titleLabel?.adjustsFontSizeToFitWidth = true
        MondayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        TuesdayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        WednesdayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        ThursdayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        FridayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        SaturdayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        sundayHexagon.titleLabel?.minimumScaleFactor = 0.1
        MondayButton.titleLabel?.minimumScaleFactor = 0.1
        TuesdayButton.titleLabel?.minimumScaleFactor = 0.1
        WednesdayButton.titleLabel?.minimumScaleFactor = 0.1
        ThursdayButton.titleLabel?.minimumScaleFactor = 0.1
        FridayButton.titleLabel?.minimumScaleFactor = 0.1
        SaturdayButton.titleLabel?.minimumScaleFactor = 0.1
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sun" {
            if let graph = segue.destination as? workoutDays{
                (segue as! OHCircleSegue).circleOrigin = sundayHexagon.convert(sundayHexagon.center, to: self.view)
                graph.circleOriginPoint = sundayHexagon.convert(sundayHexagon.center, to: self.view)
                graph.labelText = "Sunday"
            }
        } else if segue.identifier == "mon" {
            if let graph = segue.destination as? workoutDays{
                (segue as! OHCircleSegue).circleOrigin = MondayButton.convert(MondayButton.center, to: self.view)
                graph.circleOriginPoint = MondayButton.convert(MondayButton.center, to: self.view)
                graph.labelText = "Monday"
            }
        } else if segue.identifier == "tue" {
            if let graph = segue.destination as? workoutDays{
                (segue as! OHCircleSegue).circleOrigin = TuesdayButton.convert(TuesdayButton.center, to: self.view)
                graph.circleOriginPoint = TuesdayButton.convert(TuesdayButton.center, to: self.view)
                graph.labelText = "Tuesday"
            }
        } else if segue.identifier == "wed" {
            if let graph = segue.destination as? workoutDays{
                (segue as! OHCircleSegue).circleOrigin = WednesdayButton.convert(WednesdayButton.center, to: self.view)
                graph.circleOriginPoint = WednesdayButton.convert(WednesdayButton.center, to: self.view)
                graph.labelText = "Wednesday"
            }
        } else if segue.identifier == "thu" {
            if let graph = segue.destination as? workoutDays{
                (segue as! OHCircleSegue).circleOrigin = ThursdayButton.convert(ThursdayButton.center, to: self.view)
                graph.circleOriginPoint = ThursdayButton.convert(ThursdayButton.center, to: self.view)
                graph.labelText = "Thursday"
            }
        } else if segue.identifier == "fri" {
            if let graph = segue.destination as? workoutDays{
                (segue as! OHCircleSegue).circleOrigin = FridayButton.convert(FridayButton.center, to: self.view)
                graph.circleOriginPoint = FridayButton.convert(FridayButton.center, to: self.view)
                graph.labelText = "Friday"
            }
        } else if segue.identifier == "sat" {
            if let graph = segue.destination as? workoutDays{
                (segue as! OHCircleSegue).circleOrigin = SaturdayButton.convert(SaturdayButton.center, to: self.view)
                graph.circleOriginPoint = SaturdayButton.convert(SaturdayButton.center, to: self.view)
                graph.labelText = "Saturday"
            }
        }
        
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        handleDismiss()
    }
    
    
}

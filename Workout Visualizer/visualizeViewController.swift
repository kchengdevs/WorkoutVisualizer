//
//  visualizeViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/10/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class visualizeViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var percentageLabel: UILabel!
    
    var ref: DatabaseReference!
    
    var handle: DatabaseHandle!
    
    @IBOutlet weak var settingsView: UIView!

    @IBOutlet weak var goalText: UILabel!
    
    var circleEndAngle: CGFloat! = 0
    
    //Edit Goal Alert
    
    @IBAction func editGoalAction(_ sender: Any) {
        alertMessage(Title: "Set Goal", message: "Please enter a numerical weight goal value")
    }
    
    @IBAction func visualizeButton(_ sender: Any) {
        handleDismiss()
    }

    @IBAction func logoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (ACTION) in
            try! Auth.auth().signOut()
            self.performSegue(withIdentifier: "visualizeToLogin", sender: self)
            imageArray.removeAll()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (ACTION) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func openSettings(_ sender: Any) {
        self.settingsConstraint.constant = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            self.settingsView.alpha = 1
            self.backgroundButtonAlpha.alpha = 1
        }, completion: nil)
    }
    
    @IBAction func backgroundButton(_ sender: Any) {
        handleDismiss()
    }
    
    @IBOutlet weak var backgroundButtonAlpha: UIButton!
    
    @IBOutlet weak var settingsConstraint: NSLayoutConstraint!
    
    
    func handleDismiss() {
        settingsConstraint.constant = -76
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.settingsView.alpha = 0
            self.backgroundButtonAlpha.alpha = 0
        })
    }
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Reset", message: "Are you sure you want to reset your goal and progress indicator?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { (ACTION) in
            self.ref.child("users").child(userID).child("first").setValue(nil)
            self.ref.child("users").child(userID).child("current").setValue(nil)
            self.ref.child("users").child(userID).child("goal").setValue(nil)
            self.goalText.text = "Set a goal"
            self.percentageLabel.text = "0%"
            self.shapelayer.removeFromSuperlayer()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (ACTION) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.fillColor = fillColor.cgColor
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        return layer
    }

    var pulsatingLayer: CAShapeLayer!
    var shapelayer = CAShapeLayer()
    var center = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add personal information to database
        setupNotificationObservers()

        settingsView.layer.shadowColor = UIColor.gray.cgColor
        settingsView.layer.shadowOffset = .zero
        settingsView.layer.shadowOpacity = 1
        settingsView.layer.shadowPath = UIBezierPath(rect: settingsView.bounds).cgPath
        
        
        
    
        
        
        //Animation for the progress bar layer
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)

        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        //Create underlying trakc layer for progress bar
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)

        
        view.layer.addSublayer(trackLayer)
        center = CGPoint(x: -25 , y: 0)
        
        
        view.bringSubview(toFront: resetButton)
        view.bringSubview(toFront: percentageLabel)
        view.bringSubview(toFront: backgroundButtonAlpha)
        view.bringSubview(toFront: settingsView)
    
    }
    
    func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation,forKey: "pulsing")
    }
    
    @objc private func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapelayer.add(basicAnimation, forKey: "basic")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        updateCircle()
        animatePulsatingLayer()
        handleTap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        handleDismiss()
    }
    
    func alertMessage (Title: String, message: String){
        
        
        
        ref = Database.database().reference()
        
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ACTION) in
            let textField = alert.textFields![0] as UITextField// Force unwrapping because we know it exists.
            
            if(CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: (textField.text!)))) {
                self.ref.child("users/\(userID)/goal").setValue(textField.text!)
                self.ref.child("users").child(userID).child("goal").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let item = snapshot.value as? String {
                        self.goalText.text = "\(item) lbs"
                    }
                    
                    
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            self.updateCircle()
        }))

        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateCircle() {
        ref = Database.database().reference()
        
        
        
        ref.child("users").child(userID).child("goal").observeSingleEvent(of: .value, with: { (snapshot) in
            if let goal = snapshot.value as? String {
                self.goalText.text = "\(goal) lbs"
                if let goalInt = Int(goal) {
                    self.ref.child("users").child(userID).child("first").observeSingleEvent(of: .value, with: {(snapshot) in
                        if let firstWeight = snapshot.value as? String {
                            if let firstInt = Int(firstWeight) {
                                self.ref.child("users").child(userID).child("current").observeSingleEvent(of: .value, with: {(snapshot) in
                                    if let currentWeight = snapshot.value as? String {
                                        if let currentInt = Int(currentWeight) {
                                            if currentInt > firstInt && currentInt < goalInt {
                                                let percentage = Int((CGFloat(currentInt - firstInt) /
                                                    CGFloat(goalInt - firstInt)) * 100)
                                                self.percentageLabel.text =
                                                "\(percentage)%"
                                                self.circleEndAngle = 2 * CGFloat.pi * CGFloat(CGFloat(percentage)/CGFloat(100))
                                                let circularPath = UIBezierPath(arcCenter: self.center, radius: 100, startAngle: 0, endAngle: self.circleEndAngle, clockwise: true)
                                                
                                                //Progress bar layer
                                                
                                                self.shapelayer.path = circularPath.cgPath
                                                self.shapelayer.strokeEnd = 0
                                                
                                                self.shapelayer.fillColor = UIColor.clear.cgColor
                                                self.shapelayer.strokeColor = UIColor.outlineStrokeColor.cgColor
                                                self.shapelayer.lineWidth = 20
                                                self.shapelayer.lineCap = kCALineCapRound
                                                self.shapelayer.position = self.view.center
                                                self.shapelayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
                                                
                                                self.shapelayer.removeFromSuperlayer()
                                                
                                                
                                                
                                                self.view.bringSubview(toFront: self.resetButton)
                                                self.view.bringSubview(toFront: self.percentageLabel)
                                                self.view.bringSubview(toFront: self.backgroundButtonAlpha)
                                                self.view.bringSubview(toFront: self.settingsView)
                                                self.view.layer.addSublayer(self.shapelayer)
                                                
                                                self.handleTap()
                                                
                                            } else if currentInt == goalInt || currentInt > goalInt{
                                                self.ref.child("users").child(userID).child("first").setValue(nil)
                                                self.ref.child("users").child(userID).child("current").setValue(nil)
                                                self.ref.child("users").child(userID).child("goal").setValue(nil)
                                                self.shapelayer.removeFromSuperlayer()
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    })
                }
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
}

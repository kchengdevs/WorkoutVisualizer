//
//  contactUsViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/10/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import StoreKit
import MessageUI

class contactUsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var workoutEmail: UIButton!
    
    @IBOutlet weak var settingsView: UIView!
    
    @IBAction func sendEmailClicked(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["WorkoutVisualizer@gmail.com"])
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func contactButton(_ sender: Any) {
        handleDismiss()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (ACTION) in
            try! Auth.auth().signOut()
            self.performSegue(withIdentifier: "contactToLogin", sender: self)
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
    
    @IBOutlet weak var backgroundButtonAlpha: UIButton!
    
    @IBAction func dismissButton(_ sender: Any) {
        handleDismiss()
    }
    
    @IBOutlet weak var settingsViewConstraint: NSLayoutConstraint!
    
    
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
        
        settingsView.layer.shadowColor = UIColor.gray.cgColor
        settingsView.layer.shadowOffset = .zero
        settingsView.layer.shadowOpacity = 1
        settingsView.layer.shadowPath = UIBezierPath(rect: settingsView.bounds).cgPath
        workoutEmail.titleLabel?.adjustsFontSizeToFitWidth = true
        workoutEmail.titleLabel?.minimumScaleFactor = 0.1
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

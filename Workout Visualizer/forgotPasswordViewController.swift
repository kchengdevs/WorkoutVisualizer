//
//  forgotPasswordViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 8/18/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class forgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var instruction1: UILabel!
    @IBOutlet weak var instruction2: UILabel!
    @IBOutlet weak var emailTextField: DesignableTextField!
    
    @IBAction func sendEmailResetPassword(_ sender: Any) {
        if emailTextField.text == nil {
            let alert = UIAlertController(title: "Empty Field", message: "Please enter a valid email", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (ACTION) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: nil)
            performSegue(withIdentifier: "sendEmail", sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        instruction1.adjustsFontSizeToFitWidth = true
        instruction1.minimumScaleFactor = 0.1
        instruction2.adjustsFontSizeToFitWidth = true
        instruction2.minimumScaleFactor = 0.1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
}

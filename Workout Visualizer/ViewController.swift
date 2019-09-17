//
//  ViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 6/27/18.
//  Copyright © 2018 Kevin Cheng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: DesignableTextField!
    
    @IBOutlet weak var passwordTextField: DesignableTextField!
    
    @IBOutlet weak var loginButton: DesignableButtonField!
    
    @IBAction func signUpAction(_ sender: Any) {
        performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: {(user1, error) in
            if let user = Auth.auth().currentUser {
                if !user.isEmailVerified {
                    if self.usernameTextField.text != "" && self.passwordTextField.text != "" {
                        let alert = UIAlertController(title: "Email Verification", message: "Your email address has not been verified yet. Would you like us to send another verfication email?", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Resend", style: .default, handler: { (ACTION) in
                            user.sendEmailVerification(completion: nil)
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (ACTION) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    if user1 != nil && error == nil{
                        self.performSegue(withIdentifier: "homeSegue", sender: self)
                    }
                    else {
                        
                        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                            self.loginButton.center.x += 10
                        }, completion: nil)
                        
                        UIView.animate(withDuration: 0.1, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                            self.loginButton.center.x -= 20
                        }, completion: nil)
                        
                        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                            self.loginButton.center.x += 10
                        }, completion: nil)
                        
                        if let myError = error?.localizedDescription {
                            self.alertMessage(Title: "Error", message: myError)
                        }
                    }
                }
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
               self.performSegue(withIdentifier: "homeSegue", sender: self)
            }
        }
    }
    
    //Creates alert
    func alertMessage (Title: String, message: String){
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


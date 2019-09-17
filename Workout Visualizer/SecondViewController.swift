//
//  SecondViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/6/18.
//  Copyright © 2018 Kevin Cheng. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import FirebaseDatabase



class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: DesignableTextField!
    
    @IBOutlet weak var passwordTextField: DesignableTextField!
    
    @IBOutlet weak var verifyPasswordTextField: DesignableTextField!
    
    //Returns to login screen if there is text in all fields
    @IBAction func createAccount(_ sender: UIButton) {
        if (emailTextField.text != "" && passwordTextField.text != "" && verifyPasswordTextField.text != "" && verifyPasswordTextField.text == passwordTextField.text) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if user != nil && error == nil
                {
                    if let user = Auth.auth().currentUser {
                        let alert = UIAlertController(title: "Email Verification", message: "We just need to verify your email address. Check your email to verify account.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (ACTION) in
                            user.sendEmailVerification(completion: nil)
                            self.performSegue(withIdentifier: "backToLogin", sender: self)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    if let myError = error?.localizedDescription
                    {
                        self.alertMessage(Title: "Error", message: myError)
                    }
                }
            })
        }
        else if (emailTextField.text == "") {
            alertMessage(Title: "Missing Field", message: "Please enter an email")
        }
        else if (passwordTextField.text == "") {
            alertMessage(Title: "Missing Field", message: "Please enter a password")
        }
        else if (verifyPasswordTextField.text == "") {
            alertMessage(Title: "Missing Field", message: "Please verify your password")
        }
        else if(verifyPasswordTextField.text != passwordTextField.text) {
            alertMessage(Title: "Not Matching", message: "Please make sure that your passwords match")
        }
            
    }
    
    //returns back to login screen
    @IBAction func backToLogin(_ sender: Any) {
        performSegue(withIdentifier: "backToLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        verifyPasswordTextField.delegate = self
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
        return true
    }
    
    //Create Alert message
    func alertMessage (Title: String, message: String){
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}

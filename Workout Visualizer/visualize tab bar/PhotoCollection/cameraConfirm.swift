//
//  cameraConfirm.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/17/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import UIKit
import Firebase

class cameraConfirm: UIViewController {

    
    @IBOutlet weak var photo: UIImageView!
    
    var saveimage: UIImage?
    
    var image: UIImage!
    
    @IBOutlet weak var weightTextField: DesignableTextField!
    
    @IBOutlet weak var weightViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weightView: UIView!
    
    @IBAction func cancelButton(_ sender: Any) {
        handleDismiss()
    }
    
    @IBOutlet weak var backgroundButtonAlpha: UIButton!
    
    @IBAction func dismiss(_ sender: Any) {
        handleDismiss()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("users").child("\(userID)").child("images").child("\(imageName).png")
        
        let image1 = image.fixedOrientation()
        guard let imageData = UIImageJPEGRepresentation(image1!, 0.4) else {return}
        
        _ = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                return
            }
            
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                
                let ref = Database.database().reference()
                let usersReference = ref.child("users").child(userID).child("images")
                
                let key = usersReference.childByAutoId().key
                let image = ["url": downloadURL.absoluteString, "key": imageName]
                
                let childUpdate = ["/\(key)": image]
                usersReference.updateChildValues(childUpdate)
            }
        }
        let ref = Database.database().reference()
        ref.child("users").child(userID).child("first").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false {
                ref.child("users").child(userID).child("first").setValue(self.weightTextField.text!)
            }
        })
        ref.child("users").child(userID).child("current").setValue(weightTextField.text!)
    }
    @IBAction func usePhotoButton(_ sender: Any) {
        self.weightViewConstraint.constant = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            self.weightView.alpha = 1
            self.backgroundButtonAlpha.alpha = 1
        }, completion: nil)
    }
    
    func handleDismiss() {
        if let window = UIApplication.shared.keyWindow {
            weightViewConstraint.constant = -window.frame.width
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.weightView.alpha = 0
            self.backgroundButtonAlpha.alpha = 0
        })
    }
    
    @IBAction func retakePhoto(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back" {
            if let goto = segue.destination as? cameraViewController {
                goto.outlineImageSet = saveimage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        // Do any additional setup after loading the view.
        weightView.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

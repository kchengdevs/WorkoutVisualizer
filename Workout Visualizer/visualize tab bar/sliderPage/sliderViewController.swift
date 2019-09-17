//
//  sliderViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/31/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SDWebImage
import FirebaseDatabase

class sliderViewController: UIViewController {
    
    @IBOutlet weak var comparisonView: UIView!
    
    @IBOutlet weak var tabBar: UITabBarItem!
    
    @IBAction func exportImage(_ sender: Any) {
        let alert = UIAlertController(title: "Save", message: "Would you like to export this image to your photo library", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { (ACTION) in
            let imageSave = self.comparisonView.asImage()
            let imageData = UIImagePNGRepresentation(imageSave)
            let compresedImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (ACTION) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    lazy var firstImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var secondImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    
    fileprivate lazy var firstWrapper: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    fileprivate lazy var thumbWrapper: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    fileprivate lazy var thumbImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "Slider icon")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    fileprivate var leading: NSLayoutConstraint!
    
    fileprivate var originRect: CGRect!
    
    lazy fileprivate var setupLeadingAndOriginRect: Void = {
        self.leading.constant = comparisonView.frame.width / 2
        comparisonView.layoutIfNeeded()
        self.originRect = self.firstWrapper.frame
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = setupLeadingAndOriginRect
    }
    
    @IBAction func setImageTwo(_ sender: Any) {
        if imageArray.count < 2 {
            let alert = UIAlertController(title: "No Images", message: "Please make sure that you have at least two images in your photo collection", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (ACTION) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            tabSelection = 2
            tabBarController?.selectedIndex = 1
            sliderArray.removeAll()
            let tabBarControllerItems = self.tabBarController?.tabBar.items
            
            if let tabArray = tabBarControllerItems {
                let tabBarItem1 = tabArray[0]
                let tabBarItem2 = tabArray[1]
                let tabBarItem3 = tabArray[2]
                let tabBarItem4 = tabArray[3]
                
                tabBarItem1.isEnabled = false
                tabBarItem2.isEnabled = false
                tabBarItem3.isEnabled = false
                tabBarItem4.isEnabled = false
            }
        }
        
    }
    
    let emptyImage = UIImageView()
    let emptyImage2 = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        thumbWrapper.alpha = 0.5
        
        comparisonView.layoutIfNeeded()
        originRect = firstWrapper.frame
        
        firstImage.translatesAutoresizingMaskIntoConstraints = false
        firstWrapper.translatesAutoresizingMaskIntoConstraints = false
        
        firstWrapper.addSubview(firstImage)
        comparisonView.addSubview(secondImage)
        comparisonView.addSubview(firstWrapper)
        let black = UIColor.init(white: 1.0, alpha: 0.5)
        firstWrapper.layer.borderColor = black.cgColor
        firstWrapper.layer.borderWidth = 1.2
        secondImage.layer.borderWidth = 1.2
        secondImage.layer.borderColor = black.cgColor
        
        thumbWrapper.addSubview(thumbImage)
        comparisonView.addSubview(thumbWrapper)
        
        NSLayoutConstraint.activate([
            
            secondImage.topAnchor.constraint(equalTo: comparisonView.topAnchor, constant: 0),
            secondImage.bottomAnchor.constraint(equalTo: comparisonView.bottomAnchor, constant: 0),
            secondImage.trailingAnchor.constraint(equalTo: comparisonView.trailingAnchor, constant: 0),
            secondImage.leadingAnchor.constraint(equalTo: comparisonView.leadingAnchor, constant: 0)
            ])
        

        
        leading = firstWrapper.leadingAnchor.constraint(equalTo: comparisonView.leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            firstWrapper.topAnchor.constraint(equalTo: comparisonView.topAnchor, constant: 0),
            firstWrapper.bottomAnchor.constraint(equalTo: comparisonView.bottomAnchor, constant: 0),
            firstWrapper.trailingAnchor.constraint(equalTo: comparisonView.trailingAnchor, constant: 0),
            leading
            ])
        
        NSLayoutConstraint.activate([
            firstImage.topAnchor.constraint(equalTo: firstWrapper.topAnchor, constant: 0),
            firstImage.bottomAnchor.constraint(equalTo: firstWrapper.bottomAnchor, constant: 0),
            firstImage.trailingAnchor.constraint(equalTo: firstWrapper.trailingAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            thumbWrapper.topAnchor.constraint(equalTo: firstWrapper.topAnchor, constant: 0),
            thumbWrapper.bottomAnchor.constraint(equalTo: firstWrapper.bottomAnchor, constant: 0),
            thumbWrapper.leadingAnchor.constraint(equalTo: firstWrapper.leadingAnchor, constant: -20),
            thumbWrapper.widthAnchor.constraint(equalToConstant: 40)
            ])
        
        NSLayoutConstraint.activate([
            thumbImage.centerXAnchor.constraint(equalTo: thumbWrapper.centerXAnchor, constant: 0),
            thumbImage.centerYAnchor.constraint(equalTo: thumbWrapper.centerYAnchor, constant: 0),
            thumbImage.widthAnchor.constraint(equalTo: thumbWrapper.widthAnchor, multiplier: 1),
            thumbImage.heightAnchor.constraint(equalTo: thumbWrapper.widthAnchor, multiplier: 1)
            ])
        
        leading.constant = comparisonView.frame.width / 2
        
        thumbImage.layer.cornerRadius = 20
        firstImage.widthAnchor.constraint(equalTo: comparisonView.widthAnchor, multiplier: 1).isActive = true
        
        let tap = UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        thumbWrapper.isUserInteractionEnabled = true
        thumbWrapper.addGestureRecognizer(tap)
        
        secondImage.backgroundColor = UIColor.lightGray
        
        emptyImage2.image = UIImage(named: "no image")
        emptyImage2.frame = CGRect(x: comparisonView.frame.width/4 - 50, y: comparisonView.frame.height/2 - 50, width: 100, height: 100)
        if secondImage.image == nil {
            secondImage.addSubview(emptyImage2)
        }
        
        firstWrapper.backgroundColor = UIColor.lightGray
        emptyImage.image = UIImage(named: "no image")
        emptyImage.frame = CGRect(x: comparisonView.frame.width/4 - 50, y: comparisonView.frame.height/2 - 50, width: 100, height: 100)
        if firstImage.image == nil {
           firstWrapper.addSubview(emptyImage)
        }
        
    }

    
    @objc func gesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: comparisonView)
        switch sender.state {
        case .began, .changed:
            var newLeading = originRect.origin.x + translation.x
            newLeading = max(newLeading, 20)
            newLeading = min(comparisonView.frame.width - 20, newLeading)
            leading.constant = newLeading
            comparisonView.layoutIfNeeded()
        case .ended, .cancelled:
             originRect = firstWrapper.frame
        default: break
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if !sliderArray.isEmpty {
            firstImage.image = sliderArray[0]
            secondImage.image = sliderArray[1]
            emptyImage.removeFromSuperview()
            emptyImage2.removeFromSuperview()
        }
    }
}

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

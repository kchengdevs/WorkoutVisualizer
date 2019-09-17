//
//  timeLapseViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 8/3/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit

class timelapseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var SpeedSlider: UISlider!
    
    @IBAction func changeSpeed(_ sender: Any) {
        timelapse.animationDuration = TimeInterval(Float(timelapseArray.count) * SpeedSlider.value)
        timelapse.startAnimating()
    }
    
    @IBOutlet weak var timelapse: UIImageView!
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    @IBAction func addImage(_ sender: Any) {
        if imageArray.count < 2 {
            let alert = UIAlertController(title: "No Images", message: "Please make sure that you have more than one image in your photo collection", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (ACTION) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            tabSelection = 3
            tabBarController?.selectedIndex = 1
            timelapseArray.removeAll()
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
    
    @IBOutlet weak var timelapseCollectionView: UICollectionView!
    
    @IBOutlet weak var dismissEditor: UIButton!
    
    @IBOutlet weak var hiddenCollectionViewConstraint: NSLayoutConstraint!
    
    @IBAction func editButton(_ sender: Any) {
        
        timelapseCollectionView.reloadData()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.dismissEditor.alpha = 0.5
            self.hiddenCollectionViewConstraint.constant = -10
        })
    }
    
    @IBAction func dismissEditorButton(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.dismissEditor.alpha = 0
            self.hiddenCollectionViewConstraint.constant = self.timelapseCollectionView.frame.height
        })
        
    }
    
    var emptyImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyImage.image = UIImage(named: "no image")
        emptyImage.frame = CGRect(x: (self.view.frame.width/2) - 50, y: (self.view.frame.height/2) - 50, width: 100, height: 100)
        if timelapse.image == nil {
            timelapse.addSubview(emptyImage)
        }
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        timelapseCollectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if !timelapseArray.isEmpty {
            timelapse.animationImages = timelapseArray
            timelapse.animationDuration = TimeInterval(Float(timelapseArray.count) * SpeedSlider.value)
            timelapse.startAnimating()
            emptyImage.removeFromSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timelapseArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timelapseCell", for: indexPath) as! timelapseCell
        
        cell.imageView.image = timelapseArray[indexPath.row]
        cell.configureCell()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 10
        let width = height * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.configureCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.configureCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        timelapseArray.insert(timelapseArray.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
        timelapse.animationImages = timelapseArray
        timelapse.startAnimating()
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = timelapseCollectionView.indexPathForItem(at: gesture.location(in: timelapseCollectionView)) else {
                break
            }
            timelapseCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            timelapseCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            timelapseCollectionView.endInteractiveMovement()
        default:
            timelapseCollectionView.cancelInteractiveMovement()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension UICollectionViewCell {
    func configureCell() {
        self.contentView.layer.cornerRadius = self.contentView.layer.frame.height / 6
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}

extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImageOrientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}

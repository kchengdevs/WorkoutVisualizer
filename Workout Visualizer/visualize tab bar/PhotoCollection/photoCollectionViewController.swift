//
//  photoCollectionViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/15/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Firebase
import SDWebImage
import FirebaseDatabase


let userID = Auth.auth().currentUser!.uid

//Array for storing images
var imageArray = [insta]()

var tabSelection = 1

var imageSelected: UIImage?

var timelapseArray = [UIImage]()

var sliderArray = [UIImage]()

class photoCollectionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    var dbref: DatabaseReference!
    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var photoOptionsPreview: UIView!
    
    var selectedCell: myCell!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var cropImageOutline: UIImageView!
    
    @IBOutlet weak var photoOptionCancelAlpha: UIButton!
    
    @IBAction func exportButtonPhotoLibrary(_ sender: Any) {
        let alert = UIAlertController(title: "Save", message: "Would you like to export this image to your photo library", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { (ACTION) in
            let imageData = UIImagePNGRepresentation(self.previewImage.image!)
            let compresedImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (ACTION) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        if tabSelection == 2 {
            if (collectionView.indexPathsForSelectedItems?.count)! < 2 {
                let alert = UIAlertController(title: "Invalid Selection", message: "Please select two images", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (ACTION) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                tabBarController?.selectedIndex = 2
                let selected = collectionView.indexPathsForSelectedItems
                for items in selected! {
                    let subviews = collectionView.cellForItem(at: items)?.subviews
                    subviews![1].removeFromSuperview()
                }
                tabSelection = 1
                loadDatabase()
                doneButton.alpha = 0
                enableTabBar()
            }
        } else if tabSelection == 3 {
            if timelapseArray.count < 2 {
                let alert = UIAlertController(title: "Invalid Selection", message: "Please select more than one image", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (ACTION) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
               tabBarController?.selectedIndex = 3
                let selected = collectionView.indexPathsForSelectedItems
                for items in selected! {
                    let subviews = collectionView.cellForItem(at: items)?.subviews
                    subviews![1].removeFromSuperview()
                }
                tabSelection = 1
                loadDatabase()
                doneButton.alpha = 0
                enableTabBar()
            }
        }
    }
    
    var highlight = UIView()
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectionIndicator = UILabel()
        selectionIndicator.font = UIFont(name: "LoveloLineBold", size: 25)
        selectedCell = collectionView.cellForItem(at: indexPath) as? myCell
        if tabSelection == 1 {
            self.collectionView.allowsMultipleSelection = false
            UIScrollView.animate(withDuration: 0.3, animations: {
                self.scrollView.alpha = 1
            })
            previewImage.image = selectedCell.myImageView.image
            photoOptionsPreview.alpha = 1
        } else if tabSelection == 2 {
            if (self.collectionView.indexPathsForSelectedItems?.count)! > 2 {
                return
            } else {
                let highlight = UIView()
                highlight.backgroundColor = UIColor.white
                highlight.alpha = 0.7
                let selectedSymbol = UIImageView()
                self.collectionView.allowsMultipleSelection = true
                highlight.frame = selectedCell.frame
                highlight.center = selectedCell.contentView.center
                sliderArray.append(selectedCell.myImageView.image!)
                selectedSymbol.image = UIImage(named: "selected symbol")
                selectedSymbol.frame = CGRect(x: (selectedCell.frame.width/2) - (selectedCell.frame.width/4), y: (selectedCell.frame.height/2) - (selectedCell.frame.height/4), width: selectedCell.frame.width/2, height: selectedCell.frame.height/2)
                selectedSymbol.center = selectedCell.contentView.center
                highlight.addSubview(selectedSymbol)
                selectedCell.addSubview(highlight)
            }
            
        } else if tabSelection == 3 {
            let highlight = UIView()
            highlight.backgroundColor = UIColor.white
            highlight.alpha = 0.7
            self.collectionView.allowsMultipleSelection = true
            highlight.frame = selectedCell.frame
            highlight.center = selectedCell.contentView.center
            timelapseArray.append(selectedCell.myImageView.image!)
            selectionIndicator.text = "\(timelapseArray.index(of: selectedCell.myImageView.image!)! + 1)"
            selectionIndicator.frame = CGRect(x: selectedCell.frame.width/2 - 30, y: selectedCell.frame.height/2 - 30, width: 60, height: 60)
            highlight.addSubview(selectionIndicator)
            selectedCell.addSubview(highlight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? myCell
        if tabSelection == 1 {
            highlight.center = selectedCell.contentView.center
        } else if tabSelection == 2 {
            if (self.collectionView.indexPathsForSelectedItems?.count)! > 2 {
                return
            } else if sliderArray.contains(selectedCell.myImageView.image!){
                let index = sliderArray.index(of: selectedCell.myImageView.image!)
                sliderArray.remove(at: index!)
                let subview = selectedCell.subviews
                subview[1].removeFromSuperview()
            }
            
        } else if tabSelection == 3 {
            if !timelapseArray.isEmpty {
                let index = timelapseArray.index(of: selectedCell.myImageView.image!)
                timelapseArray.remove(at: index!)
                let subview = selectedCell.subviews
                subview[1].removeFromSuperview()
                let selectedItems = collectionView.indexPathsForSelectedItems
                for items in selectedItems! {
                    let cell = collectionView.cellForItem(at: items) as? myCell
                    let subviews = cell?.subviews
                    for subview in subviews![1].subviews as [UIView] {
                        if let labelView = subview as? UILabel {
                            labelView.text = "\(timelapseArray.index(of: (cell?.myImageView.image!)!)! + 1)"
                        }
                    }
                }
            }
        }
    }
    
    func enableTabBar() {
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[0]
            let tabBarItem2 = tabArray[1]
            let tabBarItem3 = tabArray[2]
            let tabBarItem4 = tabArray[3]
            
            tabBarItem1.isEnabled = true
            tabBarItem2.isEnabled = true
            tabBarItem3.isEnabled = true
            tabBarItem4.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tabSelection == 2 {
            
        }
        return indexPath
    }
    
    @IBAction func deletePhotoButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this photo?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (ACTION) in
            
            let ref = Database.database().reference().child("users").child(userID).child("images")
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for stuff in snapshot.children {
                    let items = insta(snapshot: stuff as! DataSnapshot)
                    let urlString: String! =  "\(self.selectedCell.myImageView.sd_imageURL()!)"
                    if items.url! == urlString {
                        let keyRef = ref.child(items.key!)
                        keyRef.child("key").observeSingleEvent(of: .value, with: {(snapshot) in
                            if let item = snapshot.value as? String {
                                let storageRef = Storage.storage().reference().child("users").child(userID).child("images").child("\(item).png")
                                storageRef.delete { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("success")
                                    }
                                }
                            }
                        })
                        keyRef.setValue(nil)
                    }
                }
                
                self.loadDatabase()
                self.dismissScrollView((Any).self)

            })
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (ACTION) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func dismissScrollView(_ sender: Any) {
        UIScrollView.animate(withDuration: 0.3, animations: {
            self.scrollView.alpha = 0
            self.photoOptionsPreview.alpha = 0
        })
    }
    
    //Display Camera Options
    
    
    var selection = 0
    
    
    @IBOutlet weak var denyActionButton: UIButton!
    
    @IBOutlet weak var centerPopupConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundButtonAlpha: UIButton!
    
    var imageIdentifier: UIImage?
    
    @IBAction func frontCameraButton(_ sender: Any) {
        if selection == 0{
            prepareImage(image: "body outline")
        } else if selection == 1 {
            addOutline(image: "body outline")
        }
        selection = 0
        photoOptionCancelAlpha.alpha = 1
    }
    
    @IBAction func legCameraButton(_ sender: Any) {
        if selection == 0{
            prepareImage(image: "legs front")
        } else if selection == 1 {
            addOutline(image: "legs front")
        }
        selection = 0
        photoOptionCancelAlpha.alpha = 1
    }
    
    @IBAction func backCameraButton(_ sender: Any) {
        if selection == 0{
            prepareImage(image: "body outline")
        } else if selection == 1 {
            addOutline(image: "body outline")
        }
        selection = 0
        photoOptionCancelAlpha.alpha = 1
    }
    
    @IBAction func fullSideButton(_ sender: Any) {
        if selection == 0{
            prepareImage(image: "full body side")
        } else if selection == 1 {
            addOutline(image: "full body side")
        }
        selection = 0
        photoOptionCancelAlpha.alpha = 1
    }
    
    @IBAction func legSideButton(_ sender: Any) {
        if selection == 0{
            prepareImage(image: "legs")
        } else if selection == 1 {
            addOutline(image: "legs")
        }
        selection = 0
        photoOptionCancelAlpha.alpha = 1
    }
    
    @IBAction func upperSideButton(_ sender: Any) {
        if selection == 0{
            prepareImage(image: "side body")
        } else if selection == 1 {
            addOutline(image: "side body")
        }
        selection = 0
        photoOptionCancelAlpha.alpha = 1
    }
    
    @IBAction func fullBodyButton(_ sender: Any) {
        if selection == 0{
            prepareImage(image: "full body")
        } else if selection == 1 {
            addOutline(image: "full body")
        }
        selection = 0
        photoOptionCancelAlpha.alpha = 1
    }
    
    @IBAction func noneButton(_ sender: Any) {
        if selection == 0 {
            imageIdentifier = nil
            performSegue(withIdentifier: "openCamera", sender: self)
            denyActionButton.alpha = 0
        } else if selection == 1{
            handleDismiss()
            cropImageOutline.image = nil
            cropImageOutline.alpha = 1
            denyActionButton.alpha = 0
        }
        selection = 0
        photoOptionCancelAlpha.alpha = 1
    }
    
    func addOutline(image: String) {
        handleDismiss()
        cropImageOutline.alpha = 1
        cropImageOutline.image = UIImage(named: "\(image)")
        denyActionButton.alpha = 0
    }
    
    func prepareImage(image: String) {
        imageIdentifier = UIImage(named: "\(image)")
        performSegue(withIdentifier: "openCamera", sender: self)
    }
    
    @IBAction func backgroundButton(_ sender: Any) {
        handleDismiss()
    }
    @IBAction func dismissCameraOptions(_ sender: Any) {
        handleDismiss()
    }
    
    @IBAction func displayCameraOption(_ sender: Any) {
        selection = 0
        deselectAll()
        centerPopupConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.photoOptionsView.alpha = 1
            self.backgroundButtonAlpha.alpha = 1
        })
    }
    
    @IBOutlet weak var photoOptionsView: designableView!
    
    
    //Area where images are displayed
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func importPhoto(_ sender: Any) {
        deselectAll()
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: false, completion: nil)
        let imageName = NSUUID().uuidString
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let image1 = image.fixedOrientation()
            let imageStorageRef = Storage.storage().reference().child("users").child("\(userID)").child("images").child("\(imageName).png")
            
            guard let imageData = UIImageJPEGRepresentation(image1!, 0.4) else {return}
            
            _ = imageStorageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
                
                
                // You can also access to download URL after upload.
                imageStorageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }

                    
                    let key = self.dbref.childByAutoId().key
                    let image = ["url": downloadURL.absoluteString, "key": imageName]
                    
                    let childUpdate = ["/\(key)": image]
                    self.dbref.updateChildValues(childUpdate)
                }
            }
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbref = Database.database().reference().child("users").child(userID).child("images")
        loadDatabase()
    
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if tabSelection == 2 {
            doneButton.alpha = 1
        } else if tabSelection == 3 {
            doneButton.alpha = 1
            
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return previewImage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        
        let image = imageArray[indexPath.row]
        
        cell.myImageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named: "loadImage"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func handleDismiss() {
        if let window = UIApplication.shared.keyWindow {
            centerPopupConstraint.constant = -window.frame.width
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.photoOptionsView.alpha = 0
            self.backgroundButtonAlpha.alpha = 0
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadDatabase() {
        let dbref = Database.database().reference().child("users").child(userID).child("images")
        dbref.observe(DataEventType.value, with: { (snapshot) in
            var newImages = [insta]()
            
            for stuff in snapshot.children {
                let items = insta(snapshot: stuff as! DataSnapshot)
                newImages.append(items)
            }
            imageArray = newImages
            self.collectionView.reloadData()
        })
    }
    
    @IBAction func editPhoto(_ sender: Any) {
        selection = 1
        centerPopupConstraint.constant = 0
        photoOptionCancelAlpha.alpha = 0
        denyActionButton.alpha = 0.3
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.photoOptionsView.alpha = 1
        })
        cropOptions.alpha = 0.5
        photoOptionsPreview.alpha = 0
    }
    
    @IBOutlet weak var cropArea: CropAreaView!
    
    var croppedArea:CGRect{
        get{
            let factor = previewImage.image!.size.width/view.frame.width
            let scale = 1/scrollView.zoomScale
            let imageFrame = previewImage.imageFrame()
            let x = (scrollView.contentOffset.x + cropArea.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + cropArea.frame.origin.y - imageFrame.origin.y) * scale * factor
            let width = cropArea.frame.size.width * scale * factor
            let height = cropArea.frame.size.height * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    
    @IBOutlet weak var cropOptions: UIView!
    
    @IBAction func cropImageCancel(_ sender: Any) {
        photoOptionsPreview.alpha = 1
        cropOptions.alpha = 0
        cropImageOutline.alpha = 0
    }
    
    @IBAction func crop(_ sender: UIButton) {
        let croppedCGImage = previewImage.image?.cgImage?.cropping(to: croppedArea)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("users").child("\(userID)").child("images").child("\(imageName).png")
        
        guard let imageData = UIImageJPEGRepresentation(croppedImage, 0.4) else {return}
        
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
        loadDatabase()
        scrollView.zoomScale = 1
        UIScrollView.animate(withDuration: 0.3, animations: {
            self.scrollView.alpha = 0
            self.cropOptions.alpha = 0
        })
        cropImageOutline.alpha = 0
    }
    
    func deselectAll() {
        if tabSelection == 2 {
            if !sliderArray.isEmpty {
                sliderArray.removeAll()
                let selectedItems = collectionView.indexPathsForSelectedItems
                for items in selectedItems! {
                    let cell = collectionView.cellForItem(at: items) as? myCell
                    let subviews = cell?.subviews
                    subviews![1].removeFromSuperview()
                }
            }
        } else if tabSelection == 3 {
            if !timelapseArray.isEmpty {
                timelapseArray.removeAll()
                let selectedItems = collectionView.indexPathsForSelectedItems
                for items in selectedItems! {
                    let cell = collectionView.cellForItem(at: items) as? myCell
                    let subviews = cell?.subviews
                    subviews![1].removeFromSuperview()
                }
            }
        }
        loadDatabase()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openCamera" {
            if let goto = segue.destination as? cameraViewController {
                goto.outlineImageSet = imageIdentifier
            }
        }
    }
}

extension UIImageView{
    func imageFrame()->CGRect{
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else{return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }else{
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}

class CropAreaView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}



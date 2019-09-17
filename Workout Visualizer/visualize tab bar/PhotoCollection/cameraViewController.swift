//
//  cameraViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/17/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import UIKit
import AVFoundation

class cameraViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice?
    
    var frontCamera: AVCaptureDevice?
    
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    var outlineImageSet: UIImage?
    
    @IBOutlet weak var outlineImage: UIImageView!
    
    var switchflip = 1
    
    @IBAction func flipOutlineButton(_ sender: Any) {
        if switchflip == 1 {
            let prepareflip = outlineImage.image
            
            let image = UIImage(cgImage: prepareflip!.cgImage!, scale: 1.0, orientation: UIImageOrientation.upMirrored)
            outlineImage.image = image
            switchflip = 2
        } else if switchflip == 2{
            outlineImage.image = outlineImageSet
            switchflip = 1
        }
        
    }
    
 
    
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevices() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }
            else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
        
        
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        //view size
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    @IBAction func rotateImage(_ sender: Any) {
        switchCamera()
        
    }
    
    var timer = Timer()
    var seconds = 5
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var captureButton: UIButton!
    
    @objc func counter() {
        seconds -= 1
        timerLabel.text = String(seconds)
        
        if seconds == 0 {
            timer.invalidate()
            let setting = AVCapturePhotoSettings()
            photoOutput?.capturePhoto(with: setting, delegate: self)
            
        }
    }
    
    @IBAction func capturePhotoButton(_ sender: Any) {
        seconds = 5
        timerLabel.alpha = 1
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(cameraViewController.counter), userInfo: nil, repeats: true)
        captureButton.isHidden = true
    }
    
    @IBOutlet weak var flipOutline: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevices()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        timerLabel.alpha = 0
        captureButton.isHidden = false
        outlineImage.image = outlineImageSet
        flipOutline.titleLabel?.adjustsFontSizeToFitWidth = true
        flipOutline.titleLabel?.minimumScaleFactor = 0.1
        
        if outlineImage.image == nil {
            flipOutline.alpha = 0
        } else {
            flipOutline.alpha = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConfirm" {
            let previewVC = segue.destination as! cameraConfirm
            previewVC.image = self.image
            previewVC.saveimage = outlineImageSet
        }
    }
    
    @objc func switchCamera() {
        captureSession.beginConfiguration()
        
        // Change the device based on the current camera
        let newDevice = (currentCamera?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera
        
        // Remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to the new input
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentCamera = newDevice
        captureSession.commitConfiguration()
    }
}

extension cameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "showConfirm", sender: nil)
        }
    }
}

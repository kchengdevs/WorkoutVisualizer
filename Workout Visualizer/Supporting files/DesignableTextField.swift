//
//  DesignableTextField.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/3/18.
//  Copyright © 2018 Kevin Cheng. All rights reserved.
//

import UIKit


@IBDesignable
class DesignableTextField: UITextField {
    
    //Spacing from left side of text field to the image
    @IBInspectable var leftPadding: CGFloat = 0
    {
        didSet
        {
            updateView()
        }
    }
    
    //Image inside the text field
    @IBInspectable var leftImage: UIImage?
    {
        didSet
        {
            updateView()
        }
    }
    
    //Corner Radius of the text field
    @IBInspectable var cornerRadius: CGFloat = 0
    {
        didSet
        {
            layer.cornerRadius = cornerRadius
        }
    }
    
    //Function to update the view of the text field after the attributes have been set
    func updateView()
    {
        if let image = leftImage
        {
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            
            var width = leftPadding + 20
            
            imageView.image = image
            imageView.tintColor = tintColor
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line
            {
                width = width + 5
            }
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
            
            leftView = view
        }
        else
        {
            //image is nil
            leftViewMode = .never
        }
    }
}


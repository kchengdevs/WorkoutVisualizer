//
//  tabBarControllerViewController.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 8/7/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import UIKit

class tabBarControllerViewController: UITabBarController {

    
    @IBOutlet weak var tabBAR: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHorizontalBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBar = UIView()
        horizontalBar.backgroundColor = UIColor.white
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(horizontalBar)
        
        horizontalBarLeftAnchorConstraint = horizontalBar.leftAnchor.constraint(equalTo: tabBar.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: tabBar.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexOfTab = tabBar.items?.index(of: item)
        let x = CGFloat(indexOfTab!) * tabBar.frame.width/4
        horizontalBarLeftAnchorConstraint?.constant = x
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tabBar.layoutIfNeeded()
        }, completion: nil)
        
    }
}

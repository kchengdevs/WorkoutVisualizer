//
//  insta.swift
//  Workout Visualizer
//
//  Created by Kevin Cheng on 7/23/18.
//  Copyright © 2018 Fitness Visualize. All rights reserved.
//

import Foundation
import Firebase

struct insta {
    let key: String!
    let url: String!
    
    let itemRef: DatabaseReference?
    
    init(url:String, key: String, storage: String) {
        self.key = key
        self.url = url
        self.itemRef = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let imageUrl = snapshotValue?["url"] as? String {
            url = imageUrl
        } else {
            url = ""
        }
    }
}

//
//  Storyboards.swift
//  iWatch
//
//  Created by Maxim  on 11/20/18.
//  Copyright © 2018 Maxim. All rights reserved.
//

import UIKit

struct Storyboards {
    
    static func viewController(storyboard: String, controller: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: controller)
        return vc
    }
    
}

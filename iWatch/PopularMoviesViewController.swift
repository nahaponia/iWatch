//
//  PopularMoviesViewController.swift
//  iWatch
//
//  Created by Maxim  on 9/15/17.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit
import SDWebImage

class PopularMoviesViewController: UIViewController {
    
    private enum TabIndex: Int {
        case firstTab = 0
        case secondTab = 1
    }
    
    @IBOutlet weak var contentView: UIView!
    
    private let storyBoard = UIStoryboard(name: "Popular", bundle: nil)
    
    private var currentTabViewController: UIViewController?
    
    private lazy var firstTabViewController: UIViewController? = {
        let firstTavViewController = self.storyBoard.instantiateViewController(withIdentifier: "PopularViewController")
        return firstTavViewController
    }()
    
    private lazy var secondTabViewController: UIViewController? = {
        let secondTabViewController = self.storyBoard.instantiateViewController(withIdentifier: "FavouriteViewController")
        return secondTabViewController
    }()
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentTabViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        self.currentTabViewController!.view.removeFromSuperview()
        self.currentTabViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    
    private func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentTabViewController = vc
        }
    }
    
    
    private func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        
        var vc: UIViewController?
        
        switch index {
        case TabIndex.firstTab.rawValue :
            vc = firstTabViewController
        case TabIndex.secondTab.rawValue :
            vc = secondTabViewController
        default:
            return nil
        }
        
        return vc
        
    }
    
    
    private func setupView() {
        
        displayCurrentTab(TabIndex.firstTab.rawValue)
        self.tabBarController?.tabBar.barTintColor = ColorPalette.backgroundBlack
        self.tabBarController?.delegate = self as UITabBarControllerDelegate
        
    }
    
    
}

extension PopularMoviesViewController: UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    
}




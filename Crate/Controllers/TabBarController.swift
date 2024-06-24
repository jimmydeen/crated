//
//  TabBarController.swift
//  Crate
//
//  Created by JD Chiang on 24/6/2024.
//

import Foundation
import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        
    }
    
    // Mark: - Tab Setup
    private func setupTabs() {
        let add = self.createNav(with: "", and: UIImage(systemName: "plus.circle"), vc: AddSearchVC(collectionViewLayout: UICollectionViewFlowLayout()))
        let discovery = self.createNav(with: "", and: UIImage(systemName: "opticaldisc"), vc: DiscoveryViewController())
        let search = self.createNav(with: "", and: UIImage(systemName: "magnifyingglass"), vc: SearchTableViewController())
        let profile = self.createNav(with: "", and: UIImage(systemName: "person.crop.circle"), vc: ProfileViewController())
        let activity = self.createNav(with: "", and: UIImage(systemName: "quote.bubble"), vc: ActivityViewController())
        self.setViewControllers([discovery, search, add,profile, activity], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        
//        Nav Bar Options
        
//        //        Nav bar title (at top)
//        nav.viewControllers.first?.navigationItem.title = title + " Controller"
//        
//        nav.viewControllers.first?.navigationItem.rightBarButtonItem =
//        UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
        return nav
        
    }
    
    
}

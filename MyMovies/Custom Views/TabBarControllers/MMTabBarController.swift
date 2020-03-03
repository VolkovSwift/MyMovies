//
//  MMTabBarController.swift
//  MyMovies
//
//  Created by user on 2/10/20.
//  Copyright © 2020 Vlad Volkov. All rights reserved.
//

import UIKit

class MMTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = .systemRed
        viewControllers = [createToSeeNavigationController(), createAlreadyWatchedNavigationController()]
    }
    
    
    func createToSeeNavigationController() -> UINavigationController {
        let toSeeVC = ToSeeVC()
        toSeeVC.title = "Movies To See"
        toSeeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    
        return UINavigationController(rootViewController: toSeeVC)
    }
    
    
    func createAlreadyWatchedNavigationController() -> UINavigationController {
        let alreadyWatchedVC = AlreadyWatchedVC()
        alreadyWatchedVC.title = "Already Watched"
        alreadyWatchedVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    
        return UINavigationController(rootViewController: alreadyWatchedVC)
    }
}

//
//  CollectionTabBarViewController.swift
//  ImSplash
//
//  Created by Ty Pham on 5/1/20.
//  Copyright © 2020 Ty Pham. All rights reserved.
//

import UIKit

class CollectionTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func customTabBar() {
        // set tab Bar at top
        tabBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        
        // set tabBar color
        tabBar.barTintColor = UIColor.white
        tabBar.itemPositioning = .fill
        
        // set tabBarItems title color and font
        tabBar.items?.forEach({ (item) in
            item.setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.black]
                , for: .normal)
            
            item.setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.red]
                , for: .selected)
        })
        
        //add tabBar separator
        let xPos = tabBar.frame.width / 2
        let separatorView = UIView(frame: CGRect(x: xPos, y: 22, width: 2, height: 20))
        separatorView.backgroundColor = UIColor.black
        tabBar.insertSubview(separatorView, at: 1)
    }
    
    override func viewDidLayoutSubviews() {
        customTabBar()
    }
    
}

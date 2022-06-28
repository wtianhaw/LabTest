//
//  BaseNavigationController.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
            
    convenience init(_ rootViewController: UIViewController) {
        self.init()
        self.init(rootViewController: rootViewController)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNavBar()
        isNavigationBarHidden = false
    }
    
    func initializeNavBar() {
        let navBar = UINavigationBar.appearance()
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        navBar.shadowImage = UIImage()
        let navBarAttribute = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
                               NSAttributedString.Key.foregroundColor : UIColor.black]
        navBar.titleTextAttributes = navBarAttribute
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = .clear
    }
    
}

//
//  BaseViewController.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import UIKit
import Combine

class BaseViewController: UIViewController {

    var cancellables: [AnyCancellable] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func showTabbarController(_ selectedTab :Int = 0) {
        if let window = self.view.window {
            window.rootViewController = BaseTabBarController(selectedTab: selectedTab)
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
}

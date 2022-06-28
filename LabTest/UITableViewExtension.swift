//
//  UITableViewExtension.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import UIKit

extension UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    static func getNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

//
//  ImageLoadingHelper.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import Foundation
import UIKit
import Kingfisher

class ImageLoadingHelper {
    static func loadImageWithUrl(urlString : String, imageView: UIImageView, placeHolder: UIImage? = nil) {
        if urlString != "" {
            let imageUrl = URL(string: urlString)
            DispatchQueue.main.async {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: imageUrl,placeholder: placeHolder, options: [.transition(.fade(0.2))])
            }
        }
    }
    
}

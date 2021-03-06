//
//  ImageCell.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    var imgAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        thumbnail.isUserInteractionEnabled = true
        thumbnail.addGestureRecognizer(tapGestureRecognizer)
        // Initialization code
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        if let url = model?.downloadURL{
            self.imgAction?()
//        }
    }
    
    var model: ImageListItem? {
        didSet {
            guard let model = model, let height = model.height, let width = model.width, let downloadUrl = model.downloadURL else { return }
            var newUrl = downloadUrl.replacingOccurrences(of: height.description, with: "300").replacingOccurrences(of: width.description, with: "200")
            
            ImageLoadingHelper.loadImageWithUrl(urlString: newUrl , imageView: self.thumbnail, placeHolder:  UIImage(named: "icon_search"))
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
}

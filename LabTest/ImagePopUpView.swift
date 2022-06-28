//
//  ImagePopUpView.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import UIKit
import Combine

class ImagePopUpView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!

    @Published
    var isBgRemove: Bool = true
    var cancellables: [AnyCancellable] = []
    
    init(frame: CGRect, imageUrl: String) {
        super.init(frame: frame)
        self.commonInit()
        
        self.imageView.contentMode = .scaleAspectFill
        ImageLoadingHelper.loadImageWithUrl(urlString: imageUrl, imageView: self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        self.commonInit()
    }
    
    private func commonInit() {
        guard let customView = UINib(nibName: "ImagePopUpView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        customView.frame = bounds
        
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(customView)
        self.view = customView
        
        self.bind()
    }
    
    private func bind() {
        self.$isBgRemove
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isRemove in
                guard let `self` = self else { return }
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeView))
                if isRemove {
                    self.bgView.addGestureRecognizer(tap)
                }else {
                    self.bgView.removeGestureRecognizer(tap)
                }
            })
            .store(in: &self.cancellables)
    }
    
    @objc private func removeView() {
        self.removeFromSuperview()
        self.endEditing(true)
    }
    
}

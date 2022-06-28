//
//  LoadingView.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import UIKit
import SwiftyGif

class LoadingView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        self.commonInit()
    }
    
    func commonInit() {
        guard let customView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        customView.frame = bounds
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(customView)
        self.view = customView
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        do {
            let gif = try UIImage(gifName: "loading.gif")
            self.imageView.setGifImage(gif)
        } catch {

        }
        
    }
    
}

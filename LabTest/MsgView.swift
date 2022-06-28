//
//  MsgView.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import UIKit

class MsgView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var msg: UILabel!
    
    private var msgStr: String = ""
    
    init(frame: CGRect, msg: String) {
        super.init(frame: frame)
        self.msgStr = msg
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
        guard let customView = UINib(nibName: "MsgView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        customView.frame = bounds
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(customView)
        self.view = customView
        
        self.bgView.layer.cornerRadius = 20
        self.bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        self.msg.text = self.msgStr
    }
}

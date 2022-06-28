//
//  MsgManager.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import UIKit

class MsgManager {
    
    static let shared = MsgManager()
    
    func show(msg: String, duration: TimeInterval = 1.5) {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) {
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                if let msgView: MsgView = MsgView(frame: window.bounds, msg: msg) as? MsgView {
                    window.addSubview(msgView)
                    
                    if duration > 0 {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: { [weak self] in
                            guard self != nil else { return }
                            msgView.removeFromSuperview()
                        })
                    }
                }
            }
        }
    }
    
}

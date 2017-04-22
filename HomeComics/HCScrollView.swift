//
//  HCScrollView.swift
//  HomeComics
//
//  Created by Jean Sarda on 22/04/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class HCScrollView: UIScrollView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

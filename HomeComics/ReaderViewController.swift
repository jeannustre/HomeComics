//
//  ReaderViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 02/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Chameleon

class ReaderViewController: UIViewController {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var pageIndicatorToolbar: UIBarButtonItem!
    @IBOutlet weak var button: UIButton!
    var pagesIndex: [URL] = []
    
    var chaine: String = "" {
        willSet(new) {
            print("current: \(chaine) next: \(new)")
        }
        didSet {
            
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func closeReader(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bg = UIColor(gradientStyle: .topToBottom, withFrame: self.view.bounds, andColors: [UIColor.flatBlueColorDark(), UIColor.flatSkyBlueColorDark()])
        toolbar.backgroundColor = bg
        toolbar.center.y += toolbar.bounds.height * 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedSegue" {
            let vc = segue.destination as! ComicPageViewController
            vc.pagesIndex = self.pagesIndex
            vc.view.addGestureRecognizer(twoFingerTap)
            vc.attachPageIndicator(item: pageIndicatorToolbar)
        }
    }
    
    lazy var twoFingerTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.twoFingerTapHandler(recognizer:)))
        tap.numberOfTouchesRequired = 2
        return tap
    }()
    
    func twoFingerTapHandler(recognizer : UITapGestureRecognizer) {
        if recognizer.state == .ended {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                let centerY = self.toolbar.center.y
                let barH = self.toolbar.bounds.height
                let screenH = self.view.bounds.height
                self.toolbar.center.y = centerY > screenH ? centerY - barH * 2 : centerY + barH * 2
            }, completion: nil)
        }
    }
}

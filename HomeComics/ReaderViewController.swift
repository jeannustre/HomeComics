//
//  ReaderViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 02/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var pageIndicatorToolbar: UIBarButtonItem!
    @IBOutlet weak var button: UIButton!
    var pagesIndex: [URL] = []
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            toolbar.isHidden = toolbar.isHidden ? false : true
        }
    }
}

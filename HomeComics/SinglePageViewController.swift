//
//  SinglePageViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 22/04/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class SinglePageViewController: UIViewController, UIScrollViewDelegate{
    
    // MARK: - Class variables
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: HCScrollView!
    var parentPanGestureRecognizer: UIPanGestureRecognizer!
    
    convenience init() {
        self.init()
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.delegate = self
        //scrollView.panGestureRecognizer.delegate = self
        self.setZoomScale()
        self.setupGestureRecognizer()
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ScrollView delegate methods
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.maximumZoomScale = 1.5
        scrollView.zoomScale = scrollView.minimumZoomScale
        updateGestureRecognition()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        updateGestureRecognition()
    }
    
    // MARK: - Gesture recognition
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    func updateGestureRecognition() {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.panGestureRecognizer.isEnabled = false
            if (parentPanGestureRecognizer != nil) {
                parentPanGestureRecognizer.isEnabled = true
            }
        } else {
            scrollView.panGestureRecognizer.isEnabled = true
            if (parentPanGestureRecognizer != nil) {
                parentPanGestureRecognizer.isEnabled = false
            }
        }
    }

}

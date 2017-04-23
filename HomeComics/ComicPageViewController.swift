//
//  ComicPageViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 15/03/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

// TODO: - Implement caching

class ComicPageViewController: UIPageViewController {

    // MARK: - Class variables
    var pagesIndex: [URL] = []
    var currentPage: Int = 0
    var currentImageView: UIImageView?
    var panGestureRecognizer: UIPanGestureRecognizer?
    let loadingImage = UIImage(named: "loading")
    
    private(set) lazy var orderedViewControllers: [SinglePageViewController] = {
        return [self.newPageViewController(),
                self.newPageViewController(),
                self.newPageViewController()]
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        self.setupGestures()
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        currentImageView = orderedViewControllers[0].view.viewWithTag(11) as? UIImageView
        currentImageView?.af_setImage(withURL: pagesIndex[0], placeholderImage: loadingImage)
        if (pagesIndex.count >= 2) {
            let nextImage = orderedViewControllers[1].view.viewWithTag(11) as! UIImageView
            nextImage.af_setImage(withURL: pagesIndex[1], placeholderImage: loadingImage)
        }
        if panGestureRecognizer != nil {
            orderedViewControllers[0].parentPanGestureRecognizer = panGestureRecognizer
            orderedViewControllers[1].parentPanGestureRecognizer = panGestureRecognizer
            orderedViewControllers[2].parentPanGestureRecognizer = panGestureRecognizer
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func newPageViewController() -> SinglePageViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePageViewController") as! SinglePageViewController
    }
    
    private func setupGestures() {
        for gesture in self.gestureRecognizers {
            if (gesture is UIPanGestureRecognizer) {
                panGestureRecognizer = gesture as? UIPanGestureRecognizer
            }
            if (gesture is UITapGestureRecognizer) {
                gesture.isEnabled = false
            }
        }
    }
}

// MARK: - DataSource
extension ComicPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard currentPage < pagesIndex.count - 1 else {
            return nil
        }
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController as! SinglePageViewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            let nextPage = orderedViewControllers.first
            return nextPage
        }
        let nextPage = orderedViewControllers[nextIndex]
        return nextPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard currentPage > 0 else {
            return nil
        }

        guard let viewControllerIndex = orderedViewControllers.index(of: viewController as! SinglePageViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard currentPage > 0 else {
            return nil
        }
        guard previousIndex >= 0 else {
            let prevPage = orderedViewControllers.last
            return prevPage
        }
        let prevPage = orderedViewControllers[previousIndex]
        return prevPage
    }
}

// MARK: - Delegate
extension ComicPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            let prevIndex = orderedViewControllers.index(of: previousViewControllers[0] as! SinglePageViewController)
            let currentIndex = orderedViewControllers.index(of: self.viewControllers?[0] as! SinglePageViewController)
            if currentIndex! == prevIndex! + 1 || (currentIndex! == orderedViewControllers.startIndex && prevIndex! == orderedViewControllers.endIndex - 1) {
                currentPage += 1
            } else if currentIndex! == prevIndex! - 1 || (currentIndex! == orderedViewControllers.endIndex - 1 && prevIndex! == orderedViewControllers.startIndex) {
                currentPage -= 1
            } else {
                print("Direction : neutral")
                return
            }
            print("new current page after transition changes : \(currentPage)")
            print("index of current controller : \(String(describing: currentIndex))")
            if (currentPage > 0) {
                var prevController: SinglePageViewController?
                if currentIndex == orderedViewControllers.startIndex {
                    prevController = orderedViewControllers.last
                } else {
                    prevController = orderedViewControllers[currentIndex! - 1]
                }
                let prevImage = prevController?.view.viewWithTag(11) as! UIImageView
                prevImage.af_setImage(withURL: pagesIndex[currentPage - 1])
            }
            if (currentPage < pagesIndex.count - 1) {
                var nextController: SinglePageViewController?
                if currentIndex == orderedViewControllers.endIndex - 1 {
                    nextController = orderedViewControllers.first
                } else {
                    nextController = orderedViewControllers[currentIndex! + 1]
                }
                let nextImage = nextController?.view.viewWithTag(11) as! UIImageView
                nextImage.af_setImage(withURL: pagesIndex[currentPage + 1])
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
}

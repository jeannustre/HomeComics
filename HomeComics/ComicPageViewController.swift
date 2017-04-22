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


class ComicPageViewController: UIPageViewController {

    var pagesIndex: [URL] = []
    var currentPage: Int = 0
    var currentOffset: Int = 0
    var currentController: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        let firstImage = orderedViewControllers[0].view.viewWithTag(11) as! UIImageView
        firstImage.af_setImage(withURL: pagesIndex[0])
        if (pagesIndex.count >= 2) {
            let nextImage = orderedViewControllers[1].view.viewWithTag(11) as! UIImageView
            nextImage.af_setImage(withURL: pagesIndex[1])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newPagedViewController(name: "First"),
                self.newPagedViewController(name: "Second"),
                self.newPagedViewController(name: "Third")]
    }()
    
    private func newPagedViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(name)PageViewController")
    }
    
}

extension ComicPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        currentOffset = 1
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        guard currentPage < pagesIndex.count - 1 else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            let nextPage = orderedViewControllers.first
            return nextPage
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        let nextPage = orderedViewControllers[nextIndex]
        return nextPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        currentOffset = -1
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard currentPage > 0 else {
            return nil
        }
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            let prevPage = orderedViewControllers.last
            return prevPage
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        let prevPage = orderedViewControllers[previousIndex]
        return prevPage
    }
}

extension ComicPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if (completed) {
            // prepare next and previous pages
            currentController += currentOffset
            currentPage += currentOffset
            
            if (currentController >= 3) {
                currentController = 0
            }
            if (currentController < 0) {
                currentController = 2
            }
            print("currentPage: \(currentPage)")
            
            if (currentPage > 0) {
                let prevImage = getPrevController(index: currentController).view.viewWithTag(11) as! UIImageView
                prevImage.af_setImage(withURL: pagesIndex[currentPage - 1])
            }
            if (currentPage < pagesIndex.count - 1) {
                let nextImage = getNextController(index: currentController).view.viewWithTag(11) as! UIImageView
                nextImage.af_setImage(withURL: pagesIndex[currentPage + 1])
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func getNextController(index: Int) -> UIViewController {
        if (index >= 2) {
            return orderedViewControllers[0]
        }
        return orderedViewControllers[index + 1]
    }
    
    func getPrevController(index: Int) -> UIViewController {
        if (index <= 0) {
            return orderedViewControllers[2]
        }
        return orderedViewControllers[index - 1]
    }
}

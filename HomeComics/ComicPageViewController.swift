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
    var pageIndicator: UIBarButtonItem?
    let loadingImage = UIImage(named: "loading")
    
    private(set) lazy var orderedViewControllers: [SinglePageViewController] = {
        return [self.newPageViewController(),
                self.newPageViewController(),
                self.newPageViewController()]
    }()
    // MARK: - Cache variables
    var downloader: ImageDownloader?
    var imageCache: AutoPurgingImageCache?
    
    private func setupCache() {
        let defaults = UserDefaults.standard
        let ramCache = defaults.integer(forKey: "ramCache")
        let diskCache = defaults.integer(forKey: "diskCache")
        let config = URLSessionConfiguration.default
        let urlCache = URLCache(
            memoryCapacity: 0,
            diskCapacity: diskCache * 1000000,
            diskPath: nil
        )
        config.urlCache = URLCache.shared
        config.urlCache = urlCache
        imageCache = AutoPurgingImageCache(
            memoryCapacity: UInt64(ramCache * 1000000),
            preferredMemoryUsageAfterPurge: 80_000_000
        )
        downloader = ImageDownloader(
            configuration: config,
            downloadPrioritization: .fifo,
            maximumActiveDownloads: 5,
            imageCache: imageCache
        )
    }
    
    func attachPageIndicator(item: UIBarButtonItem) {
        pageIndicator = item
        pageIndicator?.title = "\(currentPage + 1) of \(pagesIndex.count)"
    }
    
    func setImage(url: URL, imageView: UIImageView){
        let request = URLRequest(url: url)
        
        if let image = self.imageCache?.image(for: request) {
            print("----- found image in cache! -----")
            imageView.image = image
            return
        }
        print("---   sending request for image   ---")
        // TODO : error checks
        downloader?.download(request) { response in
            if let image = response.result.value {
                imageView.image = image
                self.imageCache?.add(image, for: request)
            }
        }
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        self.setupCache()
        self.setupGestures()
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        currentImageView = orderedViewControllers[0].imageView
        setImage(url: pagesIndex[0], imageView: currentImageView!)
        if (pagesIndex.count >= 2) {
            let nextImage = orderedViewControllers[1].imageView
            setImage(url: pagesIndex[1], imageView: nextImage)
        }
        if panGestureRecognizer != nil {
            orderedViewControllers[0].parentPanGestureRecognizer = panGestureRecognizer
            orderedViewControllers[1].parentPanGestureRecognizer = panGestureRecognizer
            orderedViewControllers[2].parentPanGestureRecognizer = panGestureRecognizer
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imageCache?.removeAllImages()
    }
    
    private func newPageViewController() -> SinglePageViewController {
        return UIStoryboard(name: "Reading", bundle: nil).instantiateViewController(withIdentifier: "SinglePageViewController") as! SinglePageViewController
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
                return
            }
            pageIndicator?.title = "\(currentPage + 1) of \(pagesIndex.count)"
            if (currentPage > 0) {
                let prevController = currentIndex == orderedViewControllers.startIndex ? orderedViewControllers.last : orderedViewControllers[currentIndex! - 1]
                if let prevImage = prevController?.imageView {
                    setImage(url: pagesIndex[currentPage - 1], imageView: prevImage)
                }
            }
            if (currentPage < pagesIndex.count - 1) {
                let nextController = currentIndex == orderedViewControllers.endIndex - 1 ? orderedViewControllers.first : orderedViewControllers[currentIndex! + 1]
                if let nextImage = nextController?.imageView {
                    setImage(url: pagesIndex[currentPage + 1], imageView: nextImage)
                }
                
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
}

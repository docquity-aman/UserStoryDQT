//
//  ContentViewController.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 18/04/23.
//

import UIKit

var ContentViewControllerVC = ContentViewController()

class ContentViewController: UIViewController {
    
    var pageViewController : UIPageViewController?
    var pages: [StoryModel] = []
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        
        // Do any additional setup after loading the view.
//        ContentViewController = self
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        configurePageView()
        ContentViewControllerVC = self
    }
    
    func configurePageView() {
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        guard let pageViewController = self.pageViewController else {return}
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let startingViewController: PreViewController =  viewControllerAtIndex(index: currentIndex)!
        let viewControllers = [startingViewController]
        pageViewController.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController.view.frame = view.bounds
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.sendSubviewToBack(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
    }
    

}

extension ContentViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? PreViewController  else {
            return viewController
        }
        var index = vc.preViewControllerVM.pageIndex
//        vc.transitioningDelegate = CustomPageTransition() as! any UIViewControllerTransitioningDelegate
        print("pageIndex B",index)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
    
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("pageIndex A",index)
        
        guard let vc = viewController as? PreViewController  else {
            return  viewController
        }
        var index = vc.preViewControllerVM.pageIndex
        if( index == 0 || index == NSNotFound ){
            return nil
        }
        index += 1
        return viewControllerAtIndex(index:index)
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//       let vc = pendingViewControllers
//    }
    
    
    //3
    func viewControllerAtIndex(index: Int) -> PreViewController? {
        if pages.count == 0 || index >= pages.count {
            return nil
        }
        // Create a new view controller and pass suitable data.
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreViewController") as! PreViewController
        vc.preViewControllerVM = PreViewControllerVM(pageIndex: index, userDetails: pages)
//        vc.items = pages
        
        currentIndex = index
        vc.view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
//        vc.view.transform = .scroll
        return vc
    }
    
    // Navigate to next page
    func goNextPage(fowardTo position: Int) {
        let startingViewController: PreViewController = viewControllerAtIndex(index: position)!
        let viewControllers = [startingViewController]
        print("go next page")
       self.pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: true, completion: nil)
    }
    
  
    

    
    
}


class CubicPageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0 //set duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let fromView = fromViewController.view,
              let toView = toViewController.view else { return }
        
        let containerView = transitionContext.containerView
        
        let width = containerView.bounds.size.width
        let height = containerView.bounds.size.height
        
        let offset = CGPoint(x: width, y: height)
        
        containerView.addSubview(toView)
        
        toView.frame = CGRect(x: offset.x, y: 0, width: width, height: height)
        
        let animator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext), dampingRatio: 0.5) {
            let transform = CGAffineTransform(translationX: -offset.x, y: 0).concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
            fromView.transform = transform
            toView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        animator.addCompletion { _ in
            fromView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        animator.startAnimation()
    }
}


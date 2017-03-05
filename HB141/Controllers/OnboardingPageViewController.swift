//
//  OnboardingPageViewController.swift
//  HB141
//
//  Created by Emma Flynn & Binit Shah on 2/11/17.
//  Copyright © 2017 International Human Trafficking Institute. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIScrollViewDelegate {
    
    var prevColor = ColorConstants.onboarding0Color
    var thisColor = ColorConstants.onboarding1Color
    var nextColor = ColorConstants.onboarding2Color
    
    var prevHeight:CGFloat = UIScreen.main.bounds.size.height
    var thisHeight:CGFloat = UIScreen.main.bounds.size.height
    var nextHeight:CGFloat = UIScreen.main.bounds.size.height
    
    var titleBackground = UIImageView();
    var progressButton = UIButton();
    var thisWidth: CGFloat = 0
    
    var multiplier: CGFloat = 1.44
    var buffer:CGFloat = 0
    
    var currentIndex:Int {
        get {
            return orderedViewControllers.index(of: self.viewControllers!.first!)!
        }
        
        set {
            guard newValue >= 0,
                newValue < orderedViewControllers.count else {
                    return
            }
            
            let vc = orderedViewControllers[newValue]
            let direction:UIPageViewControllerNavigationDirection = newValue > currentIndex ? .forward : .reverse
            self.setViewControllers([vc], direction: direction, animated: true, completion: nil)
        }
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newOnboardingViewController(identifier: "WelcomeViewController"),
                self.newOnboardingViewController(identifier: "SummaryViewController"),
                self.newOnboardingViewController(identifier: "EstimatesViewController"),
                self.newOnboardingViewController(identifier: "HowHelpViewController"),
                self.newOnboardingViewController(identifier: "HowWorksViewController")];
    }()
    
    private func newOnboardingViewController(identifier: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Onboarding", bundle: nil);
        let neededViewController = storyBoard.instantiateViewController(withIdentifier: identifier)
        return neededViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dataSource = self;
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil);
        }
        
        for subView in view.subviews {
            if subView is UIScrollView {
                (subView as! UIScrollView).delegate = self
            }
        }
        
        self.view.backgroundColor = thisColor
        
        progressButton.center = CGPoint(x: view.bounds.maxX - 50, y: view.bounds.maxY - 50)
        progressButton.setTitle("Skip", for: UIControlState.normal);
        progressButton.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        titleBackground.backgroundColor = UIColor.white
        for view in orderedViewControllers[0].view.subviews as [UIView] {
            if let mainTitle = view as? UILabel {
                let titleHeight = (mainTitle.frame.maxY - mainTitle.frame.height)*multiplier + mainTitle.frame.height + buffer
                let titleWidth = UIScreen.main.bounds.size.width
                thisHeight = titleHeight
                thisWidth = titleWidth
                titleBackground.frame = CGRect(x: 0, y: 0, width: titleWidth, height: titleHeight)
            }
        }
        for view in orderedViewControllers[1].view.subviews as [UIView] {
            if let atitle = view as? UILabel {
                nextHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                //print("Height: \(nextHeight)");
            }
        }
        self.view.insertSubview(titleBackground, at: 0)
        self.view.addSubview(progressButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        var percentComplete: CGFloat
        percentComplete = (point.x - view.frame.size.width)/view.frame.size.width
        if (percentComplete < 0) {
            let modPercentComplete: CGFloat = percentComplete * -1;
            self.view.backgroundColor = blendColors(from: thisColor, to: prevColor, ratio: modPercentComplete);
            titleBackground.frame = CGRect(x: 0, y: 0, width: thisWidth, height: blendHeight(from: thisHeight, to: prevHeight, ratio: modPercentComplete))
            //NSLog("modPercentComplete: %f", modPercentComplete)
        } else if (percentComplete > 0) {
            self.view.backgroundColor = blendColors(from: thisColor, to: nextColor, ratio: percentComplete);
            titleBackground.frame = CGRect(x: 0, y: 0, width: thisWidth, height: blendHeight(from: thisHeight, to: nextHeight, ratio: percentComplete))
            //NSLog("percentComplete: %f", percentComplete)
        } else {
            switch currentIndex {
                case 0:
                    //color
                    prevColor = ColorConstants.onboarding0Color
                    thisColor = ColorConstants.onboarding1Color
                    nextColor = ColorConstants.onboarding2Color
                    
                    //height
                    //prevHeight = UIScreen.main.bounds.size.height
                    for view in orderedViewControllers[0].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            prevHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                            thisHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                            titleBackground.frame = CGRect(x: 0, y: 0, width: thisWidth, height: thisHeight)
                        }
                    }
                    for view in orderedViewControllers[1].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            nextHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                        }
                    }
                case 1:
                    //color
                    prevColor = ColorConstants.onboarding1Color
                    thisColor = ColorConstants.onboarding2Color
                    nextColor = ColorConstants.onboarding3Color
                
                    //height
                    for view in orderedViewControllers[0].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            prevHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                        }
                    }
                    for view in orderedViewControllers[1].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            thisHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                            titleBackground.frame = CGRect(x: 0, y: 0, width: thisWidth, height: thisHeight)
                        }
                    }
                    for view in orderedViewControllers[2].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            nextHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                        }
                    }
                case 2:
                    //color
                    prevColor = ColorConstants.onboarding2Color
                    thisColor = ColorConstants.onboarding3Color
                    nextColor = ColorConstants.onboarding4Color
                
                    //height
                    for view in orderedViewControllers[1].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            prevHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                        }
                    }
                    for view in orderedViewControllers[2].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            thisHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                            titleBackground.frame = CGRect(x: 0, y: 0, width: thisWidth, height: thisHeight)
                        }
                    }
                    for view in orderedViewControllers[3].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            nextHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                        }
                    }
                case 3:
                    //color
                    prevColor = ColorConstants.onboarding3Color
                    thisColor = ColorConstants.onboarding4Color
                    nextColor = ColorConstants.onboarding5Color
                
                    //height
                    for view in orderedViewControllers[2].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            prevHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                        }
                    }
                    for view in orderedViewControllers[3].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            thisHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                            titleBackground.frame = CGRect(x: 0, y: 0, width: thisWidth, height: thisHeight)
                        }
                    }
                    for view in orderedViewControllers[4].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            nextHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                        }
                    }
                case 4:
                    //color
                    prevColor = ColorConstants.onboarding4Color
                    thisColor = ColorConstants.onboarding5Color
                    nextColor = ColorConstants.onboarding6Color
                
                    //height
                    for view in orderedViewControllers[3].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            prevHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                        }
                    }
                    for view in orderedViewControllers[4].view.subviews as [UIView] {
                        if let atitle = view as? UILabel {
                            thisHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                            titleBackground.frame = CGRect(x: 0, y: 0, width: thisWidth, height: thisHeight)
                            nextHeight = (atitle.frame.maxY - atitle.frame.height)*multiplier + atitle.frame.height + buffer
                        }
                    }
                    //nextHeight = UIScreen.main.bounds.size.height
                default:
                    prevColor = ColorConstants.onboarding0Color
                    thisColor = ColorConstants.onboarding0Color
                    nextColor = ColorConstants.onboarding0Color
            }
            //print("Index: " + String(currentIndex))
        }
    }
    
    func blendColors(from: UIColor, to: UIColor, ratio: CGFloat) -> UIColor {
        let inverseRatio: CGFloat = 1 - ratio;
        var fromRedRaw: CGFloat = 0;
        var fromGreenRaw: CGFloat = 0;
        var fromBlueRaw: CGFloat = 0;
        var toRedRaw: CGFloat = 0;
        var toGreenRaw: CGFloat = 0;
        var toBlueRaw: CGFloat = 0;
        
        if from.getRed(&fromRedRaw, green: &fromGreenRaw, blue: &fromBlueRaw, alpha: nil) && to.getRed(&toRedRaw, green: &toGreenRaw, blue: &toBlueRaw, alpha: nil) {
            let fromRed = fromRedRaw * 255.0;
            let fromGreen = fromGreenRaw * 255.0;
            let fromBlue = fromBlueRaw * 255.0;
            let toRed = toRedRaw * 255.0;
            let toGreen = toGreenRaw * 255.0;
            let toBlue = toBlueRaw * 255.0;
            
            let r: CGFloat = toRed * ratio + fromRed * inverseRatio;
            let g: CGFloat = toGreen * ratio + fromGreen * inverseRatio;
            let b: CGFloat = toBlue * ratio + fromBlue * inverseRatio;

            return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0);
        } else {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1.0);
        }
    }
    
    func blendHeight(from: CGFloat, to: CGFloat, ratio: CGFloat) -> CGFloat {
        let deltaX = (to - from) * ratio;
        let calcHeight = from + deltaX
        //print("Calculated Height: \(calcHeight)")
        return calcHeight
    }
    
}
    
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil;
        }
        
        let previousIndex = viewControllerIndex - 1;
        
        guard previousIndex >= 0 else {
            return nil;
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil;
        }
        
        return orderedViewControllers[previousIndex];
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil;
        }
        
        let nextIndex = viewControllerIndex + 1;
        
        guard nextIndex >= 0 else {
            return nil;
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil;
        }
        
        return orderedViewControllers[nextIndex];
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}

extension UIView {
    final func sizeToFitCustom() {
        var w: CGFloat = 0,
        h: CGFloat = 0
        for view in subviews {
            if view.frame.origin.x + view.frame.width > w { w = view.frame.origin.x + view.frame.width }
            if view.frame.origin.y + view.frame.height > h { h = view.frame.origin.y + view.frame.height }
        }
        frame.size = CGSize(width: w, height: h)
    }
}

//
//  OnboardingVC.swift
//  TrackingApp
//
//  Created by William Yeung on 1/5/21.
//

import UIKit
import CoreLocation


struct OnboardingItem {
    var title: String
    var description: String
    var image: UIImage
}

class OnboardingVC: UIViewController {
    // MARK: - Properties
    var activityMapVC: ActivityMapVC!
    
    var onboardingItems = [
        OnboardingItem(title: "Welcome".localized(), description: "Trak is an application that allows you to measure common, distance-related activites.".localized(), image: Assets.road),
        OnboardingItem(title: "Measure".localized(), description: "Whether you are exercising or just driving around, Trak records how far and how long you've travelled.".localized(), image: Assets.walk),
        OnboardingItem(title: "Easy".localized(), description: "Just start a new activity, and Trak will begin recording your elapsed distance and time.".localized(), image: Assets.finish)
    ]
    
    // MARK: - Views
    let scrollView = UIScrollView()
    let locationRequestVC = LocationRequestViewWithOutButton()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = onboardingItems.count + 1
        pc.currentPageIndicatorTintColor = UIColor.InvertedDarkMode
        pc.pageIndicatorTintColor = .systemGray4
        pc.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next".localized(), for: .normal)
        button.backgroundColor = UIColor.OnboardingButton
        button.setTitleColor(UIColor.InvertedDarkMode, for: .normal)
        button.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold18!)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addTarget(self, action: #selector(scrollToNextPage), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = UIColor.StandardDarkMode
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat((onboardingItems.count + 1)), height: 0)
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
        
        createPages()
        locationRequestVC.onboardingDelegate = self
        
        scrollView.addSubview(nextButton)
        nextButton.setDimension(width: view.widthAnchor, height: view.heightAnchor, hMult: UIDevice.current.hasNotch ? 0.125 : 0.1)
        nextButton.anchor(bottom: view.bottomAnchor)
        nextButton.center(to: view, by: .centerX)

        scrollView.addSubviews(pageControl)
        pageControl.anchor(right: view.rightAnchor, bottom: nextButton.topAnchor)
    }
    
    private func createPages() {
        for x in 0..<onboardingItems.count + 1 {
            if x < 3 {
                let pageView = OnboardingPage(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height))
                pageView.item = onboardingItems[x]
                scrollView.addSubview(pageView)
            } else {
                let pageView = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height))
                scrollView.addSubview(pageView)
                pageView.addSubview(locationRequestVC)
                locationRequestVC.locationManager = self.activityMapVC.locationManager
                locationRequestVC.anchor(top: pageView.topAnchor, right: pageView.rightAnchor, bottom: pageView.bottomAnchor, left: pageView.leftAnchor)
            }
        }
    }
    
    // MARK: - Selectors
    @objc func scrollToNextPage() {
        if pageControl.currentPage == 3 {
            locationRequestVC.allowLocationServices()
        }
        
        let nextIndex = min(pageControl.currentPage + 1, onboardingItems.count)
        pageControl.currentPage = nextIndex
        scrollView.setContentOffset(CGPoint(x: view.frame.size.width * CGFloat(nextIndex), y: 0), animated: true)
        
        if pageControl.currentPage == 3 {
            nextButton.setTitle("Allow".localized(), for: .normal)
            nextButton.setTitleColor(.systemGreen, for: .normal)
        }
    }
}

// MARK: - LocationRequestVC Delegate
extension OnboardingVC: LocationRequestOnboardingDelegate {
    func dismissOnboarding() {
        OnboardingStatus.shared.setIsNotNewUser()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true, completion: {
                self.activityMapVC.checkLocationServices()
            })
        }
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingVC: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        
        if pageControl.currentPage == 3 {
            nextButton.setTitle("Allow".localized(), for: .normal)
            nextButton.setTitleColor(.systemGreen, for: .normal)
        } else {
            nextButton.setTitle("Next".localized(), for: .normal)
            nextButton.setTitleColor(UIColor.InvertedDarkMode, for: .normal)
        }
    }
}


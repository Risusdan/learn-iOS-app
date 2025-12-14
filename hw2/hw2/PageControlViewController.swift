//
//  PageControlViewController.swift
//  hw2
//
//  Created by ChienLin Su on 2025/12/14.
//

import UIKit

class PageControlViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!

    private var pageViewController: UIPageViewController!
    private var pages: [UIViewController] = []
    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        setupPageViewController()
        setupPageControl()
    }

    private func setupPages() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let yellowVC = storyboard.instantiateViewController(withIdentifier: "YellowPageviewController") as? UIViewController {
            pages.append(yellowVC)
        }

        if let greenVC = storyboard.instantiateViewController(withIdentifier: "GreenPageviewController") as? UIViewController {
            pages.append(greenVC)
        }

        if let redVC = storyboard.instantiateViewController(withIdentifier: "RedPageviewController") as? UIViewController {
            pages.append(redVC)
        }

        if let blueVC = storyboard.instantiateViewController(withIdentifier: "BluePageviewController") as? UIViewController {
            pages.append(blueVC)
        }

        if let orangeVC = storyboard.instantiateViewController(withIdentifier: "OrangePageviewController") as? UIViewController {
            pages.append(orangeVC)
        }
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )

        pageViewController.dataSource = self
        pageViewController.delegate = self

        if let firstPage = pages.first {
            pageViewController.setViewControllers(
                [firstPage],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }

        addChild(pageViewController)
        view.insertSubview(pageViewController.view, at: 0)
        pageViewController.view.frame = view.bounds
        pageViewController.didMove(toParent: self)
    }

    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }

    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let direction: UIPageViewController.NavigationDirection = sender.currentPage > currentIndex ? .forward : .reverse
        currentIndex = sender.currentPage

        pageViewController.setViewControllers(
            [pages[currentIndex]],
            direction: direction,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UIPageViewControllerDataSource
extension PageControlViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension PageControlViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentViewController) {
            currentIndex = index
            pageControl.currentPage = index
        }
    }
}

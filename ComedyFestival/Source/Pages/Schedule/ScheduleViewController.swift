//
//  ScheduleViewController.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UIKit
import ComedyFestivalKit

class ScheduleViewController: UIViewController {
    private let viewModel: ScheduleViewModel
    private let menuViewController = ScheduleMenuViewController()
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil)
    private var selectedIndex = 0
    private var selectedDayViewController: ScheduleDayViewController? {
        return pageViewController.viewControllers?.first as? ScheduleDayViewController
    }
    private let searchController: UISearchController
    
    private var contentView: ScheduleView {
        return view as! ScheduleView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(appSession: AppSession) {
        viewModel = ScheduleViewModel(appSession: appSession)
        let resultsViewController = ScheduleShowsViewController()
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        super.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("schedule.title", comment: "Title for schedule screen")
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        viewModel.didReload = { [weak self] in self?.didReload() }
        viewModel.didFailReloading = { [weak self] in self?.didFailReloading(error: $0) }
        viewModel.didSearch = { [weak self] in self?.didSearch(results: $0) }
        pageViewController.delegate = self
        pageViewController.dataSource = self
        menuViewController.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchResultsUpdater = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ScheduleView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(menuViewController)
        addChildViewController(pageViewController)
        contentView.menuContainerView.sbs_replaceContainedView(with: menuViewController.view)
        contentView.pagesContainerView.sbs_replaceContainedView(with: pageViewController.view)
        menuViewController.didMove(toParentViewController: self)
        pageViewController.didMove(toParentViewController: self)
        viewModel.reload()
        showLoadingView()
    }
}

private extension ScheduleViewController {
    func showLoadingView() {
        contentView.activityIndicatorView.startAnimating()
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) {
            self.contentView.loadingView.alpha = 1
        }
        animator.startAnimation()
    }
    
    func hideLoadingView() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) {
            self.contentView.loadingView.alpha = 0
        }
        animator.addCompletion { _ in
            self.contentView.activityIndicatorView.stopAnimating()
        }
        animator.startAnimation()
    }
    
    func createScheduleDayViewController(at index: Int) -> ScheduleDayViewController {
        let scheduleDayViewController = ScheduleDayViewController(pageIndex: index, day: viewModel.days[index])
        scheduleDayViewController.delegate = self
        return scheduleDayViewController
    }
}

private extension ScheduleViewController {
    func didReload() {
        menuViewController.titles = viewModel.menuTitles
        if viewModel.days.count > 0 {
            if let selectedDayViewController = selectedDayViewController, selectedDayViewController.pageIndex < viewModel.days.count {
                // Remember current selection but update it with the recent data.
                selectedIndex = selectedDayViewController.pageIndex
                menuViewController.selectItem(at: selectedDayViewController.pageIndex)
                selectedDayViewController.show(viewModel.days[selectedDayViewController.pageIndex].locations)
            } else {
                // Reset selection.
                selectedIndex = 0
                let scheduleDayViewController = createScheduleDayViewController(at: 0)
                pageViewController.setViewControllers([ scheduleDayViewController ], direction: .forward, animated: false)
                menuViewController.selectItem(at: 0)
            }
        } else {
            // No data available. Remove selections.
            selectedIndex = 0
            menuViewController.selectItem(at: 0)
            pageViewController.setViewControllers([], direction: .forward, animated: false)
        }
        hideLoadingView()
    }
    
    func didFailReloading(error: Error) {
        print(error)
    }
    
    func didSearch(results: [Location]) {
        let showsViewController = searchController.searchResultsController as? ScheduleShowsViewController
        showsViewController?.show(results)
    }
}

extension ScheduleViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let scheduleDayViewController = viewController as? ScheduleDayViewController else { return nil }
        let previousIndex = scheduleDayViewController.pageIndex - 1
        if previousIndex >= 0 {
            return createScheduleDayViewController(at: previousIndex)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let scheduleDayViewController = viewController as? ScheduleDayViewController else { return nil }
        let nextIndex = scheduleDayViewController.pageIndex + 1
        if nextIndex < viewModel.days.count {
            return createScheduleDayViewController(at: nextIndex)
        }
        return nil
    }
}

extension ScheduleViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let scheduleDayViewController = pageViewController.viewControllers?.first as? ScheduleDayViewController else { return }
        selectedIndex = scheduleDayViewController.pageIndex
        menuViewController.selectItem(at: selectedIndex, animated: true)
    }
}

extension ScheduleViewController: ScheduleMenuViewControllerDelegate {
    func scheduleMenuViewController(_ scheduleMenuViewController: ScheduleMenuViewController, didSelectItemAt index: Int) {
        guard index != selectedIndex else { return }
        let direction: UIPageViewControllerNavigationDirection
        if let selectedDayViewController = selectedDayViewController, selectedDayViewController.pageIndex < index {
            direction = .forward
        } else {
            direction = .reverse
        }
        let scheduleDayViewController = createScheduleDayViewController(at: index)
        pageViewController.setViewControllers([ scheduleDayViewController ], direction: direction, animated: true)
        selectedIndex = index
    }
}

extension ScheduleViewController: ScheduleShowsViewControllerDelegate {
    func scheduleShowsViewControllerWillPresentBuyTickets(_ scheduleShowsViewController: ScheduleShowsViewController) {
        searchController.isActive = false
    }
    
    func scheduleShowsViewController(_ scheduleShowsViewController: ScheduleShowsViewController, didScroll scrollView: UIScrollView) {
        searchController.isActive = false
    }
}

extension ScheduleViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let showsViewController = searchController.searchResultsController as? ScheduleShowsViewController
        if let query = searchController.searchBar.text {
            viewModel.search(for: query)
        } else {
            showsViewController?.show([])
        }
    }
}

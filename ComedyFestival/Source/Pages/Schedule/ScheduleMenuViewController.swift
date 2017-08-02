//
//  ScheduleMenuViewController.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UIKit

protocol ScheduleMenuViewControllerDelegate: class {
    func scheduleMenuViewController(_ scheduleMenuViewController: ScheduleMenuViewController, didSelectItemAt index: Int)
}

private extension ScheduleMenuViewController {
    enum ReuseIdentifier: String {
        case menuItem
    }
}

class ScheduleMenuViewController: UIViewController {
    weak var delegate: ScheduleMenuViewControllerDelegate?
    var titles: [String] = [] {
        didSet {
            contentView.collectionView.reloadData()
            contentView.collectionView.collectionViewLayout.invalidateLayout()
            DispatchQueue.main.async {
                self.layoutSelectionIndicator(animated: false)
            }
        }
    }
    private(set) var selectedIndex = 0
    
    private var contentView: ScheduleMenuView {
        return view as! ScheduleMenuView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ScheduleMenuView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        contentView.collectionView.register(ScheduleMenuCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier.menuItem.rawValue)
    }
    
    func selectItem(at index: Int, animated: Bool = false) {
        selectedIndex = index
        layoutSelectionIndicator(animated: animated)
        let indexPath = IndexPath(item: index, section: 0)
        if contentView.collectionView.numberOfSections > 0 && index < contentView.collectionView.numberOfItems(inSection: 0) {
            contentView.collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: [])
            contentView.collectionView.scrollToItem(at: indexPath, at: [], animated: animated)
        }
    }
}

private extension ScheduleMenuViewController {
    func layoutSelectionIndicator(animated: Bool = false) {
        let selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
        guard
            let attr = contentView.collectionView.layoutAttributesForItem(at: selectedIndexPath) else {
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
                self.contentView.selectionIndicatorView.alpha = 0
            }
            animator.startAnimation()
            return
        }
        let frame = contentView.collectionView.convert(attr.frame, to: contentView)
        // We adjust the offset and width for margins in the menu cell.
        contentView.selectionIndicatorLeadingConstraint?.constant = frame.minX + 5
        contentView.selectionIndicatorWidthConstraint?.constant = frame.width - 10
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
                self.contentView.selectionIndicatorView.alpha = 1
                self.contentView.layoutIfNeeded()
            }
            animator.startAnimation()
        } else {
            contentView.selectionIndicatorView.alpha = 1
        }
    }
}

extension ScheduleMenuViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.menuItem.rawValue, for: indexPath) as? ScheduleMenuCollectionViewCell else {
            fatalError("Expected cell of type ScheduleMenuCollectionViewCell")
        }
        cell.titleLabel.text = titles[indexPath.item]
        return cell
    }
}

extension ScheduleMenuViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutSelectionIndicator(animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        layoutSelectionIndicator(animated: true)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
        delegate?.scheduleMenuViewController(self, didSelectItemAt: selectedIndex)
    }
}

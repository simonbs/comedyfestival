//
//  ScheduleDayViewController.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import UIKit
import ComedyFestivalKit
import SDWebImage
import SafariServices

protocol ScheduleShowsViewControllerDelegate: class {
    func scheduleShowsViewController(_ scheduleShowsViewController: ScheduleShowsViewController, didScroll scrollView: UIScrollView)
    func scheduleShowsViewControllerWillPresentBuyTickets(_ scheduleShowsViewController: ScheduleShowsViewController)
}

private extension ScheduleShowsViewController {
    enum ReuseIdentifier: String {
        case show
        case header
    }
}

class ScheduleShowsViewController: UIViewController {
    weak var delegate: ScheduleShowsViewControllerDelegate?
    private(set) var locations: [Location] = []
    
    private let currencyFormatter = NumberFormatter().sbs_make { me in
        me.numberStyle = .currency
        me.maximumFractionDigits = 0
        me.locale = Locale(identifier: "da_DK")
    }
    private let relativeDateFormatter = RelativeDateFormatter(showsTime: true)
    private var contentView: ScheduleShowsView {
        return view as! ScheduleShowsView
    }
    
    init(locations: [Location] = []) {
        self.locations = locations
        super.init(nibName: nil, bundle: nil)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ScheduleShowsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        contentView.collectionView.register(ScheduleShowCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier.show.rawValue)
        contentView.collectionView.register(ScheduleLocationHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.header.rawValue)
    }
    
    func show(_ locations: [Location]) {
        self.locations = locations
        contentView.collectionView.reloadData()
    }
}

private extension ScheduleShowsViewController {
    func presentBuyTickets(ticketURL: URL) {
        delegate?.scheduleShowsViewControllerWillPresentBuyTickets(self)
        let safariViewController = SFSafariViewController(url: ticketURL)
        safariViewController.preferredControlTintColor = UIColor(hex: 0xEE1C24)
        present(safariViewController, animated: true)
    }
}

extension ScheduleShowsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations[section].shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.show.rawValue, for: indexPath) as? ScheduleShowCollectionViewCell else {
            fatalError("Expected cell of type ScheduleMenuCollectionViewCell")
        }
        let show = locations[indexPath.section].shows[indexPath.item]
        cell.headlineLabel.text = show.headline
        cell.subheadlineLabel.text = show.subheadline
        cell.venueLabel.text = show.venue
        cell.dateLabel.text = relativeDateFormatter.string(from: show.date)
        if let price = show.price, price > 0 {
            let formattedPrice = currencyFormatter.string(from: NSNumber(integerLiteral: price))
            cell.priceLabel.text = formattedPrice ?? NSLocalizedString("schedule_day.price_unknown", comment: "Price when unable to format")
        } else {
            cell.priceLabel.text = NSLocalizedString("schedule_day.price_free", comment: "Price for a free show")
        }
        cell.soldOutLabel.text = NSLocalizedString("schedule_day.sold_out", comment: "Badge for sold out shows").uppercased()
        cell.buyTicketsButton.setTitle(NSLocalizedString("schedule_day.buy_tickets", comment: "Button for buying tickets").uppercased(), for: .normal)
        cell.soldOutLabel.isHidden = !show.isSoldOut
        cell.buyTicketsButton.isHidden = show.isSoldOut || show.isFree
        if let imageURL = show.imageURL {
            cell.imageView.sbs_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        if indexPath.item % 2 == 0 {
            cell.contentView.backgroundColor = .white
        } else {
            cell.contentView.backgroundColor = UIColor(hex: 0xFAFAFA)
        }
        cell.didPressBuyTickets = { [weak self] in
            guard let ticketURL = show.ticketURL else { return }
            self?.presentBuyTickets(ticketURL: ticketURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Supplementary view requested for unsupported kind '\(kind)'")
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIdentifier.header.rawValue, for: indexPath) as? ScheduleLocationHeaderReusableView else {
            fatalError("Expected view of type ScheduleLocationHeaderReusableView")
        }
        view.titleLabel.text = locations[indexPath.section].name.rawValue
        return view
    }
}

extension ScheduleShowsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scheduleShowsViewController(self, didScroll: scrollView)
    }
}


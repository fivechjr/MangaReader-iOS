//
//  NestedTableViewCell.swift
//  FSInvestor
//
//  Created by Yiming Dong on 21/8/18.
//  Copyright © 2018 Funding Societies. All rights reserved.
//

import UIKit

class NestedTableViewCell: UITableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.isScrollEnabled = false
    }
    
    func install(viewController: UIViewController, parent: UIViewController, toTheLeft: Bool) {
        guard let containerView = toTheLeft ? leftView : rightView else {return}
        
        parent.addChildViewController(viewController)
        viewController.willMove(toParentViewController: parent)
        containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: parent)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
    }
    
    func showLeft(animated: Bool = false) {
        scrollView.setContentOffset(.zero, animated: animated)
    }
    
    func showRight(animated: Bool = false) {
        let contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
        scrollView.setContentOffset(contentOffset, animated: animated)
    }
}

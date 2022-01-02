//
//  TransactionHeaderView.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import UIKit

protocol TransactionHeaderViewDelegate {
    func expandTapped(indexSection: Int)
}

class TransactionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var transactionMonthLabel: UILabel!
    @IBOutlet weak var expandImageView: UIImageView!
    @IBOutlet weak var expandBtn: UIButton! {
        didSet {
            expandBtn.addTarget(self, action: #selector(expandBtnDidPressed), for: .touchUpInside)
        }
    }
    
    var delegate: TransactionHeaderViewDelegate?
    var indexSection: Int?
    
    @objc func expandBtnDidPressed() {
        guard let index = indexSection else {
            return
        }
        self.delegate?.expandTapped(indexSection: index)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

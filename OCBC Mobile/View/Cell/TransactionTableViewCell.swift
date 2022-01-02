//
//  TransactionTableViewCell.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import UIKit

protocol TransactionTableViewCellDelegate {
    func transactionTapped(cell: TransactionTableViewCell)
}

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionContentView: UIView!
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var receipientNameLabel: UILabel!
    @IBOutlet weak var receipientNoLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionBtn: UIButton!
    
    var delegate: TransactionTableViewCellDelegate?
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        transactionContentView.layer.cornerRadius = 8.0
        transactionContentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        transactionContentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        transactionContentView.layer.shadowOpacity = 1
        transactionContentView.layer.shadowRadius = 1.5
        transactionContentView.layer.masksToBounds = false
        
        transactionBtn.addTarget(self, action: #selector(transactionBtnDidPressed), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTransactionData(transactionData: TransactionDataModel) {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let dateStr = transactionData.transactionDate, let transactionDate = dateFormatter.date(from: dateStr) as? Date {
            dateFormatter.dateFormat = "dd MMM yyyy"
            transactionDateLabel.text = dateFormatter.string(from: transactionDate)
        }
        
        receipientNameLabel.text = transactionData.receipient?.accountHolder ?? "-"
        receipientNoLabel.text = "Account No : " + (transactionData.receipient?.accountNo ?? "-")
        transactionAmountLabel.text = (transactionData.amount ?? 0.0).priceFormatter()
    }
    
    @objc func transactionBtnDidPressed() {
        self.delegate?.transactionTapped(cell: self)
    }
    
}

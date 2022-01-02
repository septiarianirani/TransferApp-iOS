//
//  PayeesTableViewCell.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import UIKit

protocol PayeesTableViewCellDelegate {
    func accountTapped(cell: PayeesTableViewCell)
}

class PayeesTableViewCell: UITableViewCell {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNoLabel: UILabel!
    @IBOutlet weak var accountBtn: UIButton!
    
    var delegate: PayeesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        accountBtn.addTarget(self, action: #selector(accountBtnDidPressed), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPayeesData(payees: PayeesDataModel) {
        accountNameLabel.text = payees.name ?? "-"
        accountNoLabel.text = "Account No : " + (payees.accountNo ?? "-")
    }
    
    @objc func accountBtnDidPressed() {
        self.delegate?.accountTapped(cell: self)
    }
    
}

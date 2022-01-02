//
//  TransactionDetailViewController.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import UIKit
import PKHUD
import Toast_Swift
import TextFieldEffects

class TransactionDetailViewController: UIViewController {
    
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var receipientNoLabel: UILabel!
    @IBOutlet weak var receipientNameLabel: UILabel!
    @IBOutlet weak var transactionNotesLabel: UILabel!
    
    let viewModel = TransactionDetailViewModel()
    let dateFormatter = DateFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.title = ""
        
        let backButtonSize:CGFloat = (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let backImage: UIImage = self.imageWithImage(withImage: (UIImage(named: "chevron-left") ?? UIImage())!, scaledToSize: CGSize(width: 10, height: 15))
        let backBtn = UIButton()
        backBtn.addTarget(self, action: #selector(self.backBtnDidPressed), for: .touchUpInside)
        backBtn.setImage(backImage, for: .normal)
        backBtn.contentMode = .scaleAspectFit
        backBtn.frame = CGRect(x: 0, y: 0, width: backButtonSize, height: backButtonSize)
        let backButton = UIBarButtonItem.init()
        backButton.customView = backBtn
        
        let titleLabel = UILabel()
        titleLabel.text = "Transaction Detail"
        titleLabel.font = UIFont(name: "HelveticaNeue-Semibold", size: 14.0)
        titleLabel.textColor = UIColor.init(red: 9/255, green: 98/255, blue: 137/255, alpha: 1.0)
        let titleItem = UIBarButtonItem.init()
        titleItem.customView = titleLabel
        
        self.navigationItem.leftBarButtonItems = [backButton, titleItem]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setDetailView()
    }
    
    // MARK: - Privates
    private func setDetailView() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let dateStr = viewModel.transactionDetail?.transactionDate, let transactionDate = dateFormatter.date(from: dateStr) as? Date {
            dateFormatter.dateFormat = "dd MMM yyyy"
            transactionDateLabel.text = dateFormatter.string(from: transactionDate)
        }
        transactionAmountLabel.text = (viewModel.transactionDetail?.amount ?? 0.0).priceFormatter()
        receipientNoLabel.text = viewModel.transactionDetail?.receipient?.accountNo ?? "-"
        receipientNameLabel.text = viewModel.transactionDetail?.receipient?.accountHolder ?? "-"
        transactionNotesLabel.text = viewModel.transactionDetail?.description ?? "-"
    }
    
    // MARK: - Actions
    @objc private func backBtnDidPressed() {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

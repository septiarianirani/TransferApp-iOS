//
//  MyTransactionViewController.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import UIKit
import PKHUD
import Toast_Swift
import TextFieldEffects
import SwiftyUserDefaults

class MyTransactionViewController: UIViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNoLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var addTransferBtn: UIButton!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var alertPopupView: UIView!
    @IBOutlet weak var alertYesBtn: UIButton!
    @IBOutlet weak var alertCancelBtn: UIButton!
    
    let viewModel = MyTransactionViewModel(dataService: DataService())
    var isShow:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        balanceView.layer.cornerRadius = 15.0
        balanceView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        balanceView.layer.shadowOffset = CGSize(width: -1, height: 0)
        balanceView.layer.shadowOpacity = 1
        balanceView.layer.shadowRadius = 1.5
        balanceView.layer.masksToBounds = false
        
        alertPopupView.layer.cornerRadius = 20.0
        alertCancelBtn.layer.borderColor = UIColor.init(red: 85/255, green: 85/255, blue: 85/255, alpha: 1).cgColor
        alertCancelBtn.layer.borderWidth = 1.0
        alertCancelBtn.layer.cornerRadius = 6.0
        alertYesBtn.layer.cornerRadius = 6.0
        alertPopupView.isHidden = true
        dismissBtn.isHidden = true
        
        transactionTableView.register(UINib.init(nibName: "TransactionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TransactionHeaderView")
        transactionTableView.register(UINib.init(nibName: "TransactionHeaderView", bundle: nil), forCellReuseIdentifier: "TransactionHeaderView")
        transactionTableView.register(UINib.init(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        
        logoutBtn.addTarget(self, action: #selector(logoutBtnDidPressed), for: .touchUpInside)
        addTransferBtn.addTarget(self, action: #selector(addTransferBtnDidPressed), for: .touchUpInside)
        dismissBtn.addTarget(self, action: #selector(dismissBtnDidPressed), for: .touchUpInside)
        alertYesBtn.addTarget(self, action: #selector(alertYesBtnDidPressed), for: .touchUpInside)
        alertCancelBtn.addTarget(self, action: #selector(alertCancelBtnDidPressed), for: .touchUpInside)
        
        if let userData = Defaults[.userData], let accountName = userData.username {
            accountNameLabel.text = accountName
        }
        
        fetchBalanceData()
    }
    
    // MARK: - Privates
    private func loadingStart() {
        HUD.show(.progress)
        logoutBtn.isEnabled = false
        transactionTableView.isUserInteractionEnabled = false
    }
    
    private func loadingStop() {
        HUD.hide()
        logoutBtn.isEnabled = true
        transactionTableView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func logoutBtnDidPressed() {
        dismissBtn.isHidden = false
        alertPopupView.isHidden = false
    }
    
    @objc private func addTransferBtnDidPressed() {
        let storyboard = UIStoryboard(name: "Transfer", bundle: nil)
        let payeesVc = storyboard.instantiateViewController(withIdentifier: "PayeesViewController") as! PayeesViewController
        let navVc = UINavigationController(rootViewController: payeesVc)
        navVc.modalPresentationStyle = .fullScreen
        payeesVc.modalPresentationStyle = .fullScreen
        navVc.modalTransitionStyle = .crossDissolve
        self.present(navVc, animated: true, completion: nil)
    }
    
    @objc private func dismissBtnDidPressed() {
        dismissBtn.isHidden = true
        alertPopupView.isHidden = true
    }
    
    @objc private func alertYesBtnDidPressed() {
        Defaults[.token] = nil
        Defaults[.userData] = nil
        
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let loginVc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navVc = UINavigationController(rootViewController: loginVc)
        navVc.modalPresentationStyle = .fullScreen
        loginVc.modalPresentationStyle = .fullScreen
        navVc.modalTransitionStyle = .crossDissolve
        self.present(navVc, animated: true, completion: nil)
    }
    
    @objc private func alertCancelBtnDidPressed() {
        dismissBtn.isHidden = true
        alertPopupView.isHidden = true
    }
    
    // MARK: - Networking
    func fetchBalanceData() {
        viewModel.fetchGetBalance()
        
        viewModel.updateLoading = {
            let _ = self.viewModel.isLoading ? self.loadingStart() : self.loadingStop()
        }
        
        viewModel.didFinishFetchDataBalance = {
            //setup balance view
            self.accountNoLabel.text = "Account No : " + (self.viewModel.balanceData?.accountNo ?? "-")
            self.totalBalanceLabel.text = (self.viewModel.balanceData?.balance ?? 0.0).priceFormatter()
            
            self.fetchTransactionData()
        }
    }
    
    func fetchTransactionData() {
        viewModel.fetchGetTransactionHistory()
        
        viewModel.updateLoading = {
            let _ = self.viewModel.isLoading ? self.loadingStart() : self.loadingStop()
        }
        
        viewModel.didFinishFetchDataTransaction = {
            self.transactionTableView.reloadData()
        }
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

extension MyTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.monthList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.expandList[section] {
            return viewModel.transactionList[section].count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TransactionHeaderView") as! TransactionHeaderView
        
        let model = viewModel.monthList[section]
        headerView.indexSection = section
        headerView.transactionMonthLabel.text = model

        let isExpand = viewModel.expandList[section]
        if isExpand {
            headerView.expandImageView.image = UIImage(named: "chevron-top")
        } else {
            headerView.expandImageView.image = UIImage(named: "chevron-bottom")
        }
    
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        
        let model = viewModel.transactionList[indexPath.section][indexPath.row]
        cell.setTransactionData(transactionData: model)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.expandList[indexPath.section] {
            return 144.0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MyTransactionViewController: TransactionHeaderViewDelegate, TransactionTableViewCellDelegate {
    func expandTapped(indexSection: Int) {
        self.viewModel.expandList[indexSection] = !self.viewModel.expandList[indexSection]
        self.transactionTableView.reloadData()
    }
    
    func transactionTapped(cell: TransactionTableViewCell) {
        if let indexPath = transactionTableView.indexPath(for: cell) as? IndexPath {
            let model = viewModel.transactionList[indexPath.section][indexPath.row]
            
            let detailTransactionVc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailViewController") as! TransactionDetailViewController
            detailTransactionVc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(detailTransactionVc, animated: true)
        }
    }
}

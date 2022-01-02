//
//  PayeesViewController.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import UIKit
import PKHUD
import Toast_Swift
import TextFieldEffects

class PayeesViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var payeesTableView: UITableView!
    
    let viewModel = PayeesViewModel(dataService: DataService())
    
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
        titleLabel.text = "Payees"
        titleLabel.font = UIFont(name: "HelveticaNeue-Semibold", size: 14.0)
        titleLabel.textColor = UIColor.init(red: 9/255, green: 98/255, blue: 137/255, alpha: 1.0)
        let titleItem = UIBarButtonItem.init()
        titleItem.customView = titleLabel
        
        self.navigationItem.leftBarButtonItems = [backButton, titleItem]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        searchView.layer.shadowOffset = CGSize(width: 0, height: 1)
        searchView.layer.shadowOpacity = 1
        searchView.layer.shadowRadius = 1.5
        searchView.layer.masksToBounds = false
        
        payeesTableView.register(UINib.init(nibName: "PayeesTableViewCell", bundle: nil), forCellReuseIdentifier: "PayeesTableViewCell")
  
        searchField.addTarget(self, action: #selector(searchFieldDidChanged), for: .editingChanged)
        
        fetchPayeesData()
    }
    
    // MARK: - Privates
    private func loadingStart() {
        HUD.show(.progress)
        payeesTableView.isUserInteractionEnabled = false
    }
    
    private func loadingStop() {
        HUD.hide()
        payeesTableView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func backBtnDidPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func searchFieldDidChanged() {
        guard let keyword = searchField.text else {
            return
        }
        
        viewModel.setFilteredPayeesList(keyword: keyword)
        
        viewModel.didFinishFetchDataPayees = {
            self.payeesTableView.reloadData()
        }
    }
    
    // MARK: - Networking
    private func fetchPayeesData() {
        viewModel.fetchGetPayees()
        
        viewModel.updateLoading = {
            let _ = self.viewModel.isLoading ? self.loadingStart() : self.loadingStop()
        }
        
        viewModel.showAlert = {
            if let errorMsg = self.viewModel.errorMessage {
                self.view.makeToast(errorMsg, duration: 1.5, position: .bottom)
            }
        }
        
        viewModel.didFinishFetchDataPayees = {
            self.payeesTableView.reloadData()
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

extension PayeesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredPayessList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayeesTableViewCell", for: indexPath) as! PayeesTableViewCell
        
        let model = viewModel.filteredPayessList[indexPath.row]
        cell.setPayeesData(payees: model)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PayeesViewController: PayeesTableViewCellDelegate {
    func accountTapped(cell: PayeesTableViewCell) {
        if let indexPath = payeesTableView.indexPath(for: cell) as? IndexPath {
            let model = viewModel.filteredPayessList[indexPath.row]
            
            let transferVc = self.storyboard?.instantiateViewController(withIdentifier: "CreateTransferViewController") as! CreateTransferViewController
            transferVc.viewModel.payeesData = model
            self.navigationController?.pushViewController(transferVc, animated: true)
        }
    }
}

extension PayeesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

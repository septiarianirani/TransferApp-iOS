//
//  CreateTransferViewController.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import UIKit
import PKHUD
import Toast_Swift
import TextFieldEffects

class CreateTransferViewController: UIViewController {
    
    @IBOutlet weak var payeesField: HoshiTextField!
    @IBOutlet weak var amountField: HoshiTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var transferBtn: UIButton!
    
    let viewModel = CreateTransferViewModel(dataService: DataService())

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
        titleLabel.text = "Transfer"
        titleLabel.font = UIFont(name: "HelveticaNeue-Semibold", size: 14.0)
        titleLabel.textColor = UIColor.init(red: 9/255, green: 98/255, blue: 137/255, alpha: 1.0)
        let titleItem = UIBarButtonItem.init()
        titleItem.customView = titleLabel
        
        self.navigationItem.leftBarButtonItems = [backButton, titleItem]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        payeesField.isEnabled = false
        descriptionTextView.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 10, right: 10)
        transferBtn.addTarget(self, action: #selector(transferBtnDidPressed), for: .touchDown)
    }
    
    // MARK: - Privates
    private func loadingStart() {
        HUD.show(.progress)
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        transferBtn.isEnabled = false
    }
    
    private func loadingStop() {
        HUD.hide()
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        transferBtn.isEnabled = true
    }
    
    // MARK: - Actions
    @objc private func backBtnDidPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func transferBtnDidPressed() {
        guard let payees = self.viewModel.payeesData, let accountNo = payees.accountNo else { return }
        
        guard let amountStr = amountField.text, amountStr != "0", let amount = Float(amountStr) as? Float else {
            self.view.makeToast("Minimum amount is 1", duration: 1.5, position: .bottom)
            return
        }
        
        var params:[String:Any] = ["receipientAccountNo":accountNo,
                                   "amount":amount,
                                   "description":""]
        
        if let descriptionStr = descriptionTextView.text, descriptionStr.count > 0 {
            params["description"] = descriptionStr
        }
        
        fetchTransferData(params: params)
    }
    
    // MARK: - Networking
    private func fetchTransferData(params: [String:Any]) {
        viewModel.postRequestTransfer(params: params)
        
        viewModel.updateLoading = {
            let _ = self.viewModel.isLoading ? self.loadingStart() : self.loadingStop()
        }
        
        viewModel.didFinishFetchDataTransfer = {
            let successMessage: String = "Successfully Transfered to " + (self.viewModel.payeesData?.name ?? "-")
            self.view.makeToast(successMessage, duration: 2.0, position: .bottom)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self.dismiss(animated: true, completion: nil)
            }
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

//
//  RegisterViewController.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import UIKit
import PKHUD
import Toast_Swift
import TextFieldEffects

class RegisterViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var usernameField: HoshiTextField!
    @IBOutlet weak var usernameErrLabel: UILabel!
    @IBOutlet weak var passwordField: HoshiTextField!
    @IBOutlet weak var passwordErrLabel: UILabel!
    @IBOutlet weak var confirmPassField: HoshiTextField!
    @IBOutlet weak var confirmPassErrLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    let viewModel = RegisterViewModel(dataService: DataService())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerBtn.layer.cornerRadius = registerBtn.frame.height / 2
        backBtn.addTarget(self, action: #selector(backBtnDidPressed), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerBtnDidPressed), for: .touchUpInside)
    }
    
    // MARK: - Privates
    private func loadingStart() {
        HUD.show(.progress)
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        registerBtn.isEnabled = false
    }
    
    private func loadingStop() {
        HUD.hide()
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        registerBtn.isEnabled = true
    }
    
    // MARK: - Actions
    @objc private func backBtnDidPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func registerBtnDidPressed() {
        guard let username = usernameField.text, username.count > 0 else {
            usernameErrLabel.text = "Username is required"
            return
        }
        usernameErrLabel.text = ""
        
        guard let password = passwordField.text, password.count > 0 else {
            passwordErrLabel.text = "Password is required"
            return
        }
        passwordErrLabel.text = ""
        
        guard let confirmPass = confirmPassField.text, confirmPass.count > 0 else {
            confirmPassErrLabel.text = "Confirm Password is required"
            return
        }
        
        guard confirmPass == password else {
            confirmPassErrLabel.text = "Confirm password not match"
            return
        }
        confirmPassErrLabel.text = ""
        
        self.fetchRegister(username: username, password: password)
    }
    
    // MARK: - Networking
    private func fetchRegister(username: String, password: String) {
        viewModel.postRequestRegister(username: username, password: password)
        
        viewModel.updateLoading = {
            let _ = self.viewModel.isLoading ? self.loadingStart() : self.loadingStop()
        }
        
        viewModel.showAlert = {
            if let error = self.viewModel.errorMessage {
                self.view.makeToast(error, duration: 1.5, position: .bottom)
            }
        }
        
        viewModel.didFinishFetchData = {
            self.view.makeToast("Successfully registered!", duration: 2.0, position: .bottom)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self.navigationController?.popViewController(animated: true)
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

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case usernameField:
            usernameErrLabel.text = ""
        case passwordField:
            passwordErrLabel.text = ""
        case confirmPassField:
            confirmPassErrLabel.text = ""
        default:
            break
        }
    }
}

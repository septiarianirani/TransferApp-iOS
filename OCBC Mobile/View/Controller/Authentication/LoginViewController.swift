//
//  LoginViewController.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import UIKit
import PKHUD
import Toast_Swift
import TextFieldEffects

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: HoshiTextField!
    @IBOutlet weak var usernameErrLabel: UILabel!
    @IBOutlet weak var passwordField: HoshiTextField!
    @IBOutlet weak var passwordErrLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    let viewModel = LoginViewModel(dataService: DataService())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        loginBtn.addTarget(self, action: #selector(loginBtnDidPressed), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerBtnDidPressed), for: .touchUpInside)
    }
    
    // MARK: - Privates
    private func loadingStart() {
        HUD.show(.progress)
        loginBtn.isEnabled = false
        registerBtn.isEnabled = false
    }
    
    private func loadingStop() {
        HUD.hide()
        loginBtn.isEnabled = true
        registerBtn.isEnabled = true
    }
    
    // MARK: - Actions
    @objc func loginBtnDidPressed() {
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
        
        self.fetchLogin(username: username, password: password)
    }
    
    @objc func registerBtnDidPressed() {
        let registerVc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVc, animated: true)
    }
    
    // MARK: - Networking
    private func fetchLogin(username: String, password: String) {
        viewModel.postRequestLogin(username: username, password: password)
        
        viewModel.updateLoading = {
            let _ = self.viewModel.isLoading ? self.loadingStart() : self.loadingStop()
        }
        
        viewModel.showAlert = {
            if let error = self.viewModel.errorMessage {
                self.view.makeToast(error, duration: 1.5, position: .bottom)
            }
        }
        
        viewModel.didFinishFetchData = {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let homeVc = storyboard.instantiateViewController(withIdentifier: "MyTransactionViewController") as! MyTransactionViewController
            let navVc = UINavigationController(rootViewController: homeVc)
            navVc.modalPresentationStyle = .fullScreen
            homeVc.modalPresentationStyle = .fullScreen
            navVc.modalTransitionStyle = .crossDissolve
            self.present(navVc, animated: true, completion: nil)
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//
//  SplashscreenViewController.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import UIKit
import SwiftyUserDefaults

class SplashscreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("IN SPLASHSCREEn")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if let token = Defaults[.token], token.count > 0, let userData = Defaults[.userData], let accountNo = userData.accountNo {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let transactionVc = storyboard.instantiateViewController(withIdentifier: "MyTransactionViewController") as! MyTransactionViewController
                let navVc = UINavigationController(rootViewController: transactionVc)
                navVc.modalPresentationStyle = .fullScreen
                transactionVc.modalPresentationStyle = .fullScreen
                navVc.modalTransitionStyle = .crossDissolve
                self.present(navVc, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let loginVc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navVc = UINavigationController(rootViewController: loginVc)
                navVc.modalPresentationStyle = .fullScreen
                loginVc.modalPresentationStyle = .fullScreen
                navVc.modalTransitionStyle = .crossDissolve
                self.present(navVc, animated: true, completion: nil)
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

//
//  LoginViewModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import Foundation

class LoginViewModel {
    
    private var dataService: DataService?
    var isLoading: Bool = false {
        didSet {
            self.updateLoading?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.showAlert?()
        }
    }
    
    private var loginData: LoginModel? {
        didSet {
            guard let data = loginData else { return }
            self.didFinishFetchData?()
        }
    }
    
    // MARK: - Closured for callback
    var updateLoading: (() -> ())?
    var didFinishFetchData: (() -> ())?
    var showAlert: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    // MARK: - Network Call
    func postRequestLogin(username: String, password: String) {
        self.isLoading = true
        self.dataService?.requestLogin(withUsername: username, withPassword: password, completionHandler: { (status, errorMsg, results) in
            switch status{
            case .success:
                if let result = results {
                    if let statusResult = result.status, statusResult.lowercased() == "success" {
                        self.errorMessage = nil
                        self.isLoading = false
                        self.loginData = results
                    } else {
                        if let errorResult = result.errorString, errorResult.count > 0 {
                            self.errorMessage = errorResult
                            self.isLoading = false
                        } else {
                            self.errorMessage = errorMsg
                            self.isLoading = false
                        }
                    }
                    
                } else {
                    self.errorMessage = errorMsg
                    self.isLoading = false
                }
                
            case .failure:
                self.errorMessage = errorMsg
                self.isLoading = false
            }
        })
    }
    
}

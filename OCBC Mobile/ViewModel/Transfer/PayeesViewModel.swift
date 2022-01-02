//
//  PayeesViewModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import Foundation

class PayeesViewModel {
    
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
    
    private var payeesData: PayeesModel? {
        didSet {
            guard let data = payeesData else { return }
            self.setPayeesList(model: data)
            self.didFinishFetchDataPayees?()
        }
    }
    
    var payeesList = [PayeesDataModel]()
    var filteredPayessList = [PayeesDataModel]()
    
    // MARK: - Closured for callback
    var updateLoading: (() -> ())?
    var didFinishFetchDataPayees: (() -> ())?
    var showAlert: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    // MARK: - Network Call
    func fetchGetPayees() {
        self.isLoading = true
        self.dataService?.requestGetPayees(completionHandler: { (status, errorMsg, results) in
            switch status {
            case .success:
                if let result = results {
                    if let statusResult = result.status, statusResult.lowercased() == "success" {
                        self.errorMessage = nil
                        self.isLoading = false
                        self.payeesData = results
                    } else {
                        if let errorResult = result.errorString, errorResult.count > 0 {
                            self.errorMessage = errorResult
                            self.isLoading = false
                        } else {
                            self.errorMessage = "Token Expired. You have to login again"
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
    
    // MARK: - Setup Data Payees
    func setPayeesList(model: PayeesModel) {
        guard let data = model.data else {
            return
        }
        
        self.payeesList = data
        self.filteredPayessList = data
    }
    
    func setFilteredPayeesList(keyword: String) {
        guard keyword.count > 0 else {
            self.filteredPayessList = self.payeesList
            self.didFinishFetchDataPayees?()
            return
        }
        
        self.filteredPayessList.removeAll()
        for payees in payeesList {
            if let payeesName = payees.name, payeesName.lowercased().contains(keyword.lowercased()) {
                self.filteredPayessList.append(payees)
            }
        }
        
        self.didFinishFetchDataPayees?()
    }
    
}

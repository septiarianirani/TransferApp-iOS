//
//  CreateTransferViewModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 02/01/22.
//

import Foundation

class CreateTransferViewModel {
    
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
    
    var payeesData: PayeesDataModel?
    var transferData: TransferModel? {
        didSet {
            guard let data = transferData else { return }
            self.didFinishFetchDataTransfer?()
        }
    }
    
    // MARK: - Closured for callback
    var updateLoading: (() -> ())?
    var didFinishFetchDataTransfer: (() -> ())?
    var showAlert: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    // MARK: - Network Call
    func postRequestTransfer(params: [String:Any]) {
        isLoading = true
        self.dataService?.requestTransfer(withParameter: params, completionHandler: { (status, errorMsg, results) in
            switch status {
            case .success:
                if let result = results {
                    if let statusResult = result.status, statusResult.lowercased() == "success" {
                        self.errorMessage = nil
                        self.isLoading = false
                        self.transferData = result
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
    
}

//
//  MyTransactionViewModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import Foundation

class MyTransactionViewModel {
    
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
    
    var balanceData: BalanceModel? {
        didSet {
            guard let data = balanceData else { return }
            self.didFinishFetchDataBalance?()
        }
    }
    
    private var transactionData: TransactionModel? {
        didSet {
            guard let data = transactionData else { return }
            self.setDataTransaction(model: data)
        }
    }
    
    var monthList = [String]()
    var expandList = [Bool]()
    var transactionList = [[TransactionDataModel]]()
    
    let dateFormatter = DateFormatter()
    
    // MARK: - Closured for callback
    var updateLoading: (() -> ())?
    var didFinishFetchDataBalance: (() -> ())?
    var didFinishFetchDataTransaction: (() -> ())?
    var showAlert: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    // MARK: - Network Call
    func fetchGetBalance() {
        self.isLoading = true
        self.dataService?.requestGetBalance(completionHandler: { (status, errorMsg, results) in
            switch status{
            case .success:
                if let result = results {
                    if let statusResult = result.status, statusResult.lowercased() == "success" {
                        self.errorMessage = nil
                        self.isLoading = false
                        self.balanceData = results
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
    
    func fetchGetTransactionHistory() {
        self.isLoading = true
        self.dataService?.requestGetTransaction(completionHandler: { (status, errorMsg, results) in
            switch status{
            case .success:
                if let result = results {
                    if let statusResult = result.status, statusResult.lowercased() == "success" {
                        self.errorMessage = nil
                        self.isLoading = false
                        self.transactionData = results
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
    
    // MARK: - Setup Data Transaction
    func setDataTransaction(model: TransactionModel) {
        guard let dataList = model.data else {
            return
        }
        
        expandList.removeAll()
        monthList.removeAll()
        transactionList.removeAll()
        
        for data in dataList {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let dateStr = data.transactionDate, let transactionDate = dateFormatter.date(from: dateStr) as? Date {
                dateFormatter.dateFormat = "MMMM yyyy"
                let monthTransaction = dateFormatter.string(from: transactionDate)
                let isExist = monthList.contains(monthTransaction)
                if !isExist {
                    expandList.append(false)
                    monthList.append(monthTransaction)
                    transactionList.append([TransactionDataModel]())
                }
            }
        }
        
        for var i in (0..<monthList.count) {
            if let currentMonth = monthList[i] as? String {
                for data in dataList {
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    if let dateStr = data.transactionDate, let transactionDate = dateFormatter.date(from: dateStr) as? Date {
                        dateFormatter.dateFormat = "MMMM yyyy"
                        let monthTransaction = dateFormatter.string(from: transactionDate)
                        if monthTransaction == currentMonth {
                            transactionList[i].append(data)
                        }
                    }
                }
            }
        }
        
        self.didFinishFetchDataTransaction?()
    }
    
}

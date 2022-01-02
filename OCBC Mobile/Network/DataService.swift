//
//  DataService.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

struct DataService {
    
    static let shared = DataService()
    let apiConstant = ApiConstant.self
    
    func requestLogin(withUsername username: String, withPassword password: String,
                      completionHandler completion:((_ status: Result<Any, AFError>, _ errorMessage: String, _ results:LoginModel?) -> Void)? = nil) {
        let apiRequest = apiConstant.login(username: username, password: password)
        APIManager.create(withURL: apiRequest.fullUrl, byMethod: apiRequest.apiMethod, parameters: apiRequest.parameters, encoding: apiRequest.apiEncoding, headers: apiRequest.headers, withAction: { }) { (status, errorMsg, results) in
            switch status {
            case .success:
                guard let result = results as? [String:Any], let metadata = ResponseParser.shared.parse(to: LoginModel.self, from: result) else {
                    completion?(status,errorMsg,nil)
                    return
                }
                
                if metadata.status?.lowercased() == "success", let token = metadata.token {
                    Defaults[.token] = token
                    Defaults[.userData] = metadata
                    completion?(status,"",metadata)
                } else {
                    completion?(status,metadata.errorString ?? "",nil)
                }
            case .failure:
                completion?(status,errorMsg,nil)
            }
        }
        
    }
    
    func requestRegister(withUsername username: String, withPassword password: String,
                         completionHandler completion:((_ status: Result<Any, AFError>, _ errorMessage: String, _ results:RegisterModel?) -> Void)? = nil) {
        let apiRequest = apiConstant.login(username: username, password: password)
        APIManager.create(withURL: apiRequest.fullUrl, byMethod: apiRequest.apiMethod, parameters: apiRequest.parameters, encoding: apiRequest.apiEncoding, headers: apiRequest.headers, withAction: { }) { (status, errorMsg, results) in
            switch status {
            case .success:
                guard let result = results as? [String:Any], let metadata = ResponseParser.shared.parse(to: RegisterModel.self, from: result) else {
                    completion?(status,errorMsg,nil)
                    return
                }
                
                completion?(status,"",metadata)
                
            case .failure:
                completion?(status,errorMsg,nil)
            }
        }
        
    }
    
    func requestGetBalance(completionHandler completion:((_ status: Result<Any, AFError>, _ errorMessage: String, _ results:BalanceModel?) -> Void)? = nil) {
        let apiRequest = apiConstant.balance
        APIManager.create(withURL: apiRequest.fullUrl, byMethod: apiRequest.apiMethod, parameters: apiRequest.parameters, encoding: apiRequest.apiEncoding, headers: apiRequest.headers, withAction: { }) { (status, errorMsg, results) in
            switch status {
            case .success:
                guard let result = results as? [String:Any], let metadata = ResponseParser.shared.parse(to: BalanceModel.self, from: result) else {
                    completion?(status,errorMsg,nil)
                    return
                }
                
                completion?(status,"",metadata)
                
            case .failure:
                completion?(status,errorMsg,nil)
            }
        }
        
    }
    
    func requestGetTransaction(completionHandler completion:((_ status: Result<Any, AFError>, _ errorMessage: String, _ results:TransactionModel?) -> Void)? = nil) {
        let apiRequest = apiConstant.transactions
        APIManager.create(withURL: apiRequest.fullUrl, byMethod: apiRequest.apiMethod, parameters: apiRequest.parameters, encoding: apiRequest.apiEncoding, headers: apiRequest.headers, withAction: { }) { (status, errorMsg, results) in
            switch status {
            case .success:
                guard let result = results as? [String:Any], let metadata = ResponseParser.shared.parse(to: TransactionModel.self, from: result) else {
                    completion?(status,errorMsg,nil)
                    return
                }
                
                completion?(status,"",metadata)
                
            case .failure:
                completion?(status,errorMsg,nil)
            }
        }
        
    }
    
    func requestGetPayees(completionHandler completion:((_ status: Result<Any, AFError>, _ errorMessage: String, _ results:PayeesModel?) -> Void)? = nil) {
        let apiRequest = apiConstant.payees
        APIManager.create(withURL: apiRequest.fullUrl, byMethod: apiRequest.apiMethod, parameters: apiRequest.parameters, encoding: apiRequest.apiEncoding, headers: apiRequest.headers, withAction: { }) { (status, errorMsg, results) in
            switch status {
            case .success:
                guard let result = results as? [String:Any], let metadata = ResponseParser.shared.parse(to: PayeesModel.self, from: result) else {
                    completion?(status,errorMsg,nil)
                    return
                }
                
                completion?(status,"",metadata)
                
            case .failure:
                completion?(status,errorMsg,nil)
            }
        }
        
    }
    
    func requestTransfer(withParameter params: [String:Any],
                         completionHandler completion:((_ status: Result<Any, AFError>, _ errorMessage: String, _ results:TransferModel?) -> Void)? = nil) {
        let apiRequest = apiConstant.transfer(params: params)
        APIManager.create(withURL: apiRequest.fullUrl, byMethod: apiRequest.apiMethod, parameters: apiRequest.parameters, encoding: apiRequest.apiEncoding, headers: apiRequest.headers, withAction: { }) { (status, errorMsg, results) in
            switch status {
            case .success:
                guard let result = results as? [String:Any], let metadata = ResponseParser.shared.parse(to: TransferModel.self, from: result) else {
                    completion?(status,errorMsg,nil)
                    return
                }
                
                completion?(status,"",metadata)
                
            case .failure:
                completion?(status,errorMsg,nil)
            }
        }
        
    }
    
}

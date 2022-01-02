//
//  APIConstant.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

enum ApiConstant {
    
    // Rani's Code
    case login(username: String, password: String)
    case register(username: String, password: String)
    case balance
    case transactions
    case payees
    case transfer(params: [String:Any])
}

extension ApiConstant {
    
    var fullUrl: String {
        return APIConfig.baseUrl + pathEndpoint
    }
    
    var pathEndpoint: String {
        switch self {
        case .login:
            return APIConfig.login
        case .register:
            return APIConfig.register
        case .balance:
            return APIConfig.balance
        case .transactions:
            return APIConfig.transactions
        case .payees:
            return APIConfig.payees
        case .transfer:
            return APIConfig.transfer
        }
    }
    
    var apiMethod: HTTPMethod {
        switch self {
        case .login,
             .register,
             .transfer:
            return .post
        case .balance,
             .transactions,
             .payees:
            return .get
        }
    }
    
    var parameters: [String:Any] {
        switch self {
        case .login(let username, let password):
            var parameters = [String: Any]()
            parameters["username"] = username
            parameters["password"] = password
            return parameters
        case .register(let username, let password):
            var parameters = [String: Any]()
            parameters["username"] = username
            parameters["password"] = password
            return parameters
        case .balance,
             .transactions,
             .payees:
            return [:]
        case .transfer(let params):
            var parameters = [String:Any]()
            parameters = params
            return parameters
        }
    }
    
    var apiEncoding: ParameterEncoding {
        switch self {
        case .login,
             .register,
             .transfer:
            return JSONEncoding.default
        case .balance,
             .transactions,
             .payees:
            return URLEncoding.default
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .login,
             .register:
            var parameterHeader = [String:String]()
            parameterHeader["Content-Type"] = "application/json"
            parameterHeader["Accept"] = "application/json"
            return parameterHeader
        case .balance,
             .transactions,
             .payees,
             .transfer:
            var parameterHeader = [String:String]()
            parameterHeader["Content-Type"] = "application/json"
            parameterHeader["Accept"] = "application/json"
            var tokenId = String()
            if let token = Defaults[.token], token != "", token != nil {
                tokenId = token
            }
            parameterHeader["Authorization"] = tokenId
            return parameterHeader
        }
    }
    
}

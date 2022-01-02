//
//  APIManager.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import Foundation
import Alamofire

class APIManager {
    
    class func create(
        withURL url:String, byMethod methods: HTTPMethod,
        parameters:[String:Any]?=nil, encoding:ParameterEncoding,
        headers: [String:String]?=nil,
        withAction action:(() -> Void)? = nil,
        completionHandler completion:((_ status: Result<Any, AFError>, _ errorMessage: String, _ results:[String:Any]?) -> Void)? = nil
        ){
        
        let head = HTTPHeaders(headers ?? [:])
        let param = parameters
        
        print("URL ",url)
        print("PARAM ",parameters)
        print("HEADER ",head)
        
        DispatchQueue.main.async {
            action?()
        }
        
        AF.request(
            url, method: methods, parameters: param,
            encoding: encoding, headers: head)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                print("RESPONSE ",response)
                switch response.result{
                case .success(let jsonData):
                    guard let json = jsonData as? [String:Any] else{
                        DispatchQueue.main.async {
                            completion?(response.result,"",nil)
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completion?(response.result,"",json)
                    }
                    
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("THIS THE ERRORRRR FAILURE ",error)
                        completion?(response.result,error.localizedDescription,nil)
                    }
                    break
                }
        }
        
    }
    
}

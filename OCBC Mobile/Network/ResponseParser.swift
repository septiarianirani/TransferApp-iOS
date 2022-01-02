//
//  ResponseParser.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import Foundation
import Alamofire

class ResponseParser {
    
    static let shared = ResponseParser()
    
    let decoder = JSONDecoder()
    
    func parse<ResponseType: Codable>(to: ResponseType.Type, from responses: [String:Any]) -> ResponseType? {
        do {
            let dictResponse = responses as NSDictionary
            let dataResponse:Data = NSKeyedArchiver.archivedData(withRootObject: dictResponse)
            let response = try decoder.decode(ResponseType.self, from: JSONSerialization.data(withJSONObject: dictResponse, options: .prettyPrinted))
            return response
        } catch(let error) {
            print(error)
            return nil
        }
        return nil
    }
    
}

//
//  LoginModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import Foundation
import SwiftyUserDefaults

struct LoginModel : Codable, DefaultsSerializable {
    let status : String?
    let token : String?
    let username : String?
    let accountNo : String?
    let errorString : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case token = "token"
        case username = "username"
        case accountNo = "accountNo"
        case errorString = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        accountNo = try values.decodeIfPresent(String.self, forKey: .accountNo)
        errorString = try values.decodeIfPresent(String.self, forKey: .errorString)
    }

}

struct LoginDataModel {
    let username: String
    let password: String
}

extension LoginDataModel {
    func isValidUsername() -> Bool {
        return username.count > 0
    }
    
    func isValidPassword() -> Bool {
        return password.count > 0
    }
}

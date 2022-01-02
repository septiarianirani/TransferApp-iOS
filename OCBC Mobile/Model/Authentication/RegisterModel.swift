//
//  RegisterModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import Foundation

struct RegisterModel : Codable {

    let errorString : String?
    let status : String?
    let token : String?

    enum CodingKeys: String, CodingKey {

        case errorString = "error"
        case status = "status"
        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorString = try values.decodeIfPresent(String.self, forKey: .errorString)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}

struct RegisterDataModel {
    let username: String
    let password: String
    let confirmPassword: String
}

extension RegisterDataModel {
    func isValidUsername() -> Bool {
        return username.count > 0
    }
    
    func isValidPassword() -> Bool {
        return password.count > 0
    }
    
    func isValidConfirmPassword() -> Bool {
        return confirmPassword.count > 0
    }
    
    func isConfirmPasswordMatch() -> Bool {
        return confirmPassword == password
    }
}

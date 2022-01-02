//
//  BalanceModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import Foundation

struct BalanceModel : Codable {
    
    let status : String?
    let accountNo : String?
    let balance : Float?
    let errorString : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case accountNo = "accountNo"
        case balance = "balance"
        case errorString = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        accountNo = try values.decodeIfPresent(String.self, forKey: .accountNo)
        balance = try values.decodeIfPresent(Float.self, forKey: .balance)
        errorString = try values.decodeIfPresent(String.self, forKey: .errorString)
    }

}

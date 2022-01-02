//
//  TransferModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 02/01/22.
//

import Foundation

struct TransferModel : Codable {
    
    let status : String?
    let transactionId : String?
    let amount : Int?
    let description : String?
    let recipientAccount : String?
    let errorString : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case transactionId = "transactionId"
        case amount = "amount"
        case description = "description"
        case recipientAccount = "recipientAccount"
        case errorString = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        recipientAccount = try values.decodeIfPresent(String.self, forKey: .recipientAccount)
        errorString = try values.decodeIfPresent(String.self, forKey: .errorString)
    }

}

struct CreateTransferModel {
    let accountNo: String
    let amount: Float
}

extension CreateTransferModel {
    func isValidAccountNo() -> Bool {
        return accountNo.count > 0
    }
    
    func isValidAmount() -> Bool {
        return amount > 0.0
    }
}

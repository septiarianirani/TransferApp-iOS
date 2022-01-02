//
//  TransactionModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import Foundation

struct TransactionModel : Codable {
    
    let status : String?
    let data : [TransactionDataModel]?
    let errorString : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case data = "data"
        case errorString = "error"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        data = try values.decodeIfPresent([TransactionDataModel].self, forKey: .data)
        errorString = try values.decodeIfPresent(String.self, forKey: .errorString)
    }
    
}

struct TransactionDataModel : Codable {
    
    let transactionId : String?
    let amount : Float?
    let transactionDate : String?
    let description : String?
    let transactionType : String?
    let receipient : TransactionReceipientModel?
    
    enum CodingKeys: String, CodingKey {
        
        case transactionId = "transactionId"
        case amount = "amount"
        case transactionDate = "transactionDate"
        case description = "description"
        case transactionType = "transactionType"
        case receipient = "receipient"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        amount = try values.decodeIfPresent(Float.self, forKey: .amount)
        transactionDate = try values.decodeIfPresent(String.self, forKey: .transactionDate)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        transactionType = try values.decodeIfPresent(String.self, forKey: .transactionType)
        receipient = try values.decodeIfPresent(TransactionReceipientModel.self, forKey: .receipient)
    }
    
}

struct TransactionReceipientModel : Codable {
    
    let accountNo : String?
    let accountHolder : String?
    
    enum CodingKeys: String, CodingKey {
        
        case accountNo = "accountNo"
        case accountHolder = "accountHolder"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountNo = try values.decodeIfPresent(String.self, forKey: .accountNo)
        accountHolder = try values.decodeIfPresent(String.self, forKey: .accountHolder)
    }
    
}

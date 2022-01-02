//
//  PayeesModel.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 01/01/22.
//

import Foundation

struct PayeesModel : Codable {
    
    let status : String?
    let data : [PayeesDataModel]?
    let errorString : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case errorString = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        data = try values.decodeIfPresent([PayeesDataModel].self, forKey: .data)
        errorString = try values.decodeIfPresent(String.self, forKey: .errorString)
    }

}

struct PayeesDataModel : Codable {
    
    let id : String?
    let name : String?
    let accountNo : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case accountNo = "accountNo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        accountNo = try values.decodeIfPresent(String.self, forKey: .accountNo)
    }

}

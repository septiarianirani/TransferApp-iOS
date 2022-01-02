//
//  Extension+DefaultsKey.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 31/12/21.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    
    static let token = DefaultsKey<String?>("token")
    static let userData = DefaultsKey<LoginModel?>("userData")
}

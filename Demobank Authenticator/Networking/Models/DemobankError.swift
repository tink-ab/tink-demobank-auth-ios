//
//  DemobankError.swift
//  Demobank Authenticator
//
//  Created by Pontus Orraryd on 2020-06-15.
//  Copyright © 2020 Pontus Orraryd. All rights reserved.
//

import Foundation

struct DemobankError: Error, Codable {
    let status: Int?
    let error: String?
    let message: String
    let path: String?
}

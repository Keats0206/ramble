//
//  Validation.swift
//  Ramble
//
//  Created by P..D..! on 13/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation

enum Validation {
    case success
    case failure(message: String)
    case none
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}

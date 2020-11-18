//
//  Publisher+Validation.swift
//  Ramble
//
//  Created by P..D..! on 13/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Combine

extension Published.Publisher where Value == String {
    
    func nonEmptyValidator(_ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.nonEmptyValidation(for: self, errorMessage: errorMessage())
    }
//            swiftlint:disable force_try
    func matcherValidation(_ pattern: String, _ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.matcherValidation(for: self, withPattern: try! NSRegularExpression(pattern: pattern), errorMessage: errorMessage())
    }
//            swiftlint:enable force_try
}

extension Published.Publisher where Value == Date {
     func dateValidation(afterDate after: Date = .distantPast,
                         beforeDate before: Date = .distantFuture,
                         errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.dateValidation(for: self, afterDate: after, beforeDate: before, errorMessage: errorMessage())
    }
}

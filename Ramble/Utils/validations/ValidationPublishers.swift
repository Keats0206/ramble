//
//  ValidationPublishers.swift
//  Ramble
//
//  Created by P..D..! on 13/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import Foundation
import Combine

typealias ValidationErrorClosure = () -> String

typealias ValidationPublisher = AnyPublisher<Validation, Never>

class ValidationPublishers {

    // Validates whether a string property is non-empty.
    static func nonEmptyValidation(for publisher: Published<String>.Publisher,
                                   errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { value in
//            swiftlint:disable empty_count
            guard value.count > 0 else {
                return .failure(message: errorMessage())
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
//            swiftlint:enable force_try

    }
    
    // Validates whether a string matches a regular expression.
    static func matcherValidation(for publisher: Published<String>.Publisher,
                                  withPattern pattern: NSRegularExpression,
                                  errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { value in
            let range = NSRange(location: 0, length: value.utf16.count)
            guard (pattern.firstMatch(in: value, options: [], range: range) != nil) else {
                return .failure(message: errorMessage())
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }
    
    // Validates whether a date falls between two other dates. If one of
    // the bounds isn't provided, a suitable distant detail is used.
    static func dateValidation(for publisher: Published<Date>.Publisher,
                               afterDate after: Date = .distantPast,
                               beforeDate before: Date = .distantFuture,
                               errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { date in
            return date > after && date < before ? .success : .failure(message: errorMessage())
        }.eraseToAnyPublisher()
    }

}

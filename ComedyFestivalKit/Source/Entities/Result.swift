//
//  Result.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation

public enum Result<E: Error, T> {
    case value(T)
    case error(E)
    
    public init(_ value: T) {
        self = .value(value)
    }
    
    public init(_ error: E) {
        self = .error(error)
    }
}

public extension Result {
    func mapValue<_T>(_ map: (T) -> _T) -> Result<E, _T> {
        switch self {
        case .value(let value):
            return .value(map(value))
        case .error(let error):
            return .error(error)
        }
    }
    
    func mapError<_E: Error>(_ map: (E) -> _E) -> Result<_E, T> {
        switch self {
        case .value(let value):
            return .value(value)
        case .error(let error):
            return .error(map(error))
        }
    }
}

public extension Result {
    @discardableResult
    func ifValue(f: (T) -> Void) -> Result<E, T> {
        switch self {
        case .value(let value):
            f(value)
        case .error:
            break
        }
        return self
    }
    
    @discardableResult
    func ifError(f: (E) -> Void) -> Result<E, T> {
        switch self {
        case .value:
            break
        case .error(let error):
            f(error)
        }
        return self
    }
}

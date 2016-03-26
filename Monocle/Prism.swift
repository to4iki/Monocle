//
//  Prism.swift
//  Monocle
//
//  Created by to4iki on 12/29/15.
//  Copyright © 2015 to4iki. All rights reserved.
//

import Foundation

public struct Prism<S, A>: OpticType {
    
    public typealias Source = S
    
    public typealias Target = A
    
    private let _getOption: S -> A?
    
    private let _reverseGet: A -> S
    
    public init(getOption: S -> A?, reverseGet: A -> S) {
        _getOption = getOption
        _reverseGet = reverseGet
    }
}

// MARK: - CustomStringConvertible

extension Prism: CustomStringConvertible {
    
    public var description: String {
        return "Prism(\(_getOption), \(_reverseGet))"
    }
}

// MARK: - Basic

extension Prism {
    
    /// Attempts to focus the prism on the given source.
    public func getOption(s: Source) -> Target? {
        return _getOption(s)
    }
    
    /// Injects a value back into a modified form of the original structure.
    public func reverseGet(t: Target) -> Source {
        return _reverseGet(t)
    }
    
    /// Attempts to run a value of type `S` along both parts of the Prism.
    /// If `.None` is encountered along the getter returns `.None`,
    /// else returns `.Some` containing the final value.
    public func modify(s: Source, f: Target -> Target) -> Source? {
        return getOption(s).map(self.reverseGet >>> f)
    }
}

// MARK: - Creator

extension Prism {
    
    /// Composes a `Prism` with the receiver.
    public func compose<T>(other: Prism<Target, T>) -> Prism<Source, T> {
        return Prism<Source, T>(
            getOption: { (s: Source) -> T? in
                self.getOption(s).flatMap { (t: Target) -> T? in
                    other.getOption(t)
                }
            },
            reverseGet: { (t: T) -> Source in
                (self.reverseGet >>> other.reverseGet)(t)
            }
        )
    }
    
    /// Creates a `Prism` that focuses on array structures.
    public func lift() -> Prism<[Source], [Target]> {
        return Prism<[Source], [Target]>(
            getOption: { (ss: [Source]) -> [Target]? in
                ss.flatMap { self.getOption($0) }
            },
            reverseGet: { (ts: [Target]) -> [Source] in
                ts.map { self.reverseGet($0) }
            }
        )
    }
    
    /// Creates a `Prism` that focuses on two structures.
    public func split<T, B>(other: Prism<T, B>) -> Prism<(Source, T), (Target, B)> {
        return Prism<(Source, T), (Target, B)>(
            getOption: { (t: (Source, T)) -> (Target, B)? in
                if let t0 = self.getOption(t.0), t1 = other.getOption(t.1) {
                    return (t0, t1)
                } else {
                    return nil
                }
            },
            reverseGet: { (a: A, b: B) -> (S, T) in
                (self.reverseGet(a), other.reverseGet(b))
            }
        )
    }
    
    /// Creates a `Prism` that sends its input structure to both Lenses to focus on distinct subparts.
    public func fanout<B>(other: Prism<Source, B>) -> Prism<Source, (Target, B)> {
        return Prism<Source, (Target, B)>(
            getOption: { (s: Source) -> (Target, B)? in
                if let t0 = self.getOption(s), t1 = other.getOption(s) {
                    return (t0, t1)
                } else {
                    return nil
                }
            },
            reverseGet: { (a: A, b: B) -> S in
                self.reverseGet(a)
            }
        )
    }
}

// MARK: - Operator

public func >>> <S, A, T>(lhs: Prism<S, A>, rhs: Prism<A, T>) -> Prism<S, T> {
    return lhs.compose(rhs)
}

public func <<< <S, A, T>(lhs: Prism<A, T>, rhs: Prism<S, A>) -> Prism<S, T> {
    return rhs.compose(lhs)
}

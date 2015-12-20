//
//  Lens.swift
//  Monocle
//
//  Created by to4iki on 12/20/15.
//  Copyright © 2015 to4iki. All rights reserved.
//

import Foundation

public struct Lens<A, B> {
    
    private let getter: A -> B
    
    private let setter: (A, B) -> A
    
    public init(getter: A -> B, setter: (A, B) -> A) {
        self.getter = getter
        self.setter = setter
    }
}

// MARK: - Basic

extension Lens {
    
    public func get(from: A) -> B {
        return getter(from)
    }
    
    public func get(from: A?) -> B? {
        return from.map { (a: A) -> B in getter(a) }
    }
    
    public func set(from: A, to: B) -> A {
        return setter(from, to)
    }
    
    public func set(from: A?, to: B) -> A? {
        return from.map { (a: A) -> A in setter(a, to) }
    }
    
    public func set(from: A, to: B?) -> A? {
        return to.map { (b: B) -> A in setter(from, b) }
    }
    
    public func set(from: A?, to: B?) -> A? {
        if let a = from, b = to {
            return setter(a, b)
        } else {
            return nil
        }
    }
    
    public func modify(from: A, toF: B -> B) -> A {
        return set(from, to: toF(get(from)))
    }
}

// MARK: - Compose

public func composeLens<A, B, C>(left: Lens<A, B>, right: Lens<B, C>) -> Lens<A, C> {
    let getter: A -> C = { a in
        right.get(left.get(a))
    }
    
    let setter: (A, C) -> A = { a, c in
        left.set(a, to: right.set(left.get(a), to: c))
    }
    
    return Lens(getter: getter, setter: setter)
}

public func >>> <A, B, C>(lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return composeLens(lhs, right: rhs)
}
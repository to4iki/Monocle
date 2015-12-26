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
    
    public func set(from: A, _ to: B) -> A {
        return setter(from, to)
    }
    
    public func set(from: A?, _ to: B) -> A? {
        return from.map { (a: A) -> A in setter(a, to) }
    }
    
    public func set(from: A, _ to: B?) -> A? {
        return to.map { (b: B) -> A in setter(from, b) }
    }
    
    public func set(from: A?, _ to: B?) -> A? {
        if let a = from, b = to {
            return setter(a, b)
        } else {
            return nil
        }
    }
    
    public func modify(from: A, f: B -> B) -> A {
        return set(from, f(get(from)))
    }
}

// MARK: - Compose

extension Lens {
    
    public func compose<C>(other: Lens<B, C>) -> Lens<A, C> {
        return Lens<A, C>(
            getter: { (a: A) -> C in
                other.get(self.get(a))
            },
            setter: { (a: A, c: C) -> A in
                self.set(a, other.set(self.get(a), c))
            }
        )
    }
}

public func >>> <A, B, C>(lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return lhs.compose(rhs)
}

public func <<< <A, B, C>(lhs: Lens<B, C>, rhs: Lens<A, B>) -> Lens<A, C> {
    return rhs.compose(lhs)
}
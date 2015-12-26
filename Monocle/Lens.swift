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
    
    /// Runs the getter on a given structure.
    public func get(from: A) -> B {
        return getter(from)
    }
    
    /// Runs the getter on a given structure.
    public func get(from: A?) -> B? {
        return from.map { (a: A) -> B in getter(a) }
    }
    
    /// Runs the setter on a given structure and value to yield a new structure.
    public func set(from: A, _ to: B) -> A {
        return setter(from, to)
    }
    
    /// Runs the setter on a given structure and value to yield a new structure.
    public func set(from: A?, _ to: B) -> A? {
        return from.map { (a: A) -> A in setter(a, to) }
    }
    
    /// Runs the setter on a given structure and value to yield a new structure.
    public func set(from: A, _ to: B?) -> A? {
        return to.map { (b: B) -> A in setter(from, b) }
    }
    
    /// Runs the setter on a given structure and value to yield a new structure.
    public func set(from: A?, _ to: B?) -> A? {
        if let a = from, b = to {
            return setter(a, b)
        } else {
            return nil
        }
    }
    
    /// Transform the value of the retrieved field by a function.
    public func modify(from: A, f: B -> B) -> A {
        return set(from, f(get(from)))
    }
}

// MARK: - Creator

extension Lens {
    
    /// Composes a `Lens` with the receiver.
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
    
    /// Creates a `Lens` that focuses on array structures.
    public func lift() -> Lens<[A], [B]> {
        return Lens<[A], [B]>(
            getter: { (xs: [A]) -> [B] in
                xs.map(self.get)
            },
            setter: { (xs: [A], ys: [B]) -> [A] in
                zip(xs, ys).map(self.set)
            }
        )
    }
}

// MARK: - Operator

public func >>> <A, B, C>(lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    return lhs.compose(rhs)
}

public func <<< <A, B, C>(lhs: Lens<B, C>, rhs: Lens<A, B>) -> Lens<A, C> {
    return rhs.compose(lhs)
}
